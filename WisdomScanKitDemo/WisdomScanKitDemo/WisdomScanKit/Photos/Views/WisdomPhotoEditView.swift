//
//  WisdomPhotoEditView.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/13.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoEditView: UIView {
    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: self.bounds.height))
        btn.center = CGPoint(x: self.editBtn.center.x - 50 - 25, y: self.bounds.height/2)
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 5
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.5)
        btn.addTarget(self, action: #selector(clickCancelBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var editBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: self.bounds.height))
        btn.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1.0
        btn.setTitle("删选", for: .normal)
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.5)
        btn.addTarget(self, action: #selector(clickEditBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var realBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: self.bounds.height))
        btn.center = CGPoint(x: self.editBtn.center.x + 50 + 25, y: self.bounds.height/2)
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1.0
        btn.setTitle("完成", for: .normal)
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.5)
        btn.addTarget(self, action: #selector(clickRealBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate let callBack: ((WisdomActionType)->())!
    
    init(frame: CGRect, callBacks: @escaping ((WisdomActionType)->())) {
        callBack = callBacks
        super.init(frame: frame)
        addSubview(cancelBtn)
        addSubview(editBtn)
        addSubview(realBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func clickCancelBtn(_ sender: UIButton) {
        callBack(.cancel)
    }
    
    @objc fileprivate func clickEditBtn(_ sender: UIButton) {
        callBack(.edit)
    }
    
    @objc fileprivate func clickRealBtn(_ sender: UIButton) {
        callBack(.real)
    }
}
