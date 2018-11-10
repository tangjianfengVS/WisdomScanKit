//
//  WisdomViewController+Extension.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

fileprivate var WisdomWisdomAnswerTaskKey = "WisdomAnswerTask_ViewController";
fileprivate var WisdomWisdomErrorTaskKey = "WisdomErrorTask_ViewController";

extension UIViewController {
    
//    private(set) var answerTask: WisdomAnswerTask?{
//        get{
//            if let task = objc_getAssociatedObject(self, &WisdomWisdomAnswerTaskKey) as? WisdomAnswerTask{
//                return task
//            }
//            return nil
//        }
//        set(newValue){
//            objc_setAssociatedObject(self, &WisdomWisdomAnswerTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    private(set) var errorTask: WisdomErrorTask?{
//        get{
//            if let task = objc_getAssociatedObject(self, &WisdomWisdomErrorTaskKey) as? WisdomErrorTask{
//                return task
//            }
//            return nil
//        }
//
//        set(newValue){
//            objc_setAssociatedObject(self, &WisdomWisdomErrorTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
    
    public func startScanRQCode(type: WisdomScanningType, themeTypes: WisdomRQCodeThemeType?,
                                answerTask: @escaping WisdomAnswerTask,
                                errorTask: @escaping WisdomErrorTask ) {
        let rqCodeVC = WisdomRQCodeVC(types: type, themeTypes: themeTypes,
                                      answerTasks: answerTask, errorTasks: errorTask)
        switch type {
        case .push:
           push(VC: rqCodeVC)
        case .present:
            present(rqCodeVC, animated: true, completion: nil)
        }
    }
    
    
    func push(VC: UIViewController) {
        addChild(VC)
        view.addSubview(VC.view)
        VC.view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.4) {
            VC.view.transform = .identity
        }
    }
}
