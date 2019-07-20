//
//  WisdomScanTransform.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/17.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import Foundation
import UIKit

public protocol WisdomScanTransform {
    
    func pushSys()->Bool
    
    func presentSys()->Bool
    
    func pullup()->Bool
    
    func translation()->Bool
    
    func lucency()->Bool
    
    func zoomLocation() -> Bool
}

public struct TransformAnimation: WisdomScanTransform {
    var startIconAnimatRect:  CGRect = CGRect.zero
    
    private let animation: Animation
    
    private let transformVC: UIViewController
    
    private var rootVC: UIViewController
    
    private var needNav: Bool = false
    
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
        
        static func transformBy(rootVC: UIViewController, transformType: StartTransformType)->(Animation,UIViewController){
            switch (transformType) {
            case .push:
                if rootVC.isKind(of: UINavigationController.self){
                    return (pushSys,rootVC)
                }else if let navVC = rootVC.navigationController{
                    return (pushSys,navVC)
                }else{
                    return (translation,rootVC)
                }
            case .present:
                return (presentSys,rootVC)
            case .alpha:
                return (lucency,rootVC)
            case .zoomLoc:
                return (zoomLocation,rootVC)
            }
        }
    }
    
    public init(rootVC: UIViewController,
                transformVC: UIViewController,
                startType: StartTransformType) {
        self.transformVC = transformVC
        let result = Animation.transformBy(rootVC: rootVC, transformType: startType)
        self.animation = result.0
        self.rootVC = result.1
    }
    
    public mutating func startTransform(needNav: Bool) -> Bool {
        self.needNav = needNav
        switch animation {
        case .translation:
            return translation()
        case .pullup:
            return pullup()
        case .lucency:
            return lucency()
        case .pushSys:
            return pushSys()
        case .presentSys:
            return presentSys()
        case .zoomLocation:
            return zoomLocation()
        }
    }
    
    public func pushSys() -> Bool {
        
        if !needNav {
            rootVC.addChild(transformVC)
            rootVC.view.addSubview(transformVC.view)
            transformVC.view.transform = CGAffineTransform(translationX: rootVC.view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.32) {
                self.transformVC.view.transform = .identity
            }
            return false
            
        }else{
            if let nav = rootVC as? UINavigationController {
                nav.pushViewController(transformVC, animated: true)
            }
            return false
        }
    }
    
    public func presentSys() -> Bool {
        if needNav && !transformVC.isKind(of: UINavigationController.self){
            let navVC = UINavigationController(rootViewController: transformVC)
            rootVC.present(navVC, animated: true, completion: nil)
            return true
        }else{
            rootVC.present(transformVC, animated: true, completion: nil)
            return false
        }
    }
    
    public func pullup() -> Bool {
        return false
    }
    
    public func translation() -> Bool {
        if needNav {
            let navVC = UINavigationController(rootViewController: transformVC)
            navVC.view.layer.shadowColor = UIColor.gray.cgColor
            navVC.view.layer.shadowRadius = 4
            navVC.view.layer.shadowOffset = CGSize(width: 0.0,height: 0.0)
            navVC.view.layer.shadowOpacity = 1
            
            rootVC.addChild(navVC)
            rootVC.view.addSubview(navVC.view)
            navVC.view.transform = CGAffineTransform(translationX: rootVC.view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.35) {
                navVC.view.transform = .identity
            }
            return true
        }else{
            rootVC.addChild(transformVC)
            rootVC.view.addSubview(transformVC.view)
            transformVC.view.transform = CGAffineTransform(translationX: rootVC.view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.35) {
                self.transformVC.view.transform = .identity
            }
            return false
        }
    }
    
    public func lucency() -> Bool {
        return false
    }
    
    
    public func zoomLocation() -> Bool {
        rootVC.view.frame = transformVC.view.frame
        rootVC.addChild(transformVC)
        rootVC.view.addSubview(transformVC.view)
        
        let beginSize = startIconAnimatRect.size
        let beginCenter = CGPoint(x: startIconAnimatRect.minX + beginSize.width/2,
                                  y: startIconAnimatRect.minY + beginSize.height/2)
        
        let scbl = beginSize.width/rootVC.view.bounds.width
        let ydblW = rootVC.view.center.x-beginCenter.x
        let ydblY = -rootVC.view.center.y+beginCenter.y
        
        transformVC.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
        transformVC.view.transform = transformVC.view.transform.scaledBy(x: scbl, y: scbl)
        
        UIView.animate(withDuration: 0.32, animations: {
            self.transformVC.view.transform = .identity
        })
        return false
    }
}

