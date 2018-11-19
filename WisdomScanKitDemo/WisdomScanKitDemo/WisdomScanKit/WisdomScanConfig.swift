//
//  WisdomScanConfig.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

public typealias WisdomNavBarTask = ((inout Bool)->(WisdomScanNavbarDelegate?))

public typealias WisdomAnswerTask = ((String, inout Bool)->())

public typealias WisdomErrorTask = ((String, inout Bool)->())

public typealias WisdomPhotosTask = (([UIImage])->())

/** 调用摄像控制器动画样式 */
public enum WisdomScanningType: NSInteger {
    case push=0
    case present
}

/** 二维码扫描样式 */
public enum WisdomRQCodeThemeType: NSInteger {
    case green=0
    case snowy
}

/** 拍照张数样式 */
public enum WisdomPhotosType: NSInteger {
    case once=0
    case nine
}

/** 点击事件类型 */
public enum WisdomActionType: NSInteger {
    case cancel=0
    case edit
    case real
}

@objc public protocol WisdomScanNavbarDelegate  {
    /** 返回按钮 */
    func wisdomNavbarBackBtnItme(navigationVC: UINavigationController?)->UIButton
    
    /** 标题 */
    func wisdomNavbarThemeTitle(navigationVC: UINavigationController?)->String
    
    /** 右边操作按钮 */
    func wisdomNavbarRightBtnItme(navigationVC: UINavigationController?)->UIButton?
}

