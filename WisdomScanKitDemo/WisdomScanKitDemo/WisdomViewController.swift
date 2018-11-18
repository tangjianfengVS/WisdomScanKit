//
//  WisdomViewController.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/10.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickScanRQCode(_ sender: UIButton) {
        
        startScanRQCode(type: .push, themeTypes: .green, navBarTask: { (hideNavBar) ->(WisdomScanNavbarDelegate?) in
            hideNavBar = true
            return self
            
        }, answerTask: { (text, nextStartScan) in
            
            nextStartScan = true
            
        }) { (error, nextStartScan) in
            
            nextStartScan = true
        }
    }
    
    @IBAction func clickScanPhoto(_ sender: UIButton) {
        
        startScanPhotos(type: .present, photosTypes: .once, photosTask: { (list) in
            
            print(list.count)
        }) { (error, nextScan) in
            
        }
    }
    
    @IBAction func clickScanBackCard(_ sender: UIButton) {
        
//        startScanBankCard(type: .push, answerTask: { (numb, issss) in
//
//        }) { (error, ssss) in
//
//        }
    }
}

extension WisdomViewController: WisdomScanNavbarDelegate{
    func wisdomNavbarBackBtnItme(navigationVC: UINavigationController?) -> UIButton {
        let btn = UIButton()
        btn.setTitle("返回", for: .normal)
        return btn
    }
    
    func wisdomNavbarThemeTitle(navigationVC: UINavigationController?) -> String {
        return "Wisdom Scan"
    }
    
    func wisdomNavbarRightBtnItme(navigationVC: UINavigationController?) -> UIButton? {
        return nil
    }
}
