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

@objc public class WisdomPhotoChromeHUD: UIView {
    
    private var finishing = false
    
    private let currentType: Bool//True=Image
    
    private let images: [UIImage]
    
    private let assets: PHFetchResult<PHAsset>
    
    private var didChromeClosure: ((Int)->(CGRect))?
    
    /** cur image index */
    private var currentIndex: Int
    
    /** 当前结束目标图片归位Rect */
    private var imageRect: CGRect
    
    private let imageCount: Int
    
    private lazy var layout = WisdomPhotoChromeFlowLayout {[weak self] (index) in
        if let my = self {
            let count = my.currentType ? my.images.count : my.assets.count
            if index < count {
                my.currentIndex = index
                
                if let chromeClosure = my.didChromeClosure {
                    let endRect = chromeClosure(index)
                    my.imageRect = endRect
                    my.coverView?.frame = endRect
                    
                    my.label.text = "\(index+1)/\(my.imageCount)"
                    my.label.sizeToFit()
                    my.label.frame = CGRect(x: 0,
                                            y: my.bounds.height-50,
                                            width: my.label.bounds.width+5,
                                            height: my.label.bounds.height)
                    my.label.center.x = my.center.x
                }
            }
        }
    }
    
    private lazy var tap: UITapGestureRecognizer = {
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapTouch(tap:)))
        return touch
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let iamgeVI = UIImageView()
        iamgeVI.backgroundColor = UIColor.clear
        iamgeVI.contentMode = .scaleAspectFill
        return iamgeVI
    }()
    
    private lazy var listView: UICollectionView = {
        let view = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        view.register(WisdomPhotoChromeCell.self, forCellWithReuseIdentifier: "\(WisdomPhotoChromeCell.self)")
        view.dataSource = self
        //view.isPagingEnabled = true 自定义FlowLayout的滚动位置，需要关闭分页
        view.backgroundColor = UIColor.clear
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.isHidden = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel(frame: CGRect(x: 0, y: self.bounds.height - 50, width: 70, height: 30))
        view.center.x = self.center.x
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = NSTextAlignment.center
        view.textColor = UIColor.white
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return view
    }()
    
    private weak var coverView: UIView?
    
    private lazy var emptyView: WisdomPhotoEmptyView = { return WisdomPhotoEmptyView() }()
    
    /* Custom [UIImage] */
    @objc public init(beginIndex: Int,
                      beginRect: CGRect,
                      images: [UIImage],
                      transformView: UIView,
                      didChromeClosure: ((Int)->(CGRect))?) {
        
        currentIndex = beginIndex
        self.images = images
        imageRect = beginRect
        assets = PHFetchResult<PHAsset>()
        imageCount = images.count
        self.didChromeClosure = didChromeClosure
        currentType = true
        coverView = transformView
        
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.clear
        addGestureRecognizer(tap)
        
        if images.count > 0 {
            insertSubview(listView, at: 0)
            addSubview(imageView)
            addSubview(label)
            label.isHidden = true
            
            if currentIndex < images.count {
                imageView.image = images[currentIndex]
            }else {
                currentIndex = 0
                imageRect = .zero
                imageView.image = images[currentIndex]
            }
            
            showAnimation(image: images[currentIndex], beginIndex: beginIndex, beginRect: beginRect)
            
            if currentIndex != 0 && currentIndex < images.count {
                layout.updateCurrentOffsetX(index: currentIndex)
                listView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
            }
        }else {
            addSubview(emptyView)
            wisdom_addConstraint(with: emptyView,
                                 topView: self,
                                 leftView: self,
                                 bottomView: self,
                                 rightView: self,
                                 edgeInset: .zero)
        }
    }
    
    /* Systom [UIImage] */
    @objc public init(beginIndex: Int,
                      beginRect: CGRect,
                      assets: PHFetchResult<PHAsset>,
                      transformView: UIView,
                      didChromeClosure: ((Int)->(CGRect))?) {
        
        currentIndex = beginIndex
        images = []
        imageRect = beginRect
        self.assets = assets
        imageCount = assets.count
        currentType = false
        self.didChromeClosure = didChromeClosure
        coverView = transformView
        
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.clear
        addGestureRecognizer(tap)
        
        if assets.count > 0 {
            insertSubview(listView, at: 0)
            addSubview(imageView)
            addSubview(label)
            label.isHidden = true
            
            if currentIndex < assets.count {
                //imageView.image = fetchResult[currentIndex]
            }else {
                currentIndex = 0
                imageRect = .zero
                //imageView.image = fetchResult[currentIndex]
            }
            
            imageManager.requestImage(for: assets[currentIndex],
                                      targetSize: UIScreen.main.bounds.size,
                                      contentMode: PHImageContentMode.aspectFit,
                                      options: options,
                                      resultHandler: { [weak self] (image, _) -> Void in
                self?.imageView.image = image

                self?.showAnimation(image: image!, beginIndex: beginIndex, beginRect: beginRect)
            })
            
            if currentIndex != 0 && currentIndex < assets.count {
                layout.updateCurrentOffsetX(index: currentIndex)
                listView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
            }
        }else {
            addSubview(emptyView)
            wisdom_addConstraint(with: emptyView,
                                 topView: self,
                                 leftView: self,
                                 bottomView: self,
                                 rightView: self,
                                 edgeInset: .zero)
        }
    }
    
    @objc private func updateIndex(notif: Notification) {
        if let rect = notif.object as? CGRect {
            imageRect = rect
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoChromeHUD: WisdomPhotoChromeable {
    
    // show begin
    func showAnimation(image: UIImage, beginIndex: NSInteger, beginRect: CGRect) {
        let rect = image.getImageChromeRect()
        if beginRect == CGRect.zero{
            imageView.frame = rect
            backgroundColor = UIColor.black
            alpha = 0
        } else {
            coverView?.frame = beginRect
            imageView.frame = beginRect
        }
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            if beginRect == CGRect.zero{
                self?.alpha = 1
            }else{
                self?.imageView.frame = rect
            }
        } completion: { [weak self] (_) in
            self?.backgroundColor = UIColor.black
            self?.imageView.isHidden = true
            self?.listView.isHidden = false
            self?.label.isHidden = false
            self?.finishing = false
            self?.label.text = "\(beginIndex + 1)"+"/"+"\(self?.imageCount ?? 0)"
            self?.label.sizeToFit()
            
            if let my = self {
                my.label.frame = CGRect(x: 0, y: my.bounds.height-50, width: my.label.bounds.width+5, height: my.label.bounds.height)
                my.label.center.x = my.center.x
            }
        }
    }
    
    // tap end
    @objc func tapTouch(tap: UITapGestureRecognizer){
        if imageCount == 0 {
            UIView.animate(withDuration: 0.30, animations: {[weak self] in
                self?.alpha = 0
            }) { [weak self] (_) in
                self?.superview?.removeFromSuperview()
            }
            return
        }
        
        if finishing { return }
        
        finishing = true
        listView.isHidden = true
        imageView.isHidden = false
        label.isHidden = true
        backgroundColor = UIColor.clear
        
        if currentType {
            imageView.image = images[currentIndex]
        }else if let cell = listView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? WisdomPhotoChromeCell {
            imageView.image = cell.imageView.image
        }
        
        imageView.frame = imageView.image?.getImageChromeRect() ?? .zero
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            if self?.imageRect == CGRect.zero{
                self?.alpha = 0
            } else {
                self?.imageView.frame = self?.imageRect ?? .zero
            }
        }) { [weak self] (_) in
            self?.superview?.removeFromSuperview()
        }
    }
    
    // pan end
    func panReleased(image: UIImage, rect: CGRect){
        if finishing == true { return }
        
        finishing = true
        listView.isHidden = true
        imageView.isHidden = false
        label.isHidden = true
        imageView.image = image
        imageView.frame = rect
        backgroundColor = UIColor.clear
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            if self?.imageRect == CGRect.zero{
                self?.imageView.frame = CGRect(origin: CGPoint.zero, size: AMCGSize)
                self?.imageView.center = self?.center ?? .zero
            } else {
                self?.imageView.frame = self?.imageRect ?? .zero
            }
        }) { [weak self] (_) in
            self?.superview?.removeFromSuperview()
        }
    }
}

extension WisdomPhotoChromeHUD: UICollectionViewDataSource,UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentType {
            return images.count
        }
        return assets.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WisdomPhotoChromeCell.self)", for: indexPath) as! WisdomPhotoChromeCell
        if currentType {
            cell.image = images[indexPath.item]
        }else{
            imageManager.requestImage(for: assets[indexPath.item],
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
            self?.panReleased(image: image, rect: rect)
        }
        return cell
    }
}


class WisdomPhotoEmptyView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
