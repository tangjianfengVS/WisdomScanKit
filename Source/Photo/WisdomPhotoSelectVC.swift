//
//  WisdomPhotoSelectVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/22.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

class WisdomPhotoSelectBaseVC: WisdomPhotoChromeVC {
    
    let electClosure: ([UIImage])->()
    
    init(title: String?,
         images: [UIImage],
         transform: WisdomScanTransformStyle,
         theme: WisdomScanThemeStyle,
         electClosure: @escaping ([UIImage])->()) {
        self.electClosure = electClosure
        super.init(title: title,
                   images: images,
                   transform: transform,
                   theme: theme)
    }
    
    init(title: String?,
         transform: WisdomScanTransformStyle,
         theme: WisdomScanThemeStyle,
         electClosure: @escaping ([UIImage])->()) {
        self.electClosure = electClosure
        super.init(title: title,
                   transform: transform,
                   theme: theme)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.register(WisdomPhotoSelectCell.self, forCellWithReuseIdentifier: "\(WisdomPhotoSelectCell.self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoSelectBaseVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isCustomChrome, indexPath.item < images.count {
            let image = images[indexPath.item]
            electClosure([image])
            
            clickBackBtn()
            
        }else if !isCustomChrome, indexPath.item < assets.count {
            imageManager.requestImage(for: assets[indexPath.item],
                                      targetSize: assetGridThumbnailSize,
                                      contentMode: PHImageContentMode.aspectFit,
                                      options: nil,
                                      resultHandler: {[weak self] (image, _) -> Void in
                if let my = self, let curImage = image {
                    my.electClosure([curImage])
                    
                    my.clickBackBtn()
                }
            })
        }
    }
}


class WisdomPhotoSelectVC: WisdomPhotoSelectBaseVC {
    
    private(set) var indexResult: [Int] = []
    
    private var barHeght: CGFloat = 45
    
    private let electCount: WisdomScanCountStyle
    
    private lazy var selectBar: WisdomPhotoSelectBar = {
        let bar = WisdomPhotoSelectBar(frame: CGRect(x: 0, y: view.bounds.height-barHeght,
                                                     width: view.bounds.width, height: barHeght),
                                       theme: theme,
                                       handers: { [weak self] (res) in
            if res{
                if self?.indexResult.count == 0{
                    return
                }
                
                if let closure = self?.electClosure {
                    closure([])
                }
                
                self?.clickBackBtn()
            }else {
//                if self?.beginImage == nil{
////                    WisdomHUD.showText(text: "无浏览图片",delay: TimeInterval(0.5))
//                    return
//                }
//
//                let indexPath = IndexPath(item: 0, section: 0)
//                self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
//                self?.currentShowImagerRect = CGRect(x: (self?.spacing)!,
//                                                     y: (self?.navBarHeght)! + (self?.spacing)!,
//                                                     width: ItemSize, height: ItemSize)
//                let coverViewFrame = CGRect(x: (self?.spacing)!,y: (self?.spacing)!, width: ItemSize+1, height: ItemSize+1)
//                self?.beginShow(index: 0, coverViewFrame: coverViewFrame)
            }
        })
        return bar
    }()
    
