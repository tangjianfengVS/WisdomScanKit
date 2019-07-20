//
//  WisdomPhotoEditCell.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/15.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoEditCell: UICollectionViewCell {
    public var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    fileprivate lazy var deleteBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
        btn.center = self.center
        btn.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        let image = WisdomScanManager.bundleImage(name: "mycenter_icon_cross")
        btn.setBackgroundImage(image, for: .normal)
        return btn
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.bounds)
        return view
    }()
    
    public var callBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(deleteBtn)
    }
    
    @objc fileprivate func clickDelete(){
        if callBack != nil {
            callBack!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
