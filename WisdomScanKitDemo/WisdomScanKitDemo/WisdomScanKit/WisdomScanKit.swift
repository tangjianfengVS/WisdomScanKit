//
//  WisdomScanKit.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class WisdomScanKit: NSObject {
    /** 获取摄像状态权限 */
    class func authorizationStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
    
    /** 内部跳转系统设置 */
    class func authorizationScan() {
        let url = URL(string: UIApplication.openSettingsURLString)
        
        if url != nil && UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.openURL(url!)
        }
    }
    
    /** 手电筒操作 */
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
    
    /** 相册权限 */
    class func authorizationPhoto()->PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    /** bundle图片 */
    class func bundleImage(name: String)-> UIImage {
        let bundle = Bundle.init(path:Bundle.init(for: WisdomScanKit.self).path(forResource: "WisdomScanKit", ofType: "bundle")!)!
        let url = bundle.path(forResource: name, ofType: "png")! 
        let image = UIImage(contentsOfFile: url)!
        return image
    }
    
    /** 系统返回的相册集名称为英文，我们需要转换为中文 */
    class func titleOfAlbumForChinse(title: String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
}

extension UIViewController {
    fileprivate func push(rqCodeVC: WisdomRQCodeVC, navDelegate: WisdomScanNavbarDelegate?) {
        var rootVC: UIViewController = rqCodeVC
        if navDelegate != nil {
            let nav = UINavigationController(rootViewController: rqCodeVC)
            rqCodeVC.isCreatNav = true
            rootVC = nav
        }
        push(rootVC: rootVC)
    }
    
    fileprivate func push(rootVC: UIViewController) {
        addChild(rootVC)
        view.addSubview(rootVC.view)
        rootVC.view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.35) {
            rootVC.view.transform = .identity
        }
    }
}

extension UIViewController {
    /**
     *     ScannPhotos拍摄图片，支持拍摄多张:
     *     WisdomScanningType:   ScannPhotos跳转动画类型
     *     WisdomPhotosType  :   ScannPhotos数量类型
     *     WisdomPhotosTask  :   ScannPhotos完成回调
     *     WisdomErrorTask   :   ScannPhotos失败错误回调
     */
    @objc public func startScanPhotos(type: WisdomScanningType,
                                      photoCountType: WisdomPhotosCountType,
                                      photosTask: @escaping WisdomPhotosTask,
                                      errorTask: @escaping WisdomErrorTask) {
        
        let photosVC = WisdomPhotosVC(types: type,
                                      photoCountTypes: photoCountType,
                                      photosTasks: photosTask,
                                      errorTasks: errorTask)
        switch type {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(photosVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(photosVC, animated: true)
            }else{
                push(rootVC: photosVC)
            }
        case .present:
            present(photosVC, animated: true, completion: nil)
        }
    }
    
    /**
     *     扫二维码(ScanRQCode) :
     *     WisdomScanningType      :   ScanRQCode跳转动画类型
     *     WisdomRQCodeThemeType   :   ScanRQCode主题风格
     *     WisdomScanNavbarDelegate:   ScanRQCode导航栏代理，不需要显示导航栏传nil
     *     WisdomRQCodeAnswerTask  :   ScanRQCode 完成回调
     *     WisdomRQCodeErrorTask   :   ScanRQCode 失败回调
     */
    @objc public func startScanRQCode(type: WisdomScanningType,
                                      themeTypes: WisdomRQCodeThemeType,
                                      navDelegate: WisdomScanNavbarDelegate?,
                                      answerTask: @escaping WisdomRQCodeAnswerTask,
                                      errorTask: @escaping WisdomRQCodeErrorTask) {
        
        let rqCodeVC = WisdomRQCodeVC(types: type,
                                      themeTypes: themeTypes,
                                      navDelegate: navDelegate,
                                      answerTasks: answerTask,
                                      errorTasks: errorTask)
        switch type {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(rqCodeVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(rqCodeVC, animated: true)
            }else{
                push(rqCodeVC: rqCodeVC, navDelegate: navDelegate)
            }
        case .present:
            var rootVC: UIViewController = rqCodeVC
            if navDelegate != nil {
                let nav = UINavigationController(rootViewController: rqCodeVC)
                rqCodeVC.isCreatNav = true
                rootVC = nav
            }
            present(rootVC, animated: true, completion: nil)
        }
    }
    
    /**
     *     获取系统相册图片 :
     *     WisdomSetectPhotoType   :
     *     WisdomSetectPhotoType   :
     *     WisdomPhotosCountType   :
     *     WisdomScanNavbarDelegate:  ScanRQCode导航栏代理，不需要显示导航栏传nil
     *     WisdomPhotosTask        :
     *     WisdomErrorTask         :
     */
    @objc public func startSelectSystemPhoto(type: WisdomScanningType,
                                             setectTypes: WisdomSetectPhotoType,
                                             photoCountTypes: WisdomPhotosCountType,
                                             navDelegate: WisdomScanNavbarDelegate?,
                                             photoTasks: @escaping WisdomPhotosTask,
                                             errorTasks: @escaping WisdomErrorTask) {
        
        let selectVC = WisdomPhotoSelectVC(types: type,
                                           setectTypes: setectTypes,
                                           photoCountTypes: photoCountTypes,
                                           navDelegate: navDelegate,
                                           photoTasks: photoTasks,
                                           errorTasks: errorTasks)
        switch type {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(selectVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(selectVC, animated: true)
            }else{
                //push(rqCodeVC: selectVC, navDelegate: navDelegate)
            }
        case .present:
            var rootVC: UIViewController = selectVC
            if navDelegate != nil {
                let nav = UINavigationController(rootViewController: selectVC)
                selectVC.isCreatNav = true
                rootVC = nav
            }
            present(rootVC, animated: true, completion: nil)
        }
    }
    
    /** 系统界面提示 */
    @objc public func showAlert(title: String,
                                message: String,
                                cancelActionTitle: String?,
                                rightActionTitle: String?,
                                handler: @escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelActionTitle != nil {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        if rightActionTitle != nil {
            let rightAction = UIAlertAction(title: rightActionTitle, style: UIAlertAction.Style.default, handler: { action in
                handler(action)
            })
            alert.addAction(rightAction)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