    private lazy var rightBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 58, height: 30))
        btn.setTitle("   重选", for: .normal)
        btn.setTitleColor(theme == .light ? UIColor.black : UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(reset(btn:)), for: .touchUpInside)
        btn.titleLabel?.textAlignment = .right
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    

    init(title: String?,
         images: [UIImage],
         electCount: WisdomScanCountStyle,
         transform: WisdomScanTransformStyle,
         theme: WisdomScanThemeStyle,
         electClosure: @escaping ([UIImage])->()) {
        self.electCount = electCount
        super.init(title: title,
                   images: images,
                   transform: transform,
                   theme: theme,
                   electClosure: electClosure)
    }

    init(title: String?,
         electCount: WisdomScanCountStyle,
         transform: WisdomScanTransformStyle,
         theme: WisdomScanThemeStyle,
         electClosure: @escaping ([UIImage])->()) {
        self.electCount = electCount
        super.init(title: title,
                   transform: transform,
                   theme: theme,
                   electClosure: electClosure)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selectBar)
        
        if let _ = navigationController {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        }else {
            rightBtn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(rightBtn)
            
            rightBtn.wisdom_addConstraint(width: 58, height: 30)
            view.wisdom_addConstraint(with: rightBtn,
                                      topView: view,
                                      leftView: view,
                                      bottomView: nil,
                                      rightView: nil,
                                      edgeInset: UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 20))
        }
        rightBtn.isHidden = true
    }
    
    override public func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            if view.safeAreaInsets.bottom > 10 {
                barHeght = 64
                selectBar.updateHeight(height: barHeght)
            }
            //navBarHeght = view.safeAreaInsets.top
        }
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: barHeght, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension WisdomPhotoSelectVC {
    
    @objc private func reset(btn: UIButton){
        selectBar.display(res: false)
        btn.isHidden = true
        btn.setTitle("   重选", for: .normal)
        indexResult.removeAll()
        listView.reloadData()
    }
    
    /** 处理不同类型模式下的图片选择 */
    fileprivate func updatePhotoSelect(res: Bool, image: UIImage,index: IndexPath) -> Bool{
        switch electCount {
        case .one: break
//            let first = indexPathResults.first
//            if !res{
//                imageResults.removeAll()
//                indexPathResults.removeAll()
//                imageResults.append(image)
//                indexPathResults.append(index)
//
//                updateCount()
//                if first != nil{
//                    listView.reloadItems(at: [first!,index])
//                }else{
//                    listView.reloadItems(at: [index])
//                }
//                return true
//            }else{
//                imageResults.removeAll()
//                indexPathResults.removeAll()
//
//                updateCount()
//                listView.reloadItems(at: [index])
//                return false
//            }
        case .four: break
//            if !res{
//                if imageResults.count >= 4 {
////                    WisdomHUD.showText(text: "最多选择4张",delay: TimeInterval(0.5))
//                    return false
//                }
//                imageResults.append(image)
//                indexPathResults.append(index)
//
//                updateCount()
//                return true
//            }else{
//                for (ix,path) in indexPathResults.enumerated() {
//                    if path == index{
//                        imageResults.remove(at: ix)
//                        indexPathResults.remove(at: ix)
//                    }
//                }
//                updateCount()
//                return false
//            }
        case .nine: break
//            if !res{
//                if imageResults.count >= 9 {
////                    WisdomHUD.showText(text: "最多选择9张",delay: TimeInterval(0.5))
//                    return false
//                }
//                imageResults.append(image)
//                indexPathResults.append(index)
//
//                updateCount()
//                return true
//            }else{
//                for (ix,path) in indexPathResults.enumerated() {
//                    if path == index{
//                        imageResults.remove(at: ix)
//                        indexPathResults.remove(at: ix)
//                    }
//                }
//                updateCount()
//                return false
//            }
        default: break
        }
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WisdomPhotoSelectCell.self)", for: indexPath) as! WisdomPhotoSelectCell
        
        if isCustomChrome {
            cell.image = images[indexPath.item]
        }else {
            imageManager.requestImage(for: assets[indexPath.item],
                                      targetSize: assetGridThumbnailSize,
                                      contentMode: PHImageContentMode.aspectFit,
                                      options: nil,
                                      resultHandler: {[weak self] (image, _) -> Void in
                cell.image = image
                
                if indexPath.item == 0 { self?.beginImage = image }
            })
        }
        
        if indexResult.contains(indexPath.item){
            cell.selectBtn.isSelected = true
        }else{
            cell.selectBtn.isSelected = false
        }
        
        cell.hander = {[weak self] (res, image) in
            let resCell = self?.updatePhotoSelect(res: res, image: image, index: indexPath)
            return resCell!
        }
        return cell
    }
}
    

//    /** 浏览，完成Action */
//    fileprivate lazy var selectBar: WisdomPhotoSelectBar = {
//        let bar = WisdomPhotoSelectBar(frame: CGRect(x: 0, y: self.view.bounds.height - barHeght,
//                                                     width: self.view.bounds.width, height: barHeght),
//                                                     themes: self.theme,
//                                                     handers: { [weak self] (res) in
//            if res{
//                if self?.imageResults.count == 0{
////                    WisdomHUD.showText(text: "请选择图片",delay: TimeInterval(0.5))
//                    return
//                }
//                self?.photoTask((self?.imageResults)!)
//                self?.clickBackBtn()
//            }else{
//                if self?.beginImage == nil{
////                    WisdomHUD.showText(text: "无浏览图片",delay: TimeInterval(0.5))
//                    return
//                }
//
//                let indexPath = IndexPath(item: 0, section: 0)
//                self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
//                self?.currentShowImagerRect = CGRect(x: (self?.spacing)!,
//                                                     y: (self?.navBarHeght)! + (self?.spacing)!,
//                                                     width: ItemSize, height: ItemSize)
//                let coverViewFrame = CGRect(x: (self?.spacing)!,y: (self?.spacing)!, width: ItemSize+1, height: ItemSize+1)
//                self?.beginShow(index: 0, coverViewFrame: coverViewFrame)
//            }
//        })
//        return bar
//    }()
//
//    private func updateCount(){
//        if imageResults.count > 0 {
//            rightBtn.isHidden = false
//            rightBtn.setTitle("[" + String(imageResults.count) + "] 重选", for: .normal)
//            selectBar.display(res: true)
//        }else{
//            rightBtn.isHidden = true
//            rightBtn.setTitle("   重选", for: .normal)
//            selectBar.display(res: false)
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//
//        if assetsFetchResults.count > 0 {
//            imageManager.stopCachingImagesForAllAssets()
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


