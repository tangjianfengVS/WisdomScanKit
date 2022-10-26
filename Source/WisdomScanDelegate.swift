//
//  WisdomScanKitDelegate.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/18.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import UIKit

/// 二维码扫描导航栏代理
@objc public protocol ScanRQCodeDelegate  {
    /** 返回按钮 */
    @objc func scanRQCodeNavbarBackItme(navigationVC: UINavigationController) -> UIButton
    
    /** 自定义标题 */
    @objc func scanRQCodeNavbarCustomTitleItme(navigationVC: UINavigationController) -> UIView
    
    /** 右边操作按钮 */
    func scanRQCodeNavbarRightItme(navigationVC: UINavigationController) -> UIButton?
}


/// 相册选择图片导航栏代理
@objc public protocol ElectPhotoDelegate {
    /** 返回按钮 */
    @objc func electPhotoNavbarBackItme(navigationVC: UINavigationController) -> UIButton
    
    /** 自定义标题 */
    @objc func electPhotoNavbarCustomTitleItme(navigationVC: UINavigationController) -> UIView
}
