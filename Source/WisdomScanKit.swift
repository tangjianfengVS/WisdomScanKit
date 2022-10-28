//
//  WisdomScanKit.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

@objc public final class WisdomScanKit: NSObject {
    
    @available(*, unavailable)
    override init() {}
}


extension WisdomScanKit: WisdomScanPhotoChromeable {
    
    // MARK: Photo Chrome Custom Images: WisdomPhotoChromeHUD
    /*
     * startIndex      : image in '[UIImage]' index
     * startAnimaRect  : show image begin animation 'CGRect'
     * images          : custom '[UIImage]' data
     * theme           : ui theme color style 'WisdomScanThemeStyle'
     * didChromeClosure: callback in photo chrome '((Int)->(CGRect))?)'
     */
    @objc public static func startPhotoChrome(startIndex      : Int,
                                              startAnimaRect  : CGRect,
                                              images          : [UIImage],
                                              theme           : WisdomScanThemeStyle,
                                              didChromeClosure: ((Int)->(CGRect))?) {
        WisdomScanManager.startPhotoChrome(startIndex: startIndex,
                                           startAnimaRect: startAnimaRect,
                                           images: images,
                                           theme: theme,
                                           didChromeClosure: didChromeClosure)
    }
    
    // MARK: Photo Chrome System PHAssets: WisdomPhotoChromeHUD
    /*
     * startIndex      : image in '[UIImage]' index
     * startAnimaRect  : show image begin animation 'CGRect'
     * assets          : systom 'PHFetchResult<PHAsset>' data
     * theme           : ui theme color style 'WisdomScanThemeStyle'
     * didChromeClosure: callback in photo chrome '((Int)->(CGRect))?)'
     */
    @objc public static func startPhotoChrome(startIndex      : Int,
                                              startAnimaRect  : CGRect,
                                              assets          : PHFetchResult<PHAsset>,
                                              theme           : WisdomScanThemeStyle,
                                              didChromeClosure: ((Int)->(CGRect))?) {
        WisdomScanManager.startPhotoChrome(startIndex: startIndex,
                                           startAnimaRect: startAnimaRect,
                                           assets: assets,
                                           theme: theme,
                                           didChromeClosure: didChromeClosure)
    }
    
    // MARK: Photo Chrome Custom Images Transform: UIViewController - WisdomPhotoChromeHUD
    /*
     * title     : ui navbar title
     * images    : custom '[UIImage]' data
     * rootVC    : wake up 'UIViewController'
     * transform : vc transform style 'WisdomScanTransformStyle'
     * theme     : ui theme color style 'WisdomScanThemeStyle'
     */
    @objc public static func photoChrome(title    : String?=nil,
                                         images   : [UIImage],
                                         rootVC   : UIViewController,
                                         transform: WisdomScanTransformStyle = .push,
                                         theme    : WisdomScanThemeStyle = .light) {
        WisdomScanManager.photoChrome(title: title, images: images, rootVC: rootVC, transform: transform, theme: theme)
    }
    
    // MARK: Photo Chrome Systom Library Transform: UIViewController - WisdomPhotoChromeHUD
    /*
     * title     : navbar title
     * rootVC    : wake up 'UIViewController'
     * transform : vc transform style 'WisdomScanTransformStyle'
     * theme     : ui theme color style 'WisdomScanThemeStyle'
     */
    @objc public static func photoLibraryChrome(title    : String?=nil,
                                                rootVC   : UIViewController,
                                                transform: WisdomScanTransformStyle = .push,
                                                theme    : WisdomScanThemeStyle = .light) {
        WisdomScanManager.photoLibraryChrome(title: title, rootVC: rootVC, transform: transform, theme: theme)
    }
}

extension WisdomScanKit: WisdomScanPhotoElectable {
    
