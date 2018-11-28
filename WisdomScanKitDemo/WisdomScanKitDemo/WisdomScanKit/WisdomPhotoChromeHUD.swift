//
//  WisdomPhotoChromeVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

class WisdomPhotoChromeHUD: UIView {
    fileprivate let imageArray: [UIImage]!
    
    fileprivate let currentIndex: Int!
    
    fileprivate let imageRect: CGRect!
    
    fileprivate lazy var emptyView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 28*100/48))
        let image = WisdomScanKit.bundleImage(name: "empty_icon")
        imageView.image = image
        imageView.center = self.center
        return imageView
    }()
    
    fileprivate lazy var tap: UITapGestureRecognizer = {
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapTouch(tap:)))
        return touch
    }()
    
    fileprivate(set) lazy var imageView: UIImageView = {
        let iamgeVI = UIImageView()
        iamgeVI.backgroundColor = UIColor.clear
        iamgeVI.contentMode = .scaleAspectFill
        return iamgeVI
    }()
    
    init(beginIndex: Int, imageList: [UIImage], beginRect: CGRect) {
        currentIndex = beginIndex
        imageArray = imageList
        imageRect = beginRect
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black
        addGestureRecognizer(tap)
        
        if imageArray.count > 0 {
            addSubview(imageView)
            imageView.image = imageArray[currentIndex]
            imageView.frame = beginRect
            showAnimation()
        }else{
            addSubview(emptyView)
        }
    }
    
    fileprivate func showAnimation() {
        let rect = WisdomScanKit.getImageChromeRect(image: imageArray[currentIndex])
        UIView.animate(withDuration: 0.35, animations: {
            self.imageView.frame = rect
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func tapTouch(tap: UITapGestureRecognizer){
        backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.35, animations: {
            self.imageView.frame = self.imageRect
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
