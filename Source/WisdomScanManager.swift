//
//  WisdomScanManager.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/17.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import UIKit
import Photos
import WisdomHUD


extension WisdomScanManager: WisdomScanAuthorizeable {
    
    static func getCameraAuthorize()->AVAuthorizationStatus{
        .authorized
    }
    
    static func getPhotoAuthorize()->PHAuthorizationStatus{
        .authorized
    }
    
    static func openSystemSetting()->Bool {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return true
        }
        return false
    }
}

extension WisdomScanManager: WisdomScanPhotoChromeable {
    
    static func startPhotoChrome(startIndex: Int, startAnimaRect: CGRect, images: [UIImage], theme: WisdomScanThemeStyle, didChromeClosure: ((Int)->(CGRect))?) {
        let viewList = WisdomScanManager.getTransformView()
        let hud = WisdomPhotoChromeHUD(beginIndex: startIndex, beginRect: startAnimaRect, images: images, transformView: viewList.Cover, theme: theme, didChromeClosure: didChromeClosure)
        
        viewList.Root.addSubview(hud)
    }
    
    static func startPhotoChrome(startIndex: Int, startAnimaRect: CGRect, assets: PHFetchResult<PHAsset>, theme: WisdomScanThemeStyle, didChromeClosure: ((Int)->(CGRect))?) {
        let viewList = WisdomScanManager.getTransformView()
        let hud = WisdomPhotoChromeHUD(beginIndex: startIndex, beginRect: startAnimaRect, assets: assets, transformView: viewList.Cover, theme: theme, didChromeClosure: didChromeClosure)
        
        viewList.Root.addSubview(hud)
    }
    
    static func photoChrome(title: String?, images: [UIImage], rootVC: UIViewController, transform: WisdomScanTransformStyle, theme: WisdomScanThemeStyle) {
        let chromeVC = WisdomPhotoChromeVC(title: title, images: images, transform: transform, theme: theme)
        var transform = WisdomScanTransformAnim(rootVC: rootVC, transform: transform)
        transform.startTransform(transformVC: chromeVC, needNav: true)
    }
    
    static func photoLibraryChrome(title: String?, rootVC: UIViewController, transform: WisdomScanTransformStyle, theme: WisdomScanThemeStyle){
        let chromeVC = WisdomPhotoChromeVC(title: title, transform: transform, theme: theme)
        var transform = WisdomScanTransformAnim(rootVC: rootVC, transform: transform)
        transform.startTransform(transformVC: chromeVC, needNav: true)
    }
}

extension WisdomScanManager: WisdomScanPhotoElectable {
    
    static func photoElect(title: String?, images: [UIImage], electCount: WisdomScanCountStyle, rootVC: UIViewController, transform: WisdomScanTransformStyle, theme: WisdomScanThemeStyle, electClosure: @escaping ([UIImage])->()){
        let chromeVC = electCount == .normal ? WisdomPhotoSelectBaseVC(title: title, images: images, transform: transform, theme: theme, electClosure: electClosure) : WisdomPhotoSelectVC(title: title, images: images, electCount: electCount, transform: transform, theme: theme, electClosure: electClosure)
        var transform = WisdomScanTransformAnim(rootVC: rootVC, transform: transform)
        transform.startTransform(transformVC: chromeVC, needNav: true)
    }
    
    static func photoLibraryElect(title: String?, electCount: WisdomScanCountStyle, rootVC: UIViewController, transform: WisdomScanTransformStyle, theme: WisdomScanThemeStyle, electClosure: @escaping ([UIImage])->()){
        let chromeVC = electCount == .normal ? WisdomPhotoSelectBaseVC(title: title, transform: transform, theme: theme, electClosure: electClosure) : WisdomPhotoSelectVC(title: title, electCount: electCount, transform: transform, theme: theme, electClosure: electClosure)
        var transform = WisdomScanTransformAnim(rootVC: rootVC, transform: transform)
        transform.startTransform(transformVC: chromeVC, needNav: true)
    }
    
    
}


public enum WisdomScanManager {
//    /// Scan RQCode
//    static func startScanRQCode(rootVC:     UIViewController,
//                                startType:  StartTransformType,
//                                themeType:  WisdomRQCodeThemeType,
//                                delegate:   ScanRQCodeDelegate?,
//                                answerTask: @escaping WisdomRQCodeFinishTask,
//                                errorTask:  @escaping WisdomRQCodeErrorTask) -> WisdomRQCodeVC {
//        let rqCodeVC = WisdomRQCodeVC(startTypes: startType, themeTypes: themeType, navDelegate: delegate, answerTasks: answerTask, errorTasks: errorTask)
//
//        var transform = TransformAnimation(rootVC: rootVC, transformVC: rqCodeVC, startType: startType)
//        rqCodeVC.isCreatNav = transform.startTransform(needNav: true)
//        return rqCodeVC
//    }
//
//
//    /// Scan Photos
//    static func startScanPhoto(rootVC:     UIViewController,
//                               startType:  StartTransformType,
//                               countType:  ElectPhotoCountType,
//                               electTheme: ElectPhotoTheme,
//                               photosTask: @escaping WisdomPhotoTask) -> WisdomPhotosVC {
//        let photosVC = WisdomPhotosVC(startTypes: startType, countTypes: countType, electTheme:electTheme, photoTasks: photosTask)
//
//        var transform = TransformAnimation(rootVC: rootVC, transformVC: photosVC, startType: startType)
//        let _ = transform.startTransform(needNav: false)
//        return photosVC
//    }
//
//    /// Image selection editor
//    static func startPhotoEdit(rootVC:               UIViewController,
//                               imageList:            [UIImage],
//                               startIconAnimatRect:  CGRect,
//                               colorTheme:           ElectPhotoTheme,
//                               finishTask: @escaping (Bool, [UIImage])->()) -> WisdomPhotoEditVC {
//        let editVC = WisdomPhotoEditVC(imageList: imageList, startIconAnimatRect: startIconAnimatRect, colorTheme: colorTheme, endTask: finishTask)
//        
//        var transform = TransformAnimation(rootVC: rootVC, transformVC: editVC)
//        transform.startIconAnimatRect = startIconAnimatRect
//        let _ = transform.startTransform(needNav: false)
//        return editVC
//    }
    
    
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


extension WisdomScanManager {
    
    static func getTransformView() -> (Root: UIView, Cover: UIView) {
        let window = WisdomHUD.getScreenWindow()
        
        let rootView = UIView(frame: UIScreen.main.bounds)
        rootView.backgroundColor = UIColor.clear
        
        let coverView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.init(white: 0.90, alpha: 1)
            return view
        }()
        
        window?.addSubview(rootView)
        rootView.addSubview(coverView)
        return (rootView, coverView)
    }
}
