//
//  WisdomScanColorTheme.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/18.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import Foundation


/** 图片选择器界面主题 */
@objc public enum ElectPhotoTheme: NSInteger {
    case whiteLight=0
    case darkDim
}


/** 调用摄像控制器动画样式 */
@objc public enum StartTransformType: NSInteger {
    case push=0
    case present
    case alpha
    case zoomLoc       /// 定位缩放
}


/** 二维码扫描样式 */
@objc public enum WisdomRQCodeThemeType: NSInteger {
    case green=0
    case snowy=1
}


/** 照片张数样式 */
@objc public enum ElectPhotoCountType: NSInteger {
    case once=0  // 1张
    case four=2  // 4张
    case nine=3  // 9张
}


/** 点击事件类型 */
@objc public enum WisdomActionType: NSInteger {
    case cancel=0
    case edit=1
    case real=2
}


/** 摄像错误类型 */
@objc public enum WisdomScanErrorType: NSInteger {
    case denied=0       // 摄像关闭
    case restricted=1   // 无摄像
    case codeError=2    // 扫二维码失败
    case lightError=3   // 打开灯失败
    case photosError=4  // 打开相册失败
}


/** 系统相册图片展示样式 */
//@objc public enum WisdomShowElectPhotoType: NSInteger {
//    case systemElect=0  // 系统类型，有分类Controller(暂未实现)
//    case allElect=1     // 总包括类型，无分类Controller
//}