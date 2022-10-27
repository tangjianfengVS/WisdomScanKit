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
    
    func presentSys(transformVC: UIViewController)
    
    func pullup(transformVC: UIViewController)

    func translation(transformVC: UIViewController)
    
    func lucency(transformVC: UIViewController)
    
    func zoomLocation(transformVC: UIViewController)
}

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
    
    static func transformBy(rootVC: UIViewController, transform: WisdomScanTransformStyle)->(Animation,UIViewController){
        switch transform {
        case .push:
            if rootVC.isKind(of: UINavigationController.self) {
                return (pushSys,rootVC)
            }else if let navVC = rootVC.navigationController {
                return (pushSys,navVC)
            }else{
                return (translation,rootVC)
            }
        case .present:
            return (presentSys,rootVC)
        case .alpha:
            return (lucency,rootVC)
        }
    }
}

public struct WisdomScanTransformAnim {
    
    var startIconAnimatRect: CGRect = CGRect.zero
    
    private let animation: Animation
    
    private weak var rootVC: UIViewController?
    
    private var needNav = false
    
    init(rootVC: UIViewController, transform: WisdomScanTransformStyle) {
        let result = Animation.transformBy(rootVC: rootVC, transform: transform)
        animation = result.0
        self.rootVC = result.1
    }
    
    mutating func startTransform(transformVC: UIViewController, needNav: Bool) {
        self.needNav = needNav
        switch animation {
        case .translation:
            translation(transformVC: transformVC)
        case .pullup:
            pullup(transformVC: transformVC)
        case .lucency:
            lucency(transformVC: transformVC)
        case .pushSys:
            pushSys(transformVC: transformVC)
        case .presentSys:
            presentSys(transformVC: transformVC)
        case .zoomLocation:
            zoomLocation(transformVC: transformVC)
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
    
    func presentSys(transformVC: UIViewController) {
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
    
    func pullup(transformVC: UIViewController) {
        
    }
    
    func translation(transformVC: UIViewController) {
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
    
    internal func zoomLocation(transformVC: UIViewController) {
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
