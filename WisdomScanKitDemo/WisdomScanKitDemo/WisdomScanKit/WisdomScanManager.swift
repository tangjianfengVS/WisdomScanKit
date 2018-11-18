//
//  WisdomScanManager.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation

class WisdomScanManager: NSObject {
    
    class func authorizationStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
    
    class func authorizationScan() {
        let url = URL(string: UIApplication.openSettingsURLString)
        
        if url != nil && UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.openURL(url!)
        }
    }
    
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
}

extension UIViewController {
    
    /**  拍照  */
    public func startScanPhotos(type: WisdomScanningType,
                                photosTypes: WisdomPhotosType?,
                                photosTask: @escaping WisdomPhotosTask,
                                errorTask: @escaping WisdomErrorTask) {
        
        let photosVC = WisdomPhotosVC(types: type,
                                      photosTypes: photosTypes,
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
    
    /**  扫码  */
    public func startScanRQCode(type: WisdomScanningType,
                                themeTypes: WisdomRQCodeThemeType?,
                                navBarTask: WisdomNavBarTask,
                                answerTask: @escaping WisdomAnswerTask,
                                errorTask: @escaping WisdomErrorTask ) {
        
        let rqCodeVC = WisdomRQCodeVC(types: type,
                                      themeTypes: themeTypes,
                                      navBarTasks: navBarTask,
                                      answerTasks: answerTask,
                                      errorTasks: errorTask)
        switch type {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(rqCodeVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(rqCodeVC, animated: true)
            }else{
                push(rqCodeVC: rqCodeVC, hideNavBar: rqCodeVC.hideNavBar)
            }
        case .present:
            var rootVC: UIViewController = rqCodeVC
            if !rqCodeVC.hideNavBar {
                let nav = UINavigationController(rootViewController: rqCodeVC)
                rqCodeVC.isCreatNav = true
                rootVC = nav
            }
            present(rootVC, animated: true, completion: nil)
        }
    }
    
    /** 界面提示 */
    public func showAlert(title: String,
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
            let rightAction = UIAlertAction(title: rightActionTitle, style: .default, handler: { action in
                handler(action)
            })
            alert.addAction(rightAction)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension UIViewController {
    fileprivate func push(rqCodeVC: WisdomRQCodeVC, hideNavBar: Bool) {
        var rootVC: UIViewController = rqCodeVC
        if !hideNavBar {
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
