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
    
    public var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.red
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSize(iconSize: CGSize) -> CGRect{
        let WC = fabsf(Float(iconSize.width - contentView.bounds.width))
        let HC = fabsf(Float(iconSize.height - contentView.bounds.height))
        if WC <= HC {
            let h = iconSize.height/iconSize.width*contentView.bounds.width
            return CGRect(x: 0, y: 0, width: contentView.bounds.width, height: h)
        }else {
            let w = iconSize.width/iconSize.height*contentView.bounds.height
            return CGRect(x: 0, y: 0, width: w, height: contentView.bounds.height)
        }
    }
}