extension WisdomPhotoSelectVC {
    
//    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoSelectCellID, for: indexPath) as! WisdomPhotoSelectCell
////
////        imageManager.requestImage(for: assetsFetchResults[indexPath.item],
////                                  targetSize: assetGridThumbnailSize,
////                                  contentMode: PHImageContentMode.aspectFit,
////                                  options: nil,
////                                              resultHandler: { (image, _) -> Void in
////            cell.image = image
////            if indexPath.item == 0{
////                self.beginImage = image
////            }
////        })
////
////        if indexPathResults.contains(indexPath){
////            cell.selectBtn.isSelected = true
////        }else{
////            cell.selectBtn.isSelected = false
////        }
////
////        cell.hander = {[weak self] (res, image) in
////            let resCell = self?.updatePhotoSelect(res: res, image: image, index: indexPath)
////            return resCell!
////        }
////        return cell
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WisdomPhotoBaseCell.self)", for: indexPath) as! WisdomPhotoBaseCell
//
//        if isCustomChrome {
//            cell.image = images[indexPath.item]
//        }else {
//            imageManager.requestImage(for: assets[indexPath.item],
//                                      targetSize: assetGridThumbnailSize,
//                                      contentMode: PHImageContentMode.aspectFit,
//                                      options: nil,
//                                      resultHandler: {[weak self] (image, _) -> Void in
//                cell.image = image
//
//                if indexPath.item == 0 { self?.beginImage = image }
//            })
//        }
//        return cell
//    }
//
//
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoSelectCell
//        let window = UIApplication.shared.delegate?.window!
//        let rect = cell.convert(cell.bounds, to: window)
//        currentShowImagerRect = rect
//
//        beginShow(index: indexPath.item, coverViewFrame: cell.frame)
//    }
//
//
//    /** begin show HUDImageList*/
//    fileprivate func beginShow(index: Int, coverViewFrame: CGRect){
//
//        imageManager.requestImage(for: assetsFetchResults[index],
//                                  targetSize: UIScreen.main.bounds.size,
//                                  contentMode: PHImageContentMode.aspectFit,
//                                  options: options,
//                                  resultHandler: { (image, _) -> Void in
//           if image != nil {
//
////               WisdomScanKit.startPhotoChrome(startIndex: index,
////                                              startAnimatRect: self.currentShowImagerRect,
////                                              fetchResult: self.assetsFetchResults,
////                                              didChromeClosure: {[weak self] (currentIndex: Int) -> CGRect in
////
////                   if currentIndex >= (self?.assetsFetchResults)!.count{
////                       return .zero
////                   }
////
////                   let indexPath = IndexPath(item: currentIndex, section: 0)
////                   self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
////
////                   let window = UIApplication.shared.delegate?.window!
////                   let cell = self?.listView.cellForItem(at: indexPath)
////                   var rect: CGRect = .zero
////
////                   if cell != nil{
////                       rect = cell!.convert(cell!.bounds, to: window)
////                       self?.currentShowImagerRect = rect
////                   }
////
////                   return rect
////               })
//           }else{
////               WisdomHUD.showText(text: "图加载失败")
//           }
//        })
//    }
}


class WisdomPhotoSelectBar: UIView {
    
    private(set) lazy var leftBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 10, y: 15/2, width: 52, height: 32))
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("预览", for: .normal)
        btn.setTitleColor(theme == .light ? UIColor.black:UIColor.gray, for: .normal)
        return btn
    }()
    
    private(set) lazy var rightBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: bounds.width - 72, y: 15/2, width: 58, height: 32))
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor(red: 26/256.0, green: 100/256.0, blue: 26/256.0, alpha: 1)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitle("确认", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    private lazy var topLine: UIView = {
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 0.5))
        topView.backgroundColor = theme == .light ? UIColor(white: 1, alpha: 0.5) : UIColor(white: 0, alpha: 0.5)
        return topView
    }()
    
    private lazy var toolBar: UIVisualEffectView = {
        let start: UIBlurEffect.Style = theme == .light ? UIBlurEffect.Style.light:UIBlurEffect.Style.dark
        let beffect = UIBlurEffect(style: start)
        let bar = UIVisualEffectView(effect: beffect)
        bar.frame = bounds
        return bar
    }()
    
    private let hander: ((Bool)->())!
    private let theme: WisdomScanThemeStyle
    
    init(frame: CGRect, theme: WisdomScanThemeStyle, handers: @escaping ((Bool)->()) ) {
        hander = handers
        self.theme = theme
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        addSubview(toolBar)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(topLine)
    }
    
    public func display(res: Bool){
        if res {
            rightBtn.backgroundColor = UIColor(red: 26/256.0, green: 176/256.0, blue: 72/256.0, alpha: 1)
            rightBtn.setTitleColor(UIColor.white, for: .normal)
        }else {
            rightBtn.backgroundColor = UIColor(red: 26/256.0, green: 100/256.0, blue: 26/256.0, alpha: 1)
            rightBtn.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func clickSelectedBtn(btn: UIButton){
        hander((btn == leftBtn) ? false:true)
    }
    
    func updateHeight(height: CGFloat) {
        frame = CGRect(x: 0, y: frame.maxY-height, width: bounds.width, height: height)
        toolBar.frame = self.bounds
    }
}
