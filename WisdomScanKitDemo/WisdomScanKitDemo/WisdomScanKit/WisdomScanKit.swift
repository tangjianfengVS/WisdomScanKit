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
}
