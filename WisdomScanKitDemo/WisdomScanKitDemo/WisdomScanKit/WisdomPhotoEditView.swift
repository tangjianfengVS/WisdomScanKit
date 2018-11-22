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
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        btn.center = CGPoint(x: self.editBtn.center.x - 50 - 26, y: self.center.y)
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var editBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        btn.center = self.center
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var realBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        btn.center = CGPoint(x: self.editBtn.center.x + 50 + 26, y: self.center.y)
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.setTitleColor(UIColor.white, for: .normal)
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
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        if callBack != nil {
            callBack!(.cancel)
        }
    }
    
    @IBAction func clickEditBtn(_ sender: UIButton) {
        if callBack != nil {
            callBack!(.edit)
        }
    }
    
    @IBAction func clickRealBtn(_ sender: UIButton) {
        if callBack != nil {
            callBack!(.real)
        }
    }
}
