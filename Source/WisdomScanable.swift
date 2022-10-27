//
//  WisdomScanable.swift
//  WisdomScanKitDemo
//
//  Created by 汤建锋 on 2022/10/25.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol WisdomScanAuthorizeable {
    
    /// 获取摄像头状态权限
    static func getCameraAuthorize()->AVAuthorizationStatus
    
    /// 相册权限
    static func getPhotoAuthorize()->PHAuthorizationStatus
    
    /// 内部跳转系统设置
    static func openSystemSetting()->Bool
}


protocol WisdomScanPhotoChromeable {
    
    static func startPhotoChrome(startIndex: Int, startAnimaRect: CGRect, images: [UIImage], didChromeClosure: ((Int)->(CGRect))?)
    
    static func startPhotoChrome(startIndex: Int, startAnimaRect: CGRect, assets: PHFetchResult<PHAsset>, didChromeClosure: ((Int)->(CGRect))?)
    
    static func photoChrome(title: String, images: [UIImage], rootVC: UIViewController, transform: WisdomScanTransformStyle, theme: WisdomScanThemeStyle)
    
    static func photoLibraryChrome(title: String, rootVC: UIViewController, transform: WisdomScanTransformStyle, theme: WisdomScanThemeStyle)
}


//protocol WisdomScanControllerChromeable where Self: UIViewController {
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
    
    // 跳转加载图片浏览器
//    func startPhotoChrome(title: String, iconList: [UIImage], displayStyle: WisdomScanDisplayStyle, themeStyle: WisdomScanThemeStyle)
//
//    func startPhotoChrome(title: String, displayStyle: WisdomScanDisplayStyle, themeStyle: WisdomScanThemeStyle)
//}


//protocol WisdomScanPhotoElectable {
//
//    static func createPhotoElect(title: String, electClosure: @escaping ([UIImage])->())->WisdomPhotoSelectVC
//
//    static func createPhotoElect(title: String,
//                                 countStyle: WisdomScanCountStyle,
//                                 themeStyle: WisdomScanThemeStyle,
//                                 electClosure: @escaping ([UIImage])->())->WisdomPhotoSelectVC
//
//    static func createPhotoElect(title: String,
//                                 countStyle: WisdomScanCountStyle,
//                                 themeStyle: WisdomScanThemeStyle,
//                                 delegate: WisdomScanCustomNavDelegate?,
//                                 electClosure: @escaping ([UIImage])->())->WisdomPhotoSelectVC
//
//    static func startPhotoElect(title: String, electClosure: @escaping ([UIImage])->())
//
//    static func startPhotoElect(title: String,
//                                displayStyle: WisdomScanDisplayStyle,
//                                countStyle: WisdomScanCountStyle,
//                                themeStyle: WisdomScanThemeStyle,
//                                electClosure: @escaping ([UIImage])->())
//
//    static func startPhotoElect(title: String,
//                                displayStyle: WisdomScanDisplayStyle,
//                                countStyle: WisdomScanCountStyle,
//                                themeStyle: WisdomScanThemeStyle,
//                                delegate: WisdomScanCustomNavDelegate?,
//                                electClosure: @escaping ([UIImage])->())
//}



///// 相册选择图片导航栏代理
//@objc public protocol WisdomScanCustomNavDelegate {
//
//    /** 返回按钮 */
//    @objc func customNavBackItem(navigationVC: UINavigationController)->UIButton
//
//    /** 自定义标题 */
//    @objc func customNavTitleItme(navigationVC: UINavigationController)->UIView
//}


protocol WisdomPhotoChromeable {
    
    func showAnimation(image: UIImage, beginIndex: NSInteger, beginRect: CGRect)
    
    func tapTouch(tap: UITapGestureRecognizer)
    
    func panReleased(image: UIImage, rect: CGRect)
}


protocol WisdomPhotoChromeControllerable {
    
    func setNavbarUI()
    
    func authoriza()
    
    func beginShow(index: Int, coverViewFrame: CGRect)
    
    func clickBackBtn()
}
