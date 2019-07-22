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
    
    // MARK: - WisdomPhotoChromeHUD
    
    /// 动画图片浏览器:（浏览自定义图片）
    ///
    /// - Parameters:
    ///   - startIconIndex:      show begin image index frame array.  (当前展示图片在数组中的下标)
    ///   - startIconAnimatRect: show begin image animation the frame.(开始展示动画的Frame)
    ///   - iconList:            show images.                         (图片集合)
    ///
    /// - Returns: The created `WisdomPhotoChromeHUD`.
    @discardableResult
    @objc public class func startPhotoChrome(startIconIndex: Int=0,
                                             startIconAnimatRect: CGRect,
                                             iconList: [UIImage]) -> WisdomPhotoChromeHUD {
        return WisdomScanManager.startPhotoChrome(startIconIndex: startIconIndex, startIconAnimatRect: startIconAnimatRect, iconList: iconList)
    }
    

    // MARK: - WisdomPhotoChromeHUD
    
    /// 动画图片浏览器:（浏览系统相册图片）
    ///
    /// - Parameters:
    ///   - startIconIndex:      show begin image index frame array.  (当前展示图片在数组中的下标)
    ///   - startIconAnimatRect: show begin image animation the frame.(开始展示动画的Frame)
    ///   - fetchResult:         show images.                         (展示缓存图片集合)
    ///
    /// - Returns: The created `WisdomPhotoChromeHUD`.
    @discardableResult
    @objc public class func startPhotoChrome(startIconIndex: Int=0,
                                             startIconAnimatRect: CGRect,
                                             fetchResult: PHFetchResult<PHAsset>) -> WisdomPhotoChromeHUD {
        return WisdomScanManager.startPhotoChrome(startIconIndex: startIconIndex, startIconAnimatRect: startIconAnimatRect, fetchResult: fetchResult)
    }
    
    
    // MARK: - Get camera status permissions status
    
    /// 获取摄像状态权限
    @objc class func authorizationStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    }
    
    
    // MARK: - Internal jump system Settings
    
    /// 内部跳转系统设置
    @objc class func authorizationScan() {
        let url = URL(string: UIApplication.openSettingsURLString)
        
        if url != nil && UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.openURL(url!)
        }
    }
    
    
    // MARK: - Get album permission status
    
    /// 相册权限
    @objc class func authorizationPhoto() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
}


extension UIViewController {
    
    // MARK: - startElectSystemPhoto
    
    /// 跳转加载系统相册图片浏览器，并选择图片
    ///
    /// - Parameters:
    ///   - startType:    The `StartTransformType` value.                (系统相册跳转动画类型)
    ///   - countType:    The `ElectPhotoCountType`, `once` by default.  (选取数量类型)
    ///   - theme:        The `ElectPhotoTheme`, `whiteLight` by default.(UI主题风格)
    ///   - delegate:     The `ElectPhotoDelegate`, custom navbar item.
    ///   - photoTask:    The `WisdomPhotoTask`, back images array.      (完成回调)
    ///   - errorTask:    The `WisdomErrorTask`, next?.                  (失败回调)
    ///
    /// - Returns: The created `WisdomPhotoSelectVC`.
    @discardableResult
    @objc public func startElectSystemPhoto(startType: StartTransformType = .present,
                                            countType: ElectPhotoCountType = .nine,
                                            theme:     ElectPhotoTheme = .darkDim,
                                            delegate:  ElectPhotoDelegate? = nil,
                                            photoTask: @escaping WisdomPhotoTask,
                                            errorTask: @escaping WisdomErrorTask) -> WisdomPhotoSelectVC {
        return WisdomScanManager.startElectSystemPhoto(rootVC: self,
                                                       startType: startType,
                                                       countType: countType,
                                                       theme:     theme,
                                                       delegate:  delegate,
                                                       photoTask: photoTask,
                                                       errorTask: errorTask)
    }
    
    
    // MARK: - startScanRQCode
    
    /// 二维码扫描 ScanRQCode
    ///
    /// - Parameters:
    ///   - startType:    The `StartTransformType` value.                  (系统相册跳转动画类型)
    ///   - themeType:    The `WisdomRQCodeThemeType`, `green` by default. (扫描页面主题风格)
    ///   - delegate:     The `ScanRQCodeDelegate`, custom navbar item.
    ///   - answerTask:   The `WisdomRQCodeFinishTask`, back code string.  (完成回调)
    ///   - errorTask:    The `WisdomRQCodeErrorTask`, next?.              (失败回调)
    ///
    /// - Returns: The created `WisdomRQCodeVC`.
    @discardableResult
    @objc public func startScanRQCode(startType:  StartTransformType = .push,
                                      themeType:  WisdomRQCodeThemeType = .green,
                                      delegate:   ScanRQCodeDelegate? = nil,
                                      answerTask: @escaping WisdomRQCodeFinishTask,
                                      errorTask:  @escaping WisdomRQCodeErrorTask) -> WisdomRQCodeVC {
        return WisdomScanManager.startScanRQCode(rootVC: self,
                                                 startType: startType,
                                                 themeType: themeType,
                                                 delegate: delegate,
                                                 answerTask: answerTask,
                                                 errorTask: errorTask)
    }
    

    // MARK: - startScanPhoto
    
    /// 全屏拍摄图片（支持设置张数）:
    ///
    /// - Parameters:
    ///   - startType:    The `StartTransformType` value.                  (系统相册跳转动画类型)
    ///   - countType:    The `ElectPhotoCountType`, `once` by default.    (选取数量类型)
    ///   - electTheme:   The `ElectPhotoTheme`, `whiteLight` by default.  (删选UI主题风格)
    ///   - photosTask:   The `WisdomPhotoTask`, back photos array.        (完成回调)
    ///   - errorTask:    The `WisdomRQCodeErrorTask`, next?.              (失败回调)
    ///
    /// - Returns: The created `WisdomPhotosVC`.
    @discardableResult
    @objc public func startScanPhoto(startType:  StartTransformType = .push,
                                     countType:  ElectPhotoCountType = .nine,
                                     electTheme: ElectPhotoTheme = .whiteLight,
                                     photosTask: @escaping WisdomPhotoTask,
                                     errorTask:  @escaping WisdomErrorTask) -> WisdomPhotosVC {
        return WisdomScanManager.startScanPhoto(rootVC: self,
                                                startType: startType,
                                                countType: countType,
                                                electTheme: electTheme,
                                                photosTask: photosTask,
                                                errorTask: errorTask)
    }
    
    
    // MARK: - startPhotoEdit
    
    /// 图片选择编辑器:
    ///
    /// - Parameters:
    ///   - imageList:    The `StartTransformType` value.                  (图片集合)
    ///   - startIconAnimatRect: The `CGRect`,  .                          (开始展示的动画rect)
    ///   - colorTheme:   The `WisdomRQCodeFinishTask`, back code string.  (完成回调)
    ///   - finishTask:    The `WisdomRQCodeErrorTask`, next?.             (失败回调)
    ///
    /// - Returns: The created `WisdomPhotoEditVC`.
    @discardableResult
    @objc public func startPhotoEdit(imageList:            [UIImage],
                                     startIconAnimatRect:  CGRect = CGRect.zero,
                                     colorTheme:           ElectPhotoTheme = .whiteLight,
                                     finishTask: @escaping (Bool, [UIImage])->()) -> WisdomPhotoEditVC {
        return WisdomScanManager.startPhotoEdit(rootVC: self,
                                                imageList: imageList,
                                                startIconAnimatRect: startIconAnimatRect,
                                                colorTheme: colorTheme,
                                                finishTask: finishTask)
    }
}


