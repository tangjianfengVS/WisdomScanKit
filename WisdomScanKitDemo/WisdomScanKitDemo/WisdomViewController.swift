//
//  WisdomViewController.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/10.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation
import WisdomHUD

class WisdomViewController: UIViewController {
    
    /// 系统相册
    /** 调用摄像控制器动画样式 */
    var xtTransformType: StartTransformType = .push
    /** 照片张数样式 */
    var xtElectPhotoCountType: ElectPhotoCountType = .nine
    /** 系统相册界面主题 */
    var xtElectPhotoTheme: ElectPhotoTheme = .darkDim
    @IBOutlet weak var xtPushBtn: UIButton!
    @IBOutlet weak var xtNineBtn: UIButton!
    @IBOutlet weak var xtDarkBtn: UIButton!
    
    /// 全屏拍照
    /** 调用摄像控制器动画样式 */
    var pzTransformType: StartTransformType = .push
    /** 照片张数样式 */
    var pzElectPhotoCountType: ElectPhotoCountType = .nine
    /** 删选界面主题 */
    var pzElectPhotoTheme: ElectPhotoTheme = .whiteLight
    @IBOutlet weak var pzPushBtn: UIButton!
    @IBOutlet weak var pzNineBtn: UIButton!
    @IBOutlet weak var pzWhiteLightBtn: UIButton!
    
    /// 二维码
    /** 调用摄像控制器动画样式 */
    var rqTransformType: StartTransformType = .push
    /** 二维码扫描样式 */
    var rqCodeThemeType: WisdomRQCodeThemeType = .green
    @IBOutlet weak var rqPushBtn: UIButton!
    @IBOutlet weak var rqGreenBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// 从系统相册多选图片
    @IBAction func clickScanBackCard(_ sender: UIButton) {
        
        startElectSystemPhoto(startType: xtTransformType,
                              countType: xtElectPhotoCountType,
                              theme: xtElectPhotoTheme,
                              delegate: nil,
                              photoTask: { (list: [UIImage]) in
            
        }) { (error: WisdomScanErrorType) -> (Bool) in
            
            return true
        }
    }
    
    
    @IBAction func clickScanPhoto(_ sender: UIButton) {
        
        startScanPhoto(startType: pzTransformType,
                       countType: pzElectPhotoCountType,
                       electTheme: pzElectPhotoTheme,
                       photosTask: { (list: [UIImage]) in
            
        }) { (type: WisdomScanErrorType) -> (Bool) in
            
            return true
        }
    }
    
    
    @IBAction func clickScanRQCode(_ sender: UIButton) {
        scanPaneShowCover = true
        rectOfInterestSize = CGSize(width: 300, height: 300)
        
        startScanRQCode(startType: rqTransformType,
                        themeType: rqCodeThemeType,
                        delegate: nil,
                        answerTask: { (str, session: AVCaptureSession)-> (Bool) in
                            
            WisdomHUD.showText(text: str)
            return true
            
        }) { (type: WisdomScanErrorType, session: AVCaptureSession?) -> (Bool) in
            
            return true
        }
    }
}


