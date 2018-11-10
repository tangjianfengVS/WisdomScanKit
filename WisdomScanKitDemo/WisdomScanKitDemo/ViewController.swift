//
//  ViewController.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/10.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clickScanRQCode(_ sender: UIButton) {
        
        startScanRQCode(type: .present, themeTypes: .green, answerTask: { (text, isStartScan) in
            
            isStartScan = true
            
        }) { (error, isStartScan) in
            
            //isStartScan = false
        }
    }

}

