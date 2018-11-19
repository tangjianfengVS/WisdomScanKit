//
//  WisdomPhotoEditView.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/13.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoEditView: UIView {
    @IBOutlet fileprivate weak var cancelBtn: UIButton!
    @IBOutlet fileprivate weak var editBtn: UIButton!
    @IBOutlet fileprivate weak var realBtn: UIButton!
    fileprivate var callBack: ((WisdomActionType)->())?
    
    public class func initWithNib(callBacks: @escaping ((WisdomActionType)->())) -> WisdomPhotoEditView {
        let bundle = Bundle(for: WisdomScanKit.self)
        let nib = UINib(nibName: "WisdomPhotoEditView", bundle: bundle)
        let editView: WisdomPhotoEditView = nib.instantiate(withOwner: nil, options: nil).first as! WisdomPhotoEditView
        editView.callBack = callBacks
        return editView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelBtn.backgroundColor = UIColor.clear
        editBtn.backgroundColor = UIColor.clear
        realBtn.backgroundColor = UIColor.clear
        
        cancelBtn.layer.borderColor = UIColor.white.cgColor
        editBtn.layer.borderColor = UIColor.white.cgColor
        realBtn.layer.borderColor = UIColor.white.cgColor
        
        cancelBtn.layer.borderWidth = 1
        editBtn.layer.borderWidth = 1
        realBtn.layer.borderWidth = 1
        
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        editBtn.setTitleColor(UIColor.white, for: .normal)
        realBtn.setTitleColor(UIColor.white, for: .normal)
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
