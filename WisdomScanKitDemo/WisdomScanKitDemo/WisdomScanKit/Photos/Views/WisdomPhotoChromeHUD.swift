//
//  WisdomPhotoChromeVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

fileprivate let AMCGSize: CGSize = CGSize(width: 25, height: 25)

class WisdomPhotoChromeHUD: UIView {
    
    fileprivate let currentType: Bool!///True Image集合
    
    fileprivate let WisdomPhotoChromeHUDCellID = "WisdomPhotoChromeHUDCellID"
    
    fileprivate let imageArray: [UIImage]!
    
    fileprivate let fetchResult: PHFetchResult<PHAsset>!
    
    /** 当前浏览标示 */
    fileprivate var currentIndex: Int!
    
    /** 当前结束目标图片归位Rect */
    fileprivate var imageRect: CGRect!
    
    
    fileprivate lazy var layout = WisdomPhotoChromeFlowLayout {[weak self] (index) in
        let count = (self?.currentType)! ? (self?.imageArray.count)!:(self?.fetchResult.count)!
        if index < count {
            self?.currentIndex = index
            NotificationCenter.default.post(name: NSNotification.Name(WisdomPhotoChromeUpdateIndex_Key), object: self?.currentIndex)
        }
    }
    
    
    fileprivate lazy var emptyView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 28*100/48))
        let image = WisdomScanManager.bundleImage(name: "empty_icon")
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
        view.isHidden = true
        return view
    }()
    
    
    /** [UIImage]集合的init */
    init(beginIndex: Int, imageList: [UIImage], beginRect: CGRect) {
        currentIndex = beginIndex
        imageArray = imageList
        imageRect = beginRect
        fetchResult = PHFetchResult<PHAsset>()
        currentType = true
        
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.clear
        addGestureRecognizer(tap)
        
        if imageArray.count > 0 {
            insertSubview(listView, at: 0)
            addSubview(imageView)
            
            imageView.image = imageArray[currentIndex]
            showAnimation(image: imageArray[currentIndex], beginRect: beginRect)
            
            if currentIndex != 0 && currentIndex < imageArray.count {
                layout.updateCurrentOffsetX(index: currentIndex)
                listView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
            }

            NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(notif:)), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateFrame_Key), object: nil)
        }else{
            addSubview(emptyView)
        }
    }
    
    
    /// beginImage: UIImage,
    init(beginIndex: Int, fetchResults: PHFetchResult<PHAsset>, beginRect: CGRect) {
        currentIndex = beginIndex
        imageArray = []
        imageRect = beginRect
        fetchResult = fetchResults
        currentType = false
        
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.clear
        addGestureRecognizer(tap)
        
        insertSubview(listView, at: 0)
        addSubview(imageView)
        
        if beginIndex < fetchResult.count {
            imageManager.requestImage(for: fetchResult[beginIndex],
                                      targetSize: UIScreen.main.bounds.size,
                                      contentMode: PHImageContentMode.aspectFit,
                                      options: options,
                                      resultHandler: { (image, _) -> Void in
                self.imageView.image = image
                self.showAnimation(image: image!, beginRect: beginRect)
            })
        }
        
        if currentIndex != 0 && currentIndex < fetchResult.count {
            layout.updateCurrentOffsetX(index: currentIndex)
            listView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(notif:)), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateFrame_Key), object: nil)
    }
    
    
    @objc private func updateIndex(notif: Notification) {
        if let rect = notif.object as? CGRect {
            imageRect = rect
        }
    }
    
    
    fileprivate func showAnimation(image: UIImage, beginRect: CGRect) {
        if beginRect == CGRect.zero{
            imageView.frame = CGRect(origin: CGPoint.zero, size: AMCGSize)
            imageView.center = self.center
        } else {
            imageView.frame = beginRect
        }
        
        let rect = image.getImageChromeRect()

        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.frame = rect
        }) { (_) in
            self.backgroundColor = UIColor.black
            self.imageView.isHidden = true
            self.listView.isHidden = false
        }
    }
    
    
    @objc fileprivate func tapTouch(tap: UITapGestureRecognizer?){
        backgroundColor = UIColor.clear
        listView.isHidden = true
        imageView.isHidden = false

        if currentType {
            imageView.image = imageArray[currentIndex]
        }else{
            let cell = listView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as! WisdomPhotoChromeCell
            imageView.image = cell.imageView.image!
        }
        
        imageView.frame = imageView.image!.getImageChromeRect()
        
        UIView.animate(withDuration: 0.32, animations: {
            
            if self.imageRect == CGRect.zero{
                self.imageView.frame = CGRect(origin: CGPoint.zero, size: AMCGSize)
                self.imageView.center = self.center
            } else {
                self.imageView.frame = self.imageRect
            }
            
        }) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(WisdomPhotoChromeUpdateCover_Key), object:nil)
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


extension WisdomPhotoChromeHUD: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentType {
            return imageArray.count
        }
        return fetchResult.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoChromeHUDCellID, for: indexPath) as! WisdomPhotoChromeCell
        if currentType {
            cell.image = imageArray[indexPath.item]
        }else{
            imageManager.requestImage(for: fetchResult[indexPath.item],
                                      targetSize: UIScreen.main.bounds.size,
                                      contentMode: PHImageContentMode.aspectFit,
                                      options: options,
                                      resultHandler: { (image, _) -> Void in
                cell.image = image
            })
        }
        
        cell.panChangedCallback = { [weak self] (scale: CGFloat) in
            self?.backgroundColor = UIColor(white: 0, alpha: scale)
        }
        
        cell.panReleasedCallback = { [weak self] (image: UIImage, rect: CGRect) in
            self?.backgroundColor = UIColor.clear
            self?.listView.isHidden = true
            self?.imageView.isHidden = false
            
            self?.imageView.image = image
            self?.imageView.frame = rect
            
            UIView.animate(withDuration: 0.32, animations: {
                
                if self?.imageRect == CGRect.zero{
                    self?.imageView.frame = CGRect(origin: CGPoint.zero, size: AMCGSize)
                    self?.imageView.center = (self?.center)!
                } else {
                    self?.imageView.frame = (self?.imageRect)!
                }
                
            }) { (_) in
                NotificationCenter.default.post(name: NSNotification.Name(WisdomPhotoChromeUpdateCover_Key), object:nil)
                self?.removeFromSuperview()
            }
        }
        return cell
    }
}
