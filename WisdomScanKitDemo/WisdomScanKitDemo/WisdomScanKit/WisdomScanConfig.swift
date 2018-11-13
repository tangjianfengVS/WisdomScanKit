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

public enum WisdomScanningType {
    case push
    case present
}

public enum WisdomRQCodeThemeType {
    case green
    case snowy
}

public enum WisdomPhotosType {
    case once
    case nine
}

public enum WisdomActionType {
    case cancel
    case edit
    case real
}

@objc public protocol WisdomScanNavbarDelegate  {
    /** 返回按钮 */
    func wisdomNavbarBackBtnItme()->UIButton
    
    /** 标题 */
    func wisdomNavbarThemeTitle()->String
    
    /** 右边操作按钮 */
    func wisdomNavbarRightBtnItme()->UIButton?
}

