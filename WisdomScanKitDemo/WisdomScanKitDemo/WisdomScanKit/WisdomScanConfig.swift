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

let ItemSize: CGFloat = UIScreen.main.bounds.width > 330 ? (UIScreen.main.bounds.width-5*5)/4 :(UIScreen.main.bounds.width-4*5)/3

public typealias WisdomRQCodeFinishTask = ((String, AVCaptureSession)->())

public typealias WisdomRQCodeErrorTask = ((AVCaptureSession?, WisdomScanErrorType)->(Bool))

public typealias WisdomErrorTask = ((WisdomScanErrorType)->(Bool)) 

public typealias WisdomPhotoTask = (([UIImage])->())

public let WisdomPhotoChromeUpdateIndex_Key = "WisdomPhotoChromeUpdateIndex_NotiKey"
public let WisdomPhotoChromeUpdateFrame_Key = "WisdomPhotoChromeUpdateFrame_NotiKey"

/** 调用摄像控制器动画样式 */
@objc public enum WisdomScanStartType: NSInteger {
    case push=0
    case present=1
}

/** 二维码扫描样式 */
@objc public enum WisdomRQCodeThemeType: NSInteger {
    case green=0
    case snowy=1
}

/** 照片张数样式 */
@objc public enum WisdomPhotoCountType: NSInteger {
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
@objc public enum WisdomShowElectPhotoType: NSInteger {
    case systemElect=0  // 系统类型，有分类Controller(暂未实现)
    case allElect=1     // 总包括类型，无分类Controller
}

@objc public protocol WisdomScanNavbarDelegate  {
    /** 返回按钮 */
    func wisdomNavbarBackBtnItme(navigationVC: UINavigationController?)->UIButton
    
    /** 标题 */
    func wisdomNavbarThemeTitle(navigationVC: UINavigationController?)->String
    
    /** 右边操作按钮 */
    func wisdomNavbarRightBtnItme(navigationVC: UINavigationController?)->UIButton?
}
