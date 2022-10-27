//
//  WisdomScanTransform.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/17.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import Foundation
import UIKit

protocol WisdomScanTransform {
    
    func pushSys(transformVC: UIViewController)
    
    func presentSys()
    
    func pullup()

    func translation(transformVC: UIViewController)
    
    func lucency(transformVC: UIViewController)
    
    func zoomLocation()
}


public struct WisdomScanTransformAnim {
    
    var startIconAnimatRect: CGRect = CGRect.zero
    
    private let animation: Animation
    
    //private let transformVC: UIViewController
    
    private weak var rootVC: UIViewController?
    
    private var needNav = false
    
    public enum Animation {
        /// 平移
        case translation
        /// 上拉
        case pullup
        /// 透明变化
        case lucency
        /// 系统push
        case pushSys
        /// 系统present
        case presentSys
        ///
        case zoomLocation
        
        static func transformBy(rootVC: UIViewController, transform: WisdomScanTransformStyle)->(Animation, UIViewController){
            switch transform {
            case .push:
                if rootVC.isKind(of: UINavigationController.self) {
                    return (pushSys, rootVC)
                }else if let navVC = rootVC.navigationController {
                    return (pushSys, navVC)
                }else{
                    return (translation,rootVC)
                }
            case .present:
                return (presentSys, rootVC)
            case .alpha:
                return (lucency, rootVC)
            }
        }
    }
    
    init(rootVC: UIViewController, transform: WisdomScanTransformStyle) {
        let result = Animation.transformBy(rootVC: rootVC, transform: transform)
        animation = result.0
        self.rootVC = result.1
    }
    
//    init(rootVC: UIViewController,
//                transformVC: UIViewController) {
//        self.transformVC = transformVC
//        self.animation = Animation.zoomLocation
//        self.rootVC = rootVC
//    }
    
    mutating func startTransform(transformVC: UIViewController, needNav: Bool) {
        self.needNav = needNav
        switch animation {
        case .translation:
            translation(transformVC: transformVC)
        case .pullup:
            pullup()
        case .lucency:
            lucency(transformVC: transformVC)
        case .pushSys:
            pushSys(transformVC: transformVC)
        case .presentSys:
            presentSys()
        case .zoomLocation:
            zoomLocation()
        }
    }
}

extension WisdomScanTransformAnim: WisdomScanTransform {
    
    func pushSys(transformVC: UIViewController) {
        if needNav {
            let navVC = UINavigationController(rootViewController: transformVC)
            navVC.modalPresentationStyle = .fullScreen
            navVC.view.alpha = 0
            
            rootVC?.present(navVC, animated: false) {
                UIView.animate(withDuration: 1) {
                    navVC.view.alpha = 1
                }
            }
        }else {
            transformVC.view.alpha = 0
            transformVC.modalPresentationStyle = .fullScreen
            rootVC?.present(transformVC, animated: false) {
                UIView.animate(withDuration: 1) {
                    transformVC.view.alpha = 1
                }
            }
        }
    }
    
    func presentSys() {
//        if needNav && !transformVC.isKind(of: UINavigationController.self){
//            let navVC = UINavigationController(rootViewController: transformVC)
//            rootVC.present(navVC, animated: true, completion: nil)
//            return true
//        }else{
//            rootVC.present(transformVC, animated: true, completion: nil)
//        }
    }
    
    func pullup() {
    }
    
    func translation(transformVC: UIViewController) {
//        if needNav {
//            let navVC = UINavigationController(rootViewController: transformVC)
//            navVC.view.layer.shadowColor = UIColor.gray.cgColor
//            navVC.view.layer.shadowRadius = 4
//            navVC.view.layer.shadowOffset = CGSize(width: 0.0,height: 0.0)
//            navVC.view.layer.shadowOpacity = 1
//
//            rootVC.addChild(navVC)
//            rootVC.view.addSubview(navVC.view)
//            navVC.view.transform = CGAffineTransform(translationX: rootVC.view.bounds.width, y: 0)
//            UIView.animate(withDuration: 0.32) {
//                navVC.view.transform = .identity
//            }
//            return true
//        }else {
//            rootVC.addChild(transformVC)
//            rootVC.view.addSubview(transformVC.view)
//            transformVC.view.transform = CGAffineTransform(translationX: rootVC.view.bounds.width, y: 0)
//            UIView.animate(withDuration: 0.32) {
//                self.transformVC.view.transform = .identity
//            }
//        }
    }
    
    func lucency(transformVC: UIViewController) {
        if needNav {
            let navVC = UINavigationController(rootViewController: transformVC)
            navVC.modalPresentationStyle = .fullScreen
            navVC.view.alpha = 0
            
            rootVC?.present(navVC, animated: false) {
                UIView.animate(withDuration: 1) {
                    navVC.view.alpha = 1
                }
            }
        }else {
            transformVC.view.alpha = 0
            transformVC.modalPresentationStyle = .fullScreen
            rootVC?.present(transformVC, animated: false) {
                UIView.animate(withDuration: 1) {
                    transformVC.view.alpha = 1
                }
            }
        }
    }
    
    internal func zoomLocation() {
//        if startIconAnimatRect == CGRect.zero{
//            rootVC.addChild(transformVC)
//            rootVC.view.addSubview(transformVC.view)
//
//            rootVC.present(transformVC, animated: true, completion: nil)
//            return false
//        }
//        rootVC.view.frame = transformVC.view.frame
//        rootVC.addChild(transformVC)
//        rootVC.view.addSubview(transformVC.view)
//
//        let beginSize = startIconAnimatRect.size
//        let beginCenter = CGPoint(x: startIconAnimatRect.minX + beginSize.width/2,
//                                  y: startIconAnimatRect.minY + beginSize.height/2)
//
//        let scbl = beginSize.width/rootVC.view.bounds.width
//        let ydblW = rootVC.view.center.x-beginCenter.x
//        let ydblY = -rootVC.view.center.y+beginCenter.y
//
//        transformVC.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
//        transformVC.view.transform = transformVC.view.transform.scaledBy(x: scbl, y: scbl)
//
//        UIView.animate(withDuration: 0.32, animations: {
//            self.transformVC.view.transform = .identity
//        })
    }
}
