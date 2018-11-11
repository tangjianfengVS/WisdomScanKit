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
            hideNavBar = false
            return self
            
        }, answerTask: { (text, nextStartScan) in
            
            nextStartScan = true
            
        }) { (error, nextStartScan) in
            
            nextStartScan = true
        }
    }
}

extension WisdomViewController: WisdomScanNavbarDelegate{
    func wisdomNavbarBackBtnItme() -> UIButton {
        let btn = UIButton()
        btn.setTitle("返回", for: .normal)
        return btn
    }
    
    func wisdomNavbarThemeTitle() -> String {
        return "Wisdom Scan"
    }
    
    func wisdomNavbarRightBtnItme() -> UIButton? {
        return nil
    }
}
