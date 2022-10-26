//
//  WisdomAnimationBgBtn.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2019/7/20.
//  Copyright © 2019 All over the sky star. All rights reserved.
//

import UIKit

class WisdomAnimationBgBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        isHidden = true
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.9
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        setBackgroundImage(UIImage(), for: .selected)
    }
    
    
    override var isHighlighted: Bool {
        set{
        }
        get {
            return false
        }
    }
    
    override var isSelected: Bool{
        set{
        }
        get {
            return false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
