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
        
        startScanRQCode(startType: .push, themeType: .green, navDelegate: nil, answerTask: { (str, session) in
            
        }) { (session, type) -> (Bool) in
            
            return true
        }
    }
    
    @IBAction func clickScanPhoto(_ sender: UIButton) {
        
        startScanPhoto(startType: .push, countType: .nine, photosTask: { (list) in
            
        }) { (type) -> (Bool) in
            
            return true
        }
    }
    
    @IBAction func clickScanBackCard(_ sender: UIButton) {
        
        startElectSystemPhoto(startType: .push, countType: .nine, photoTask: { (list) in
            
        }) { (error) -> (Bool) in
            
            return true
        }
    }
    
    @IBAction func successButtonClick(_ sender: Any) {
        
        WisdomHUD.showSuccess(text: "").delayHanders { (timeInterval, type)  in
            
        }
        
        //WisdomHUD.showSuccess(text: "加载成功", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showSuccess(text: "加载成功", delay: delayTime, enable: true)
    }
    
    @IBAction func errorButtonClick(_ sender: Any) {
        //WisdomHUD.showError(text: "加载失败", delay: delay)
    }
    
    @IBAction func infoButtonClick(_ sender: Any) {
        //WisdomHUD.showInfo(text: "请先注册", delay: delay)
    }
    
    @IBAction func loadingButtonClick(_ sender: Any) {
        //WisdomHUD.showLoading()
        //WisdomHUD.showLoading(text: "加载中\n三秒后消失")
        
        //WisdomHUD.hide(delay: 5)
    }
    
    @IBAction func textButtonClick(_ sender: Any) {
        //WisdomHUD.showText(text: "登录成功", delay: delay)
    }
    
    @IBAction func text2ButtonClick(_ sender: Any) {
//        let hud = WisdomHUD(text: "锄禾日当午汗滴禾下土", type: .text, delay: 0,enable:true,offset:CGPoint(x: 0, y: view.frame.size.height / 2 - 100))
//        hud.backgroundColor = UIColor(red: 18/255, green: 112/255, blue: 238/255, alpha: 0.9)
//        hud.show()
        
    }
    
//    @IBAction func hideButtonClick(_ sender: UIButton) {
//        WisdomHUD.hide()
//
//        if sender.isSelected {
//            sender.isSelected = false
//            //showButtonCollect()
//        }
//    }
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
