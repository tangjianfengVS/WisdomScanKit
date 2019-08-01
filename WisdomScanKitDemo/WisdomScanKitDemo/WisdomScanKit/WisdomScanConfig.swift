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


/** 成功识别二维码回调，return： WisdomScanReturnType */
public typealias WisdomRQCodeFinishTask = ((String)->(WisdomScanReturnType))


/** 二维码识别失败，return： WisdomScanReturnType */
public typealias WisdomRQCodeErrorTask = (()->(WisdomScanReturnType))


public typealias WisdomPhotoTask = (([UIImage])->())


public typealias WisdomDidScrollTask = ((Int) -> (CGRect))


