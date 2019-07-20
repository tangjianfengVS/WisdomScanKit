//
//  WisdomPhotoSelectBar.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoSelectBar: UIView {
    
    private(set) lazy var leftBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 10, y: 15/2, width: 52, height: 30))
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("预览", for: .normal)
        btn.setTitleColor(self.theme == .whiteLight ? UIColor.black:UIColor.gray, for: .normal)
        return btn
    }()
    
    private(set) lazy var rightBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.bounds.width - 72, y: 15/2, width: 58, height: 30))
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor(red: 26/256.0, green: 100/256.0, blue: 26/256.0, alpha: 1)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitle("确认", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    private lazy var topLine: UIView = {
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 0.5))
        topView.backgroundColor = UIColor.gray
        return topView
    }()
    
    private lazy var toolBar: UIVisualEffectView = {
        let start: UIBlurEffect.Style = self.theme == .whiteLight ? UIBlurEffect.Style.light:UIBlurEffect.Style.dark
        let beffect = UIBlurEffect(style: start)
        let bar = UIVisualEffectView(effect: beffect)
        bar.frame = self.bounds
        return bar
    }()
    
    
    private let hander: ((Bool)->())!
    private let theme: ElectPhotoTheme
    
    init(frame: CGRect, themes: ElectPhotoTheme, handers:@escaping ((Bool)->()) ) {
        hander = handers
        theme = themes
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        addSubview(toolBar)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(topLine)
    }
    
    public func display(res: Bool){
        if res {
            rightBtn.backgroundColor = UIColor(red: 26/256.0, green: 176/256.0, blue: 72/256.0, alpha: 1)
            rightBtn.setTitleColor(UIColor.white, for: .normal)
        }else{
            rightBtn.backgroundColor = UIColor(red: 26/256.0, green: 100/256.0, blue: 26/256.0, alpha: 1)
            rightBtn.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func clickSelectedBtn(btn: UIButton){
        hander((btn == leftBtn) ? false:true)
    }
    
    func updateHeight(height: CGFloat) {
        frame = CGRect(x: 0, y: frame.maxY-height, width: bounds.width, height: height)
        toolBar.frame = self.bounds
    }
}
