//
//  WisdomScanKitDelegate.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/18.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import UIKit

@objc public protocol WisdomScanNavbarDelegate  {
    /** 返回按钮 */
    func wisdomNavbarBackBtnItme(navigationVC: UINavigationController?)->UIButton
    
    /** 标题 */
    func wisdomNavbarThemeTitle(navigationVC: UINavigationController?)->String
    
    /** 右边操作按钮 */
    func wisdomNavbarRightBtnItme(navigationVC: UINavigationController?)->UIButton?
}


@objc public protocol ElectPhotoDelegate {
    /** 返回按钮 */
    @objc func electPhotoNavbarBackItme(navigationVC: UINavigationController) -> UIButton
    
    /** 自定义标题 */
    @objc func electPhotoNavbarCustomTitleItme(navigationVC: UINavigationController) -> UIView
}
