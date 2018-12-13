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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickScanRQCode(_ sender: UIButton) {
        
        scanPaneShowCover = true
        
        rectOfInterestSize = CGSize(width: 300, height: 300)
        
        startScanRQCode(startType: .push,
                        themeType: .green,
                        navDelegate: nil,
                        answerTask: { (str, session: AVCaptureSession)-> (Bool) in
            WisdomHUD.showText(text: str)
                            
            
            return true
        }) { (type: WisdomScanErrorType, session: AVCaptureSession?) -> (Bool) in
            
            return true
        }
    }
    
    @IBAction func clickScanPhoto(_ sender: UIButton) {
        
        startScanPhoto(startType: .push, countType: .nine, photosTask: { (list: [UIImage]) in
            
            
        }) { (type: WisdomScanErrorType) -> (Bool) in
            
            
            return true
        }
    }
    
    @IBAction func clickScanBackCard(_ sender: UIButton) {
        
        startElectSystemPhoto(startType: .push, countType: .four, photoTask: { (list: [UIImage]) in
            
        }) { (error: WisdomScanErrorType) -> (Bool) in
            
            return true
        }
    }
}

extension WisdomViewController: WisdomScanNavbarDelegate{
    func wisdomNavbarBackBtnItme(navigationVC: UINavigationController?) -> UIButton {
        let btn = UIButton()
        btn.setTitle("自定义返回", for: .normal)
        return btn
    }
    
    func wisdomNavbarThemeTitle(navigationVC: UINavigationController?) -> String {
        return "Wisdom Scan"
    }
    
    func wisdomNavbarRightBtnItme(navigationVC: UINavigationController?) -> UIButton? {
        let btn = UIButton()
        btn.setTitle("自定义事件", for: .normal)
        return btn
    }
}
