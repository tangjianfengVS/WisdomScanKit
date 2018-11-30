//
//  WisdomPhotoChromeCell.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/28.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoChromeCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.contentView.frame)
        return view
    }()
    
    var image: UIImage? {
        didSet{
            let rect = WisdomScanKit.getImageChromeRect(image: image!)
            imageView.image = image
            imageView.frame = rect
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
