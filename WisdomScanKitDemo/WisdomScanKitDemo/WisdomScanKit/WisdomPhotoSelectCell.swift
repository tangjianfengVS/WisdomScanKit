//
//  WisdomPhotoSelectCell.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/23.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

class WisdomPhotoSelectCell: UICollectionViewCell {
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.contentView.bounds)
        view.backgroundColor = UIColor.cyan
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var selectBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.contentView.bounds.width - 22, y: 2, width: 20, height: 20))
        var image = WisdomScanKit.bundleImage(name: "shan_element_book")
        btn.setBackgroundImage(image, for: .normal)
        image = WisdomScanKit.bundleImage(name: "selectedbackgroud_icon")
        btn.setBackgroundImage(image, for: .selected)
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    public var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    public var hander: ((Bool,UIImage)->(Bool))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(selectBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickSelectedBtn(btn: UIButton){
        if hander != nil {
            let res = hander!(btn.isSelected,image!)
            btn.isSelected = res
        }
    }
}
