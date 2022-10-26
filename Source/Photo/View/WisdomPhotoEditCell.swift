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
    
    public var electTheme: ElectPhotoTheme?{
        didSet{
            
        }
    }
    
    
    fileprivate lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(clickDelete), for: .touchUpInside)
        btn.setTitle("删除", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 26/2
        btn.translatesAutoresizingMaskIntoConstraints = false
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
        
        let constraintHeight = NSLayoutConstraint(item: deleteBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 26.0)
        let constraintLeft = NSLayoutConstraint(item: deleteBtn, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 15.0)
        let constraintReight = NSLayoutConstraint(item: deleteBtn, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -15.0)
        let constraintBottom = NSLayoutConstraint(item: deleteBtn, attribute: .bottom, relatedBy:.equal, toItem: contentView, attribute:.bottom, multiplier: 1, constant: -10.0)
        
        contentView.addConstraint(constraintBottom)
        contentView.addConstraint(constraintLeft)
        contentView.addConstraint(constraintReight)
        contentView.addConstraint(constraintHeight)
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 4, height: 4)
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
