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

        // Do any additional setup after loading the view.
    }


    @IBAction func clickScanRQCode(_ sender: UIButton) {
        
        startScanRQCode(type: .push, themeTypes: .green, answerTask: { (text, isStartScan) in
            
            isStartScan = true
            
        }) { (error, isStartScan) in
            
            //isStartScan = false
        }
    }

}
