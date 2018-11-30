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
    fileprivate let WisdomPhotoChromeHUDCellID = "WisdomPhotoChromeHUDCellID"
    
    fileprivate let imageArray: [UIImage]!
    
    /** 当前浏览标示 */
    fileprivate var currentIndex: Int!
    
    /** 当前结束目标图片归位Rect */
    fileprivate var imageRect: CGRect!
    
    fileprivate lazy var layout = WisdomPhotoChromeFlowLayout {[weak self] (index) in
        if index < (self?.imageArray.count)!{
            self?.currentIndex = index
            NotificationCenter.default.post(name: NSNotification.Name(WisdomPhotoChromeUpdateIndex_Key), object: self?.currentIndex)
        }
    }
    
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
    
    fileprivate lazy var listView: UICollectionView = {
        let view = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        view.register(WisdomPhotoChromeCell.self, forCellWithReuseIdentifier: WisdomPhotoChromeHUDCellID)
        view.dataSource = self
        //view.isPagingEnabled = true 自定义FlowLayout的滚动位置，需要关闭分页
        view.backgroundColor = UIColor.clear
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        return view
    }()
    
    init(beginIndex: Int, imageList: [UIImage], beginRect: CGRect) {
        currentIndex = beginIndex
        imageArray = imageList
        imageRect = beginRect
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.clear
        addGestureRecognizer(tap)
        
        if imageArray.count > 0 {
            addSubview(imageView)
            imageView.image = imageArray[currentIndex]
            imageView.frame = beginRect
            showAnimation()
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(notif:)), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateFrame_Key), object: nil)
        }else{
            addSubview(emptyView)
        }
    }
    
    @objc private func updateIndex(notif: Notification) {
        if let rect = notif.object as? CGRect {
            imageRect = rect
        }
    }
    
    fileprivate func showAnimation() {
        let rect = WisdomScanKit.getImageChromeRect(image: imageArray[currentIndex])
        
        UIView.animate(withDuration: 0.30, animations: {
            self.imageView.frame = rect
        }) { (_) in
            self.backgroundColor = UIColor.black
            self.imageView.isHidden = true
            self.insertSubview(self.listView, at: 0)
            
            if self.currentIndex != 0 && self.currentIndex < self.imageArray.count {
                self.layout.updateCurrentOffsetX(index: self.currentIndex)
                self.listView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
            }
        }
    }
    
    @objc fileprivate func tapTouch(tap: UITapGestureRecognizer){
        backgroundColor = UIColor.clear
        listView.isHidden = true
        
        let rect = WisdomScanKit.getImageChromeRect(image: imageArray[currentIndex])
        imageView.image = imageArray[currentIndex]
        imageView.frame = rect
        imageView.isHidden = false
        
        UIView.animate(withDuration: 0.30, animations: {
            self.imageView.frame = self.imageRect
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoChromeHUD: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoChromeHUDCellID, for: indexPath) as! WisdomPhotoChromeCell
        cell.image = imageArray[indexPath.item]
        return cell
    }
}
