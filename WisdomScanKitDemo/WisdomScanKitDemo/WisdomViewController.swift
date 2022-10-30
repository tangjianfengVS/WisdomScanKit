//
//  WisdomViewController.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/10.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation
//import WisdomHUD

class WisdomViewController: UIViewController {
    
    lazy var imageList: [UIImage] = {
        var rray: [UIImage] = []
        for i in 0...18{
            let image = UIImage(named: "test_icon_" + String(i))
            rray.append(image!)
        }
        return rray
    }()
    
    
    /// 系统相册
    /** 调用摄像控制器动画样式 */
    var xtTransformType: StartTransformType = .push
    /** 照片张数样式 */
    var xtElectPhotoCountType: ElectPhotoCountType = .nine
    /** 系统相册界面主题 */
    var xtElectPhotoTheme: WisdomScanThemeStyle = .dark
    @IBOutlet weak var xtPushBtn: UIButton!
    @IBOutlet weak var xtNineBtn: UIButton!
    @IBOutlet weak var xtDarkBtn: UIButton!
    
    /// 全屏拍照
    /** 调用摄像控制器动画样式 */
    var pzTransformType: StartTransformType = .push
    /** 照片张数样式 */
    var pzElectPhotoCountType: ElectPhotoCountType = .nine
    /** 删选界面主题 */
    var pzElectPhotoTheme: WisdomScanThemeStyle = .light
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
    
    
    /// 图片浏览
    /** 调用摄像控制器动画样式 */
    var hudType: Bool = true
    /** 二维码扫描样式 */
    var hudElectPhotoTheme: WisdomScanThemeStyle = .light
    @IBOutlet weak var hudTypeBtn: UIButton!
    @IBOutlet weak var hudWhiteLightBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WisdomScanKit"
        
    }
    
    
    /// 从系统相册多选图片
    @IBAction func clickScanBackCard(_ sender: UIButton) {
        
//        startElectSystemPhoto(startType: xtTransformType,
//                              countType: xtElectPhotoCountType,
//                              theme: xtElectPhotoTheme,
//                              delegate: nil,
//                              photoTask: { (list: [UIImage]) in
//
//
//        })
    }
    
    
    @IBAction func clickScanPhoto(_ sender: UIButton) {
        
//        startScanPhoto(startType: pzTransformType,
//                       countType: pzElectPhotoCountType,
//                       electTheme: pzElectPhotoTheme,
//                       photosTask: { (list: [UIImage]) in
//
//        })
    }
    
    
    @IBAction func clickScanRQCode(_ sender: UIButton) {
        scanPaneShowCover = true
        rectOfInterestSize = CGSize(width: 300, height: 300)
        
//        startScanRQCode(startType: rqTransformType,
//                        themeType: rqCodeThemeType,
//                        delegate: nil,
//                        answerTask: { ( str )-> (WisdomScanReturnType) in
//
//            //WisdomHUD.showText(text: str)
//            return .pauseScan
//
//        }) { () -> (WisdomScanReturnType) in
//
//            return .hudFailScan
//        }
    }
    
    
    @IBAction func showHUDClick(_ sender: UIButton) {
        if !hudType {
            /// 无动画浏览
//            WisdomScanKit.startPhotoChrome(startIconIndex: 4,
//                                           startIconAnimatRect: .zero,
//                                           iconList: imageList,
//                                           didScrollTask: nil )
        }else{
            
            let testVC = ViewController(images: imageList)
            let nav = UINavigationController(rootViewController: testVC)
            present(nav, animated: true, completion: nil)
            
            testVC.handler = { [weak self] (startIconIndex: Int, startIconAnimatRect: CGRect) in
                
                
                /// 动画浏览-------------------------------
//                WisdomScanKit.startPhotoChrome(startIconIndex: startIconIndex,
//                                               startIconAnimatRect: startIconAnimatRect,
//                                               iconList: (self?.imageList)!,
//                                               didScrollTask: { (currentIndex: Int) -> CGRect in
//                    /// 更新结束动画 Rect----------------------------
//                    let indexPath = IndexPath(item: currentIndex, section: 0)
//                    let window = UIApplication.shared.delegate?.window!
//                    let cell = testVC.listView.cellForItem(at: indexPath)
//                    var rect: CGRect = .zero
//
//                    if cell != nil{
//                          rect = cell!.convert(cell!.bounds, to: window)
//                          return rect
//                    }
//
//                    return CGRect.zero
//                })
            }
        }
    }
}


//extension WisdomViewController: ElectPhotoDelegate{
//    func electPhotoNavbarBackItme(navigationVC: UINavigationController) -> UIButton {
//        let navbarBackBtn: UIButton = {
//            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
//            let image = WisdomScanManager.bundleImage(name: "black_backIcon")
//            btn.setImage(image, for: .normal)
//            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
//            btn.backgroundColor = UIColor.gray
//            return btn
//        }()
//        
//        return navbarBackBtn
//    }
//    
//    func electPhotoNavbarCustomTitleItme(navigationVC: UINavigationController) -> UIView {
//        let label: UILabel = {
//            let btn = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
//            btn.text = "我的相册"
//            btn.backgroundColor = UIColor.gray
//            return btn
//        }()
//        return label
//    }
//}



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
            xtElectPhotoTheme = .light
        }else if btn.tag == 2 {
            pzWhiteLightBtn.isSelected = false
            btn.isSelected = true
            pzWhiteLightBtn = btn
            pzElectPhotoTheme = .light
        }else if btn.tag == 3 {
            rqGreenBtn.isSelected = false
            btn.isSelected = true
            rqGreenBtn = btn
            rqCodeThemeType = .green
        }else if btn.tag == 4 {
            hudWhiteLightBtn.isSelected = false
            btn.isSelected = true
            hudWhiteLightBtn = btn
            hudElectPhotoTheme = .light
        }
    }
    
    
    @IBAction func clickDarkDim(btn: UIButton) {
        if btn.tag == 1 {
            xtDarkBtn.isSelected = false
            btn.isSelected = true
            xtDarkBtn = btn
            xtElectPhotoTheme = .dark
        }else if btn.tag == 2 {
            pzWhiteLightBtn.isSelected = false
            btn.isSelected = true
            pzWhiteLightBtn = btn
            pzElectPhotoTheme = .dark
        }else if btn.tag == 3 {
            rqGreenBtn.isSelected = false
            btn.isSelected = true
            rqGreenBtn = btn
            rqCodeThemeType = .snowy
        }else if btn.tag == 4 {
            hudWhiteLightBtn.isSelected = false
            btn.isSelected = true
            hudWhiteLightBtn = btn
            hudElectPhotoTheme = .dark
        }
    }
    
    
    @IBAction func clickHUDBtn(btn: UIButton) {
        if btn.isSelected {
            return
        }
        hudTypeBtn.isSelected = false
        btn.isSelected = true
        hudTypeBtn = btn
        hudType = !hudType
    }
}