    // MARK: Photo Elect Custom Images Transform: UIViewController - WisdomPhotoChromeHUD
    /*
     * title     : ui navbar title
     * images    : custom '[UIImage]' data
     * electCount: elect count style 'WisdomScanCountStyle'
     * rootVC    : wake up 'UIViewController'
     * transform : vc transform style 'WisdomScanTransformStyle'
     * theme     : ui theme color style 'WisdomScanThemeStyle'
     */
    static func photoElect(title     : String?=nil,
                           images    : [UIImage],
                           electCount: WisdomScanCountStyle = .one,
                           rootVC    : UIViewController,
                           transform : WisdomScanTransformStyle = .push,
                           theme     : WisdomScanThemeStyle = .light) {
        WisdomScanManager.photoElect(title: title, images: images, electCount: electCount, rootVC: rootVC, transform: transform, theme: theme)
    }
    
    // MARK: Photo Elect Systom Library Transform: UIViewController - WisdomPhotoChromeHUD
    /*
     * title     : ui navbar title
     * electCount: elect count style 'WisdomScanCountStyle'
     * rootVC    : wake up 'UIViewController'
     * transform : vc transform style 'WisdomScanTransformStyle'
     * theme     : ui theme color style 'WisdomScanThemeStyle'
     */
    static func photoLibraryElect(title     : String?=nil,
                                  electCount: WisdomScanCountStyle = .one,
                                  rootVC    : UIViewController,
                                  transform : WisdomScanTransformStyle = .push,
                                  theme     : WisdomScanThemeStyle = .light) {
        WisdomScanManager.photoLibraryElect(title: title, electCount: electCount, rootVC: rootVC, transform: transform, theme: theme)
    }
}



