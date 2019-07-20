//
//  WisdomScanManager.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/17.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import UIKit
import Photos

public enum WisdomScanManager {
    
    ///System album picture display,select
    static func startElectSystemPhoto(rootVC:    UIViewController,
                                      startType: StartTransformType,
                                      countType: ElectPhotoCountType,
                                      theme:     ElectPhotoTheme,
                                      delegate:  ElectPhotoDelegate?,
                                      photoTask: @escaping WisdomPhotoTask,
                                      errorTask: @escaping WisdomErrorTask) -> WisdomPhotoSelectVC{
        let selectVC = WisdomPhotoSelectVC(startTypes: startType, countTypes: countType, colorTheme:theme, delegates:delegate, photoTasks: photoTask, errorTasks: errorTask)
        
        var transform = TransformAnimation(rootVC: rootVC, transformVC: selectVC, startType: startType)
        selectVC.isCreatNav = transform.startTransform(needNav: true)
        return selectVC
    }

    
    /// Scan RQCode
    static func startScanRQCode(rootVC:      UIViewController,
                                startType:   StartTransformType,
                                themeType:   WisdomRQCodeThemeType,
                                navDelegate: WisdomScanNavbarDelegate?,
                                answerTask:  @escaping WisdomRQCodeFinishTask,
                                errorTask:   @escaping WisdomRQCodeErrorTask) -> WisdomRQCodeVC {
        let rqCodeVC = WisdomRQCodeVC(startTypes: startType, themeTypes: themeType, navDelegate: navDelegate, answerTasks: answerTask, errorTasks: errorTask)
        
        var transform = TransformAnimation(rootVC: rootVC, transformVC: rqCodeVC, startType: startType)
        rqCodeVC.isCreatNav = transform.startTransform(needNav: true)
        return rqCodeVC
    }
    
    
    /// Scan Photos
    static func startScanPhoto(rootVC:     UIViewController,
                               startType:  StartTransformType,
                               countType:  ElectPhotoCountType,
                               photosTask: @escaping WisdomPhotoTask,
                               errorTask:  @escaping WisdomErrorTask) -> WisdomPhotosVC {
        let photosVC = WisdomPhotosVC(startTypes: startType, countTypes: countType,photoTasks: photosTask,errorTasks: errorTask)
        
        var transform = TransformAnimation(rootVC: rootVC, transformVC: photosVC, startType: startType)
        let _ = transform.startTransform(needNav: false)
        return photosVC
    }
    
    
    /// Image browser ‘[UIImage]’
    static func startPhotoChrome(startIconIndex: Int,
                                 startIconAnimatRect: CGRect,
                                 iconList: [UIImage]) -> WisdomPhotoChromeHUD {
        let window = UIApplication.shared.keyWindow
        let hud = WisdomPhotoChromeHUD(beginIndex: startIconIndex, imageList: iconList, beginRect: startIconAnimatRect)
        
        window?.addSubview(hud)
        return hud
    }
    
    
    /// Image browser ‘PHFetchResult<PHAsset>’
    static func startPhotoChrome(startIconIndex: Int,
                                 startIconAnimatRect: CGRect,
                                 fetchResult: PHFetchResult<PHAsset>) -> WisdomPhotoChromeHUD {
        let window = UIApplication.shared.keyWindow
        let hud = WisdomPhotoChromeHUD(beginIndex: startIconIndex, fetchResults: fetchResult, beginRect: startIconAnimatRect)
        
        window?.addSubview(hud)
        return hud
    }
    
    
    /// Image selection editor
    static func startPhotoEdit(rootVC:               UIViewController,
                               imageList:            [UIImage],
                               startIconAnimatRect:  CGRect,
                               colorTheme:           ElectPhotoTheme,
                               finishTask: @escaping (Bool, [UIImage])->()) -> WisdomPhotoEditVC {
        let editVC = WisdomPhotoEditVC(imageList: imageList, startIconAnimatRect: startIconAnimatRect, colorTheme: colorTheme, endTask: finishTask)
        
        let transformType: StartTransformType = (startIconAnimatRect != CGRect.zero) ? .zoomLoc : .push
        var transform = TransformAnimation(rootVC: rootVC, transformVC: editVC, startType: transformType)
        transform.startIconAnimatRect = startIconAnimatRect
        let _ = transform.startTransform(needNav: false)
        return editVC
    }
    
    
    /// get bundle imgae
    static func bundleImage(name: String) -> UIImage {
        let bundle = Bundle.init(path:Bundle.init(for: WisdomScanKit.self).path(forResource: "WisdomScanKit", ofType: "bundle")!)!
        let url = bundle.path(forResource: name, ofType: "png")!
        let image = UIImage(contentsOfFile: url)!
        return image
    }
    
    
    /// Flashlight operation
    static func turnTorchOn(light: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else{
            if light{ }
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
