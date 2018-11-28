//
//  WisdomAlbumPhotoCell.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/27.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

class WisdomAlbumPhotoCell: UITableViewCell {
    private var firstImageView: UIImageView?
    private var albumTitleLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func updateUI() {
        let width = bounds.height
        firstImageView?.frame = CGRect(x: 0, y: 0, width: width, height: width)
        albumTitleLabel?.frame = CGRect(x: firstImageView!.frame.maxX + 5, y: 4, width: 200, height: width)
    }
    
    private func setupUI() {
        firstImageView = UIImageView()
        addSubview(firstImageView!)
        firstImageView?.clipsToBounds = true
        firstImageView?.contentMode = .scaleAspectFill
        
        albumTitleLabel = UILabel()
        albumTitleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(albumTitleLabel!)
    }
    
    // 展示第一张图片和标题
    var asset: PHAsset? {
        willSet {
            if newValue == nil {
                let image = WisdomScanKit.bundleImage(name: "bg_slice")
                firstImageView?.image = image
                return
            }
            let defaultSize = CGSize(width: UIScreen.main.scale + bounds.height, height: UIScreen.main.scale + bounds.height)
            PHCachingImageManager.default().requestImage(for: newValue!, targetSize: defaultSize, contentMode: .aspectFill, options: nil, resultHandler: { (img, _) in
                self.firstImageView?.image = img
            })
        }
    }
    
    var albumTitleAndCount: (String?, Int)? {
        willSet {
            if newValue == nil {
                return
            }
            albumTitleLabel?.text = (newValue!.0 ?? "") + " (\(String(describing: newValue!.1)))"
        }
    }
}



