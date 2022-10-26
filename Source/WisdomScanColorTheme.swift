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
}


/** 二维码扫描样式 */
@objc public enum WisdomRQCodeThemeType: NSInteger {
    case green=0
    case snowy
}


/** 照片张数样式 */
@objc public enum ElectPhotoCountType: NSInteger {
    case once=0  /// 1张
    case four    /// 4张
    case nine    /// 9张
}


/** 点击事件类型 */
@objc public enum WisdomActionType: NSInteger {
    case cancel=0
    case edit
    case real
}


@objc public enum WisdomScanReturnType: NSInteger {
    case closeScan        /// 关闭
    case pauseScan        /// 暂停
    case continueScan     /// 继续
    case hudFailScan      /// 失败提示，继续扫码
}


//-----------------
/** 图片选择器界面主题 */
@objc public enum WisdomScanThemeStyle: NSInteger {
    case light=0
    case dark
}


/** 调用摄像控制器动画样式 */
@objc public enum WisdomScanTransformStyle: NSInteger {
    case push=0
    case present
    case alpha
}


/** 二维码扫描样式 */
@objc public enum WisdomScanRQCodeStyle: NSInteger {
    case green=0
    case snowy
}


/** 照片张数样式 */
@objc public enum WisdomScanCountStyle: NSInteger {
    case once=0  /// 1张
    case four    /// 4张
    case nine    /// 9张
}


///** 点击事件类型 */
//@objc public enum WisdomActionType: NSInteger {
//    case cancel=0
//    case edit
//    case real
//}
//
//
//@objc public enum WisdomScanReturnType: NSInteger {
//    case closeScan        /// 关闭
//    case pauseScan        /// 暂停
//    case continueScan     /// 继续
//    case hudFailScan      /// 失败提示，继续扫码
//}
