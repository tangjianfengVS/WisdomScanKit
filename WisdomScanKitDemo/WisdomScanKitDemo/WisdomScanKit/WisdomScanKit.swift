//
//  WisdomScanKit.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import AVFoundation
import Photos

class WisdomScanKit: NSObject {
    
    /**
     *     图片浏览器:
     *     beginImage  :  当前展示的图片
     *     beginIndex  :  beginImage 在 imageList集合的下标
     *     imageList   :  展示图片集合
     *     beginRect   :  开始展示动画的Frame
     */
    @objc public class func startPhotoChrome(beginImage: UIImage?,
                                             beginIndex: Int,
                                             imageList: [UIImage],
                                             beginRect: CGRect) {
        let window = UIApplication.shared.keyWindow
        var imageListNew = imageList
        var imageRect = beginRect
        
        if imageList.count == 0 && beginImage != nil {
            imageListNew.append(beginImage!)
        }
        
        if imageRect == .zero{
            imageRect = CGRect(x: 5,y: 70,width: ItemSize, height: ItemSize)
        }
    
        let hud = WisdomPhotoChromeHUD(beginIndex: beginIndex, imageList: imageListNew, beginRect: imageRect)
        window?.addSubview(hud)
    }
    
    /**
     *     图片选择编辑器:
     *     rootVC      :  父类调用控制器
     *     imageList   :  图片集合
     *     beginCenter :  开始展示的动画中心点
     *     beginSize   :  开始展示的动画大小
     *     endTask     :  完成回调task
     */
    @objc public class func startPhotoEdit(rootVC: UIViewController,
                                           imageList: [UIImage],
                                           beginCenter: CGPoint,
                                           beginSize: CGSize,
                                           endTask: @escaping ((Bool,[UIImage])->())) {
        let editVC = WisdomPhotoEditVC(imageList: imageList,
                                       beginCenters:beginCenter,
                                       beginSizse: beginSize,
                                       endTask: endTask)
        editVC.view.frame = rootVC.view.frame
        rootVC.addChild(editVC)
        rootVC.view.addSubview(editVC.view)
        
        let scbl = beginSize.width/rootVC.view.bounds.width
        let ydblW = rootVC.view.center.x-beginCenter.x
        let ydblY = -rootVC.view.center.y+beginCenter.y
        
        editVC.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
        editVC.view.transform = editVC.view.transform.scaledBy(x: scbl, y: scbl)
        
        UIView.animate(withDuration: 0.35, animations: {
            editVC.view.transform = .identity
        })
    }
    
    /**
     *   计算填充屏幕尺寸:
     *   说明：以填充屏幕尺寸为目标， 计算原声图片在屏幕上的Rect
     */
    @objc class func getImageChromeRect(image: UIImage) -> CGRect {
        let bounds = UIScreen.main.bounds
        if image.size.width == image.size.height {
            return CGRect(x: 0,
                          y: (bounds.height - bounds.width)/2,
                          width: bounds.size.width,
                          height: bounds.size.width)
        }else if image.size.width < bounds.width && image.size.height < bounds.height{
            
            if (bounds.size.height - image.size.height) > (bounds.size.width - image.size.width){
                let height = image.size.height/image.size.width * bounds.width
                return CGRect(x: 0,y: (bounds.height - height)/2, width: bounds.size.width,height: height)
            }else{
                let width = image.size.width/image.size.height * bounds.height
                return CGRect(x: (bounds.size.width - width)/2,y: 0, width: width,height: bounds.size.height)
            }
        }else if image.size.width > bounds.width && image.size.height > bounds.height {
            let wB = image.size.width/bounds.width
            let hB = image.size.height/bounds.height
            if wB > hB{
                let height = image.size.height/image.size.width * bounds.width
                return CGRect(x: 0,y: (bounds.height - height)/2,width: bounds.width,height: height)
            }else{
                let width = image.size.width/image.size.height * bounds.height
                return CGRect(x: (bounds.width - width)/2, y: 0, width: width, height: bounds.height)
            }
        }else if image.size.width > bounds.width && image.size.height <= bounds.height {
            
            let height = image.size.height/image.size.width * bounds.width
            return CGRect(x: 0,y: (bounds.height - height)/2,width: bounds.width,height: height)
        }else if image.size.width < bounds.width && image.size.height >= bounds.height {
            
            let width = image.size.width/image.size.height * bounds.height
            return CGRect(x: (bounds.width - width)/2, y: 0,width: width,height: bounds.height)
        }
        return CGRect(x: (bounds.size.width - image.size.width)/2,
                      y: (bounds.size.height - image.size.height)/2,
                      width: image.size.width,
                      height: image.size.height)
    }
    
    /** 获取摄像状态权限 */
    @objc class func authorizationStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
    
    /** 内部跳转系统设置 */
    @objc class func authorizationScan() {
        let url = URL(string: UIApplication.openSettingsURLString)
        
        if url != nil && UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.openURL(url!)
        }
    }
    
    /** 相册权限 */
    @objc class func authorizationPhoto()->PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    /** Flashlight operation */
    class func turnTorchOn(light: Bool){
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else{
            if light{
                //ZHInvestScanManager.confirm(title: "温馨提示", message: "闪光灯不可用", controller: self)
            }
            return
        }
        if device.hasTorch{
            do{
                try device.lockForConfiguration()
                if light && device.torchMode == .off{
                    device.torchMode = .on
                }
                if !light && device.torchMode == .on{
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }catch{
                
            }
        }
    }
    
    /** bundle图片 */
    class func bundleImage(name: String)-> UIImage {
        let bundle = Bundle.init(path:Bundle.init(for: WisdomScanKit.self).path(forResource: "WisdomScanKit", ofType: "bundle")!)!
        let url = bundle.path(forResource: name, ofType: "png")! 
        let image = UIImage(contentsOfFile: url)!
        return image
    }
}
