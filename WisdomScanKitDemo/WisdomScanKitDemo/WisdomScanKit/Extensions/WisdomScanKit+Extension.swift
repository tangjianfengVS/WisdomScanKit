//
//  WisdomScanKit+Extension.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

extension UIViewController {
    
//    /**
//     *     全屏拍摄图片（支持设置张数）:
//     *     WisdomScanningType:   ScannPhotos跳转动画类型
//     *     WisdomPhotosType  :   ScannPhotos数量类型
//     *     WisdomPhotosTask  :   ScannPhotos完成回调
//     *     WisdomErrorTask   :   ScannPhotos失败错误回调
//     */
//    @discardableResult
//    @objc public func startScanPhoto(startType: StartTransformType,
//                                     countType: ElectPhotoCountType,
//                                     photosTask: @escaping WisdomPhotoTask,
//                                     errorTask: @escaping WisdomErrorTask)-> WisdomPhotosVC{
//
//        let photosVC = WisdomPhotosVC(startTypes: startType,
//                                      countTypes: countType,
//                                      photoTasks: photosTask,
//                                      errorTasks: errorTask)
//        switch startType {
//        case .push:
//            if isKind(of: UINavigationController.self){
//                (self as! UINavigationController).pushViewController(photosVC, animated: true)
//            }else if navigationController != nil {
//                navigationController!.pushViewController(photosVC, animated: true)
//            }else{
//                push(rootVC: photosVC)
//            }
//        case .present:
//            present(photosVC, animated: true, completion: nil)
//        }
//        return photosVC
//    }
    
//    /**
//     *     二维码扫描 ScanRQCode:
//     *     WisdomScanningType      :   ScanRQCode跳转动画类型
//     *     WisdomRQCodeThemeType   :   ScanRQCode主题风格
//     *     WisdomScanNavbarDelegate:   ScanRQCode导航栏代理，不需要显示导航栏传nil
//     *     WisdomRQCodeFinishTask  :   ScanRQCode 完成回调
//     *     WisdomRQCodeErrorTask   :   ScanRQCode 失败回调
//     */
//    @discardableResult
//    @objc public func startScanRQCode(startType: StartTransformType,
//                                      themeType: WisdomRQCodeThemeType,
//                                      navDelegate: WisdomScanNavbarDelegate?,
//                                      answerTask: @escaping WisdomRQCodeFinishTask,
//                                      errorTask: @escaping WisdomRQCodeErrorTask)-> WisdomRQCodeVC {
//
//        let rqCodeVC = WisdomRQCodeVC(startTypes: startType,
//                                      themeTypes: themeType,
//                                      navDelegate: navDelegate,
//                                      answerTasks: answerTask,
//                                      errorTasks: errorTask)
//        switch startType {
//        case .push:
//            if isKind(of: UINavigationController.self){
//                (self as! UINavigationController).pushViewController(rqCodeVC, animated: true)
//            }else if navigationController != nil {
//                navigationController!.pushViewController(rqCodeVC, animated: true)
//            }else{
//                push(rqCodeVC: rqCodeVC, navDelegate: navDelegate)
//            }
//        case .present:
//            var rootVC: UIViewController = rqCodeVC
//            if navDelegate != nil {
//                let nav = UINavigationController(rootViewController: rqCodeVC)
//                rqCodeVC.isCreatNav = true
//                rootVC = nav
//            }
//            present(rootVC, animated: true, completion: nil)
//        }
//        return rqCodeVC
//    }
    
    
    
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


extension UIColor {
    
    public func asImage(_ size: CGSize) -> UIImage? {
        var resultImage: UIImage? = nil
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return resultImage
        }
        
        context.setFillColor(self.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}


extension UIImage {
    /**
     *   计算填充屏幕尺寸:
     *   说明：以填充屏幕尺寸为目标， 计算原声图片在屏幕上的Rect
     */
    @objc func getImageChromeRect() -> CGRect {
        let bounds = UIScreen.main.bounds
        if size.width == size.height {
            return CGRect(x: 0,
                          y: (bounds.height - bounds.width)/2,
                          width: bounds.size.width,
                          height: bounds.size.width)
        }else if size.width < bounds.width && size.height < bounds.height{
            
            if (bounds.size.height - size.height) > (bounds.size.width - size.width){
                let height = size.height/size.width * bounds.width
                return CGRect(x: 0,y: (bounds.height - height)/2, width: bounds.size.width,height: height)
            }else{
                let width = size.width/size.height * bounds.height
                return CGRect(x: (bounds.size.width - width)/2,y: 0, width: width,height: bounds.size.height)
            }
        }else if size.width > bounds.width && size.height > bounds.height {
            let wB = size.width/bounds.width
            let hB = size.height/bounds.height
            if wB > hB{
                let height = size.height/size.width * bounds.width
                return CGRect(x: 0,y: (bounds.height - height)/2,width: bounds.width,height: height)
            }else{
                let width = size.width/size.height * bounds.height
                return CGRect(x: (bounds.width - width)/2, y: 0, width: width, height: bounds.height)
            }
        }else if size.width > bounds.width && size.height <= bounds.height {
            
            let height = size.height/size.width * bounds.width
            return CGRect(x: 0,y: (bounds.height - height)/2,width: bounds.width,height: height)
        }else if size.width < bounds.width && size.height >= bounds.height {
            
            let width = size.width/size.height * bounds.height
            return CGRect(x: (bounds.width - width)/2, y: 0,width: width,height: bounds.height)
        }
        return CGRect(x: (bounds.size.width - size.width)/2,
                      y: (bounds.size.height - size.height)/2,
                      width: size.width,
                      height: size.height)
    }
}
