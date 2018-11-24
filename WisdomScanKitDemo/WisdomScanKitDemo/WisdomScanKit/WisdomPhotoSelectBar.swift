//
//  WisdomPhotoSelectBar.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoSelectBar: UIToolbar {
//    UIImageView *toolImgv = [[UIImageView alloc]initWithFrame:CGRectMake(210, 500, 150, 150)];
//    toolImgv.image = image;
//    [self.view addSubview:toolImgv];
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(210, 500, 150, 150)];
//    toolBar.barStyle = UIBarStyleDefault;
//    [self.view addSubview:toolBar];
    
    private(set) lazy var leftBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 15, y: 10, width: 35, height: 25))
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("预览", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    private(set) lazy var rightBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.bounds.width - 45, y: 10, width: 35, height: 25))
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor(red: 26/256.0, green: 81/256.0, blue: 26/256.0, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn//24 167 66
    }()
    
    private let hander: ((Bool)->())!
    
    init(frame: CGRect,handers:@escaping ((Bool)->()) ) {
        hander = handers
        super.init(frame: frame)
        addSubview(leftBtn)
        addSubview(rightBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func clickSelectedBtn(btn: UIButton){
        hander((btn == leftBtn) ? false:true)
    }
}
