//
//  WisdomScanConfig.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation

public typealias WisdomRQCodeAnswerTask = ((String, AVCaptureSession)->())

public typealias WisdomRQCodeErrorTask = ((AVCaptureSession?, WisdomScanErrorType)->(Bool))

public typealias WisdomErrorTask = ((WisdomScanErrorType)->(Bool)) 

public typealias WisdomPhotosTask = (([UIImage])->())

/** 调用摄像控制器动画样式 */
@objc public enum WisdomScanningType: NSInteger {
    case push=0
    case present=1
}

/** 二维码扫描样式 */
@objc public enum WisdomRQCodeThemeType: NSInteger {
    case green=0
    case snowy=1
}

/** 拍照张数样式 */
@objc public enum WisdomPhotosType: NSInteger {
    case once=0
    case nine=1
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
}

@objc public protocol WisdomScanNavbarDelegate  {
    /** 返回按钮 */
    func wisdomNavbarBackBtnItme(navigationVC: UINavigationController?)->UIButton
    
    /** 标题 */
    func wisdomNavbarThemeTitle(navigationVC: UINavigationController?)->String
    
    /** 右边操作按钮 */
    func wisdomNavbarRightBtnItme(navigationVC: UINavigationController?)->UIButton?
}
