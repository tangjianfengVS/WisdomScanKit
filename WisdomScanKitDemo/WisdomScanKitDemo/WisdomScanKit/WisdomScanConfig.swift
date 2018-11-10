//
//  WisdomScanConfig.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

public typealias WisdomAnswerTask = ((String, inout Bool)->())

public typealias WisdomErrorTask = ((String, inout Bool)->())

public enum WisdomScanningType {
    case push
    case present
}

public enum WisdomRQCodeThemeType {
    case green
    case snowy
}