extension WisdomViewController: ElectPhotoDelegate{
    func electPhotoNavbarBackItme(navigationVC: UINavigationController) -> UIButton {
        let navbarBackBtn: UIButton = {
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            let image = WisdomScanManager.bundleImage(name: "black_backIcon")
            btn.setImage(image, for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
            btn.backgroundColor = UIColor.gray
            return btn
        }()
        
        return navbarBackBtn
    }
    
    func electPhotoNavbarCustomTitleItme(navigationVC: UINavigationController) -> UIView {
        let label: UILabel = {
            let btn = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            btn.text = "我的相册"
            btn.backgroundColor = UIColor.gray
            return btn
        }()
        return label
    }
}



extension WisdomViewController {
    
    
    @IBAction func clickPush(btn: UIButton) {
        
        if btn.tag == 1 {
            xtPushBtn.isSelected = false
            btn.isSelected = true
            xtPushBtn = btn
            xtTransformType = .push
        }else if btn.tag == 2 {
            pzPushBtn.isSelected = false
            btn.isSelected = true
            pzPushBtn = btn
            pzTransformType = .push
        }else if btn.tag == 3 {
            rqPushBtn.isSelected = false
            btn.isSelected = true
            rqPushBtn = btn
            rqTransformType = .push
        }
    }
    
    
    @IBAction func clickPresent(btn: UIButton) {
        
        if btn.tag == 1 {
            xtPushBtn.isSelected = false
            btn.isSelected = true
            xtPushBtn = btn
            xtTransformType = .present
        }else if btn.tag == 2 {
            pzPushBtn.isSelected = false
            btn.isSelected = true
            pzPushBtn = btn
            pzTransformType = .present
        }else if btn.tag == 3 {
            rqPushBtn.isSelected = false
            btn.isSelected = true
            rqPushBtn = btn
            rqTransformType = .present
        }
    }
    
    
    @IBAction func clickAlpha(btn: UIButton) {
        
        if btn.tag == 1 {
            xtPushBtn.isSelected = false
            btn.isSelected = true
            xtPushBtn = btn
            xtTransformType = .alpha
        }else if btn.tag == 2 {
            pzPushBtn.isSelected = false
            btn.isSelected = true
            pzPushBtn = btn
            pzTransformType = .alpha
        }else if btn.tag == 3 {
            rqPushBtn.isSelected = false
            btn.isSelected = true
            rqPushBtn = btn
            rqTransformType = .alpha
        }
    }
    
    
    @IBAction func clickOnce(btn: UIButton) {
        if btn.tag == 1 {
            xtNineBtn.isSelected = false
            btn.isSelected = true
            xtNineBtn = btn
            xtElectPhotoCountType = .once
        }else if btn.tag == 2 {
            pzNineBtn.isSelected = false
            btn.isSelected = true
            pzNineBtn = btn
            pzElectPhotoCountType = .once
        }else if btn.tag == 3 {

        }
    }
    
    
    @IBAction func clickFour(btn: UIButton) {
        if btn.tag == 1 {
            xtNineBtn.isSelected = false
            btn.isSelected = true
            xtNineBtn = btn
            xtElectPhotoCountType = .four
        }else if btn.tag == 2 {
            pzNineBtn.isSelected = false
            btn.isSelected = true
            pzNineBtn = btn
            pzElectPhotoCountType = .four
        }else if btn.tag == 3 {
            
        }
    }
    
    
    @IBAction func clickNine(btn: UIButton) {
        if btn.tag == 1 {
            xtNineBtn.isSelected = false
            btn.isSelected = true
            xtNineBtn = btn
            xtElectPhotoCountType = .nine
        }else if btn.tag == 2 {
            pzNineBtn.isSelected = false
            btn.isSelected = true
            pzNineBtn = btn
            pzElectPhotoCountType = .nine
        }else if btn.tag == 3 {
            
        }
    }
    
    
    @IBAction func clickWhiteLight(btn: UIButton) {
        if btn.tag == 1 {
            xtDarkBtn.isSelected = false
            btn.isSelected = true
            xtDarkBtn = btn
            xtElectPhotoTheme = .whiteLight
        }else if btn.tag == 2 {
            pzWhiteLightBtn.isSelected = false
            btn.isSelected = true
            pzWhiteLightBtn = btn
            pzElectPhotoTheme = .whiteLight
        }else if btn.tag == 3 {
            rqGreenBtn.isSelected = false
            btn.isSelected = true
            rqGreenBtn = btn
            rqCodeThemeType = .green
        }
    }
    
    
    @IBAction func clickDarkDim(btn: UIButton) {
        if btn.tag == 1 {
            xtDarkBtn.isSelected = false
            btn.isSelected = true
            xtDarkBtn = btn
            xtElectPhotoTheme = .darkDim
        }else if btn.tag == 2 {
            pzWhiteLightBtn.isSelected = false
            btn.isSelected = true
            pzWhiteLightBtn = btn
            pzElectPhotoTheme = .darkDim
        }else if btn.tag == 3 {
            rqGreenBtn.isSelected = false
            btn.isSelected = true
            rqGreenBtn = btn
            rqCodeThemeType = .snowy
        }
    }
    
}
