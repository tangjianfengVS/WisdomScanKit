//
//  WisdomScanConfig.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

/** 带缓存的图片管理对象 */
let imageManager = PHCachingImageManager()


/** 缩略图大小 */
var assetGridThumbnailSize: CGSize = .zero


/** 默认掩藏的扫描区域大小 */
let scanPaneWidth: CGFloat = 240.0


/** 全局非扫描区域是否显示覆盖效果,可赋值
 *  在调用 @objc public func startScanRQCode(........) 之前调用！
 */
public var scanPaneShowCover: Bool = false


/** 全局掩藏的扫描区域大小,可赋值
 *  在调用 @objc public func startScanRQCode(........) 之前调用！
 */
public var rectOfInterestSize: CGSize = {
    let size = CGSize(width: scanPaneWidth,height: scanPaneWidth)
    return size
}()


/** 高清图片配置参数 */
let options = { () -> PHImageRequestOptions in 
    let options = PHImageRequestOptions()
    options.isSynchronous = false
    options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
    options.isNetworkAccessAllowed = true
    return options
}()


/** 图片浏览器Item的大小 */
let ItemSize: CGFloat = UIScreen.main.bounds.width > 330 ? (UIScreen.main.bounds.width-5*5)/4 :(UIScreen.main.bounds.width-4*5)/3


/** 返回值是否继续停留扫描页面 true:停留  false: 释放扫描页面 */
public typealias WisdomRQCodeFinishTask = ((String, AVCaptureSession)->(Bool))


/** 返回值是否继续扫描 true:继续 */
public typealias WisdomRQCodeErrorTask = ((WisdomScanErrorType, AVCaptureSession?)->(Bool))


public typealias WisdomErrorTask = ((WisdomScanErrorType)->(Bool))


public typealias WisdomPhotoTask = (([UIImage])->())


/** 浏览页面下标更新通知 */
public let WisdomPhotoChromeUpdateIndex_Key = "WisdomPhotoChromeUpdateIndex_Key"


/** 浏览页面结束动画更新通知 */
public let WisdomPhotoChromeUpdateCover_Key = "WisdomPhotoChromeUpdateCover_Key"


/** 浏览页面Rect更新跟踪通知 */
public let WisdomPhotoChromeUpdateFrame_Key = "WisdomPhotoChromeUpdateFrame_Key"


