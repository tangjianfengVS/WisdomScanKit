//
//  WisdomScanManager.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomScanManager: NSObject {
    
   
    
    
    
}

extension UIViewController {
    
    public func startScanRQCode(type: WisdomScanningType, themeTypes: WisdomRQCodeThemeType?,
                                answerTask: @escaping WisdomAnswerTask,
                                errorTask: @escaping WisdomErrorTask ) {
        
        let rqCodeVC = WisdomRQCodeVC(types: type, themeTypes: themeTypes,
                                      answerTasks: answerTask, errorTasks: errorTask)
        switch type {
        case .push:
            
            if self.isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(rqCodeVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(rqCodeVC, animated: true)
            }else{
                push(VC: rqCodeVC)
            }
            
        case .present:
            present(rqCodeVC, animated: true, completion: nil)
        }
    }
    
    private func push(VC: UIViewController) {
        addChild(VC)
        view.addSubview(VC.view)
        VC.view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.4) {
            VC.view.transform = .identity
        }
    }
}