//    // MARK: - Get camera status permissions status
//
//    /// 获取摄像状态权限
//    @objc class func authorizationStatus() -> AVAuthorizationStatus {
//        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//    }
//
//
//
//    // MARK: - Internal jump system Settings
//
//    /// 内部跳转系统设置
//    @objc class func authorizationScan() {
//        let url = URL(string: UIApplication.openSettingsURLString)
//
//        if url != nil && UIApplication.shared.canOpenURL(url!){
//            UIApplication.shared.openURL(url!)
//        }
//    }
//
//
//
//    // MARK: - Get album permission status
//
//    /// 相册权限
//    @objc class func authorizationPhoto() -> PHAuthorizationStatus {
//        return PHPhotoLibrary.authorizationStatus()
//    }
//
//
//
//    // MARK: - WisdomScanKit down load image with imageUrl
//
//    /// down load image
//    @objc public class func downLoadImage(imageUrl: URL, successClosure: ((URL)->())?, failedClosure: ((URL)->())?) {
//        UIImageView.downLoadImage(imageUrl: imageUrl, successClosure: successClosure, failedClosure: failedClosure)
//    }
//
//}
//
//
//
//extension UIViewController {
//
//    // MARK: - startElectSystemPhoto
//
//    /// 跳转加载系统相册图片浏览器，并选择图片
//    ///
//    /// - Parameters:
//    ///   - startType:    The `StartTransformType` value.                (系统相册跳转动画类型)
//    ///   - countType:    The `ElectPhotoCountType`, `once` by default.  (选取数量类型)
//    ///   - theme:        The `ElectPhotoTheme`, `whiteLight` by default.(UI主题风格)
//    ///   - delegate:     The `ElectPhotoDelegate`, custom navbar item.
//    ///   - photoTask:    The `WisdomPhotoTask`, back images array.      (完成回调)
//    ///
//    /// - Returns: The created `WisdomPhotoSelectVC`.
//    @discardableResult
//    @objc public func startElectSystemPhoto(startType: StartTransformType = .present,
//                                            countType: ElectPhotoCountType = .nine,
//                                            theme:     ElectPhotoTheme = .whiteLight,
//                                            delegate:  ElectPhotoDelegate? = nil,
//                                            photoTask: @escaping WisdomPhotoTask) -> WisdomPhotoSelectVC {
//        return WisdomScanManager.startElectSystemPhoto(rootVC: self,
//                                                       startType: startType,
//                                                       countType: countType,
//                                                       theme:     theme,
//                                                       delegate:  delegate,
//                                                       photoTask: photoTask)
//    }
//
//
//
//    // MARK: - startScanRQCode
//
//    /// 二维码扫描 ScanRQCode
//    ///
//    /// - Parameters:
//    ///   - startType:    The `StartTransformType` value.                  (系统相册跳转动画类型)
//    ///   - themeType:    The `WisdomRQCodeThemeType`, `green` by default. (扫描页面主题风格)
//    ///   - delegate:     The `ScanRQCodeDelegate`, custom navbar item.
//    ///   - answerTask:   The `WisdomRQCodeFinishTask`, back code string.  (完成回调)
//    ///   - errorTask:    The `WisdomRQCodeErrorTask`, next?.              (失败回调)
//    ///
//    /// - Returns: The created `WisdomRQCodeVC`.
//    @discardableResult
//    @objc public func startScanRQCode(startType:  StartTransformType = .push,
//                                      themeType:  WisdomRQCodeThemeType = .green,
//                                      delegate:   ScanRQCodeDelegate? = nil,
//                                      answerTask: @escaping WisdomRQCodeFinishTask,
//                                      errorTask:  @escaping WisdomRQCodeErrorTask) -> WisdomRQCodeVC {
//        return WisdomScanManager.startScanRQCode(rootVC: self,
//                                                 startType: startType,
//                                                 themeType: themeType,
//                                                 delegate: delegate,
//                                                 answerTask: answerTask,
//                                                 errorTask: errorTask)
//    }
//
//
//
//    // MARK: - startScanPhoto
//
//    /// 全屏拍摄图片（支持设置张数）:
//    ///
//    /// - Parameters:
//    ///   - startType:    The `StartTransformType` value.                  (系统相册跳转动画类型)
//    ///   - countType:    The `ElectPhotoCountType`, `once` by default.    (选取数量类型)
//    ///   - electTheme:   The `ElectPhotoTheme`, `whiteLight` by default.  (删选UI主题风格)
//    ///   - photosTask:   The `WisdomPhotoTask`, back photos array.        (完成回调)
//    ///
//    /// - Returns:        The created `WisdomPhotosVC`.
//    @discardableResult
//    @objc public func startScanPhoto(startType:  StartTransformType = .push,
//                                     countType:  ElectPhotoCountType = .nine,
//                                     electTheme: ElectPhotoTheme = .whiteLight,
//                                     photosTask: @escaping WisdomPhotoTask ) -> WisdomPhotosVC {
//        return WisdomScanManager.startScanPhoto(rootVC: self,
//                                                startType: startType,
//                                                countType: countType,
//                                                electTheme: electTheme,
//                                                photosTask: photosTask)
//    }
//
//
//
//    // MARK: - startPhotoEdit
//
//    /// 图片选择编辑器:
//    ///
//    /// - Parameters:
//    ///   - imageList:           The `StartTransformType` value.                   (图片集合)
//    ///   - startIconAnimatRect: The `CGRect`,  .                                  (开始展示的动画rect)
//    ///   - colorTheme:          The `ElectPhotoTheme`, default Value 'whiteLight'.(UI主题)
//    ///   - finishTask:          the '(Bool, [UIImage])->()'
//    ///
//    /// - Returns:               The created `WisdomPhotoEditVC`.
//    @discardableResult
//    @objc public func startPhotoEdit(imageList:            [UIImage],
//                                     startIconAnimatRect:  CGRect = CGRect.zero,
//                                     colorTheme:           ElectPhotoTheme = .whiteLight,
//                                     finishTask: @escaping (Bool, [UIImage])->()) -> WisdomPhotoEditVC {
//        return WisdomScanManager.startPhotoEdit(rootVC: self,
//                                                imageList: imageList,
//                                                startIconAnimatRect: startIconAnimatRect,
//                                                colorTheme: colorTheme,
//                                                finishTask: finishTask)
//    }
//
//}
//
//
