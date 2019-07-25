//
//  WisdomPhotoSelectVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/22.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos
import WisdomHUD

public class WisdomPhotoSelectVC: UIViewController {
    
    fileprivate let WisdomPhotoSelectCellID = "WisdomPhotoSelectCellID"
    
    fileprivate let spacing: CGFloat = 4
    
    /** 底部Bar高度 */
    fileprivate var barHeght: CGFloat = 45
    
    /** 导航栏高度 */
    fileprivate var navBarHeght: CGFloat = 64
    
    /** 横排个数 */
    fileprivate lazy var lineCount: CGFloat = {
        return self.view.bounds.width > 330 ? 4:3
    }()
    
    
    fileprivate lazy var listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.register(WisdomPhotoSelectCell.self, forCellWithReuseIdentifier: WisdomPhotoSelectCellID)
        view.delegate = self
        view.dataSource = self
        layout.itemSize = CGSize(width: (self.view.bounds.width-(self.lineCount+1)*spacing)/self.lineCount,
                                 height: (self.view.bounds.width-(self.lineCount+1)*spacing)/self.lineCount)
        
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let scale = UIScreen.main.scale
        let cellSize = layout.itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width*scale, height:cellSize.height*scale)
        view.backgroundColor = UIColor.init(white: 0.90, alpha: 1)
        return view
    }()
    
    
    fileprivate var navbarBackBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        let image = WisdomScanManager.bundleImage(name: "black_backIcon")
        btn.setImage(image, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        return btn
    }()
    
    
    fileprivate lazy var rightBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 56, height: 30))
        btn.setTitle("   重选", for: .normal)
        btn.isHidden = true
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(reset(btn:)), for: .touchUpInside)
        return btn
    }()
    
    
    /** 浏览，完成Action */
    fileprivate lazy var selectBar: WisdomPhotoSelectBar = {
        let bar = WisdomPhotoSelectBar(frame: CGRect(x: 0, y: self.view.bounds.height - barHeght,
                                                     width: self.view.bounds.width, height: barHeght),
                                                     themes: self.theme,
                                                     handers: { [weak self] (res) in
            if res{
                if self?.imageResults.count == 0{
                    WisdomHUD.showText(text: "请选择图片",delay: TimeInterval(0.5))
                    return
                }
                self?.photoTask((self?.imageResults)!)
                self?.clickBackBtn()
            }else{
                if self?.beginImage == nil{
                    WisdomHUD.showText(text: "无浏览图片",delay: TimeInterval(0.5))
                    return
                }
                
                let indexPath = IndexPath(item: 0, section: 0)
                self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
                self?.currentShowImagerRect = CGRect(x: (self?.spacing)!,
                                                     y: (self?.navBarHeght)! + (self?.spacing)!,
                                                     width: ItemSize, height: ItemSize)
                let coverViewFrame = CGRect(x: (self?.spacing)!,y: (self?.spacing)!, width: ItemSize+1, height: ItemSize+1)
                self?.beginShow(index: 0, coverViewFrame: coverViewFrame)
            }
        })
        return bar
    }()
    
    
    fileprivate var headerTitle: String="所有照片"
    
    fileprivate let startType: StartTransformType!
    
    fileprivate let countType: ElectPhotoCountType!
    
    fileprivate let theme:     ElectPhotoTheme!
    
    fileprivate let delegate:  ElectPhotoDelegate?
    
    fileprivate let photoTask: WisdomPhotoTask!
    
    fileprivate let errorTask: WisdomErrorTask!
    
    /** 取得的资源集合，用了存放的PHAsset */
    fileprivate var assetsFetchResults: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    
    /** 选择的结果资源 */
    fileprivate var imageResults: [UIImage] = []
    
    fileprivate var indexPathResults: [IndexPath] = []
    
    /** 浏览页正在展示的图片 */
    fileprivate var currentShowImagerRect: CGRect = .zero
    
    fileprivate var beginImage: UIImage?
    
    var isCreatNav: Bool=false
    
    init(startTypes: StartTransformType,
         countTypes: ElectPhotoCountType,
         colorTheme: ElectPhotoTheme,
         delegates:  ElectPhotoDelegate?,
         photoTasks: @escaping WisdomPhotoTask,
         errorTasks: @escaping WisdomErrorTask) {
        
        startType = startTypes
        countType = countTypes
        theme = colorTheme
        delegate = delegates
        photoTask = photoTasks
        errorTask = errorTasks
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.90, alpha: 1)
        view.addSubview(listView)
        view.addSubview(selectBar)
        setNavbarUI()
        authoriza()
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if theme == .darkDim {
            self.navigationController?.navigationBar.isTranslucent = true///设置导航栏半透明
            let image: UIImage = UIColor.init(white: 0.8, alpha: 0.70).asImage(CGSize(width: view.bounds.width, height: 88)) ?? UIImage()///设置导航栏背景图片
            self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if theme == .darkDim {
            self.navigationController?.navigationBar.isTranslucent = false///设置导航栏半透明
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        }
    }
    
    
    fileprivate func authoriza() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            switch status {
            case .authorized:
                DispatchQueue.global().async {
                    self.loadSystemImages()
                }
                
            case .denied:
                if self.errorTask(WisdomScanErrorType.denied){
                    self.upgrades()
                }
                
            case .restricted:
                if self.errorTask(WisdomScanErrorType.restricted){
                    self.upgrades()
                }
                
            case .notDetermined:
                DispatchQueue.global().async {
                    self.loadSystemImages()
                }
                
            default:
                break
            }
        })
    }
    
    
    override public func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            if view.safeAreaInsets.bottom > 10{
                barHeght = 64
                selectBar.updateHeight(height: barHeght)
            }
            navBarHeght = view.safeAreaInsets.top
        }
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: barHeght, right: 0)
    }
    
    
    fileprivate func upgrades(){
        showAlert(title: "允许访问相册提示", message: "App需要您同意，才能访问相册读取图片", cancelActionTitle: "取消", rightActionTitle: "去开启") { (action) in
            WisdomScanKit.authorizationScan()
        }
    }
    
    
    /** 加载系统所有图片 */
    fileprivate func loadSystemImages() {
        /** 则获取所有资源 */
        let allPhotosOptions = PHFetchOptions()
        /** 按照创建时间倒序排列 */
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        /** 只获取图片 */
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
        
        DispatchQueue.main.async {
            self.listView.reloadData()
        }
        
        // 新建一个PHImageRequestOptions对象
        //let imageRequestOption = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        //imageRequestOption.isSynchronous = true
        // 缩略图的压缩模式设置为无
        //imageRequestOption.resizeMode = .none
        // 缩略图的质量为高质量，不管加载时间花多少
        //imageRequestOption.deliveryMode = .highQualityFormat
    }
    
    
    fileprivate func setNavbarUI(){
        if (delegate != nil) {
            let backBtn = delegate!.electPhotoNavbarBackItme(navigationVC: navigationController!)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
            
            let customView = delegate!.electPhotoNavbarCustomTitleItme(navigationVC: navigationController!)
            navigationItem.titleView = customView
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navbarBackBtn)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
            navbarBackBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
            title = headerTitle
        }
        
        rightBtn.titleLabel?.textAlignment = .right
        
        if countType == .once {
            rightBtn.isHidden = true
        }
    }
    
    
    @objc fileprivate func clickBackBtn(){
        if startType == .push {
            if navigationController != nil && isCreatNav {
                UIView.animate(withDuration: 0.35, animations: {
                    self.navigationController!.view.transform = CGAffineTransform(translationX: self.navigationController!.view.bounds.width, y: 0)
                }) { (_) in
                    self.navigationController!.view.removeFromSuperview()
                    self.navigationController!.removeFromParent()
                }
            }else if navigationController != nil && !isCreatNav {
                navigationController!.popViewController(animated: true)
            }else{
                UIView.animate(withDuration: 0.35, animations: {
                    self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                }) { (_) in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }else if startType == .present{
            if navigationController != nil {
                navigationController!.dismiss(animated: true, completion: nil)
            }else{
                dismiss(animated: true, completion: nil)
            }
        }else if startType == .alpha{
            if navigationController != nil {
                UIView.animate(withDuration: 0.35, animations: {
                    self.navigationController!.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }) { (_) in
                    self.navigationController!.view.removeFromSuperview()
                    self.navigationController!.removeFromParent()
                }
            }else{
                UIView.animate(withDuration: 0.35, animations: {
                    self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }) { (_) in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }
    }
    
    
    /** 处理不同类型模式下的图片选择 */
    fileprivate func updatePhotoSelect(res: Bool, image: UIImage,index: IndexPath) -> Bool{
        switch countType! {
        case .once:
            let first = indexPathResults.first
            if !res{
                imageResults.removeAll()
                indexPathResults.removeAll()
                imageResults.append(image)
                indexPathResults.append(index)
                
                updateCount()
                if first != nil{
                    listView.reloadItems(at: [first!,index])
                }else{
                    listView.reloadItems(at: [index])
                }
                return true
            }else{
                imageResults.removeAll()
                indexPathResults.removeAll()
                
                updateCount()
                listView.reloadItems(at: [index])
                return false
            }
        case .four:
            if !res{
                if imageResults.count >= 4 {
                    WisdomHUD.showText(text: "最多选择4张",delay: TimeInterval(0.5))
                    return false
                }
                imageResults.append(image)
                indexPathResults.append(index)
                
                updateCount()
                return true
            }else{
                for (ix,path) in indexPathResults.enumerated() {
                    if path == index{
                        imageResults.remove(at: ix)
                        indexPathResults.remove(at: ix)
                    }
                }
                updateCount()
                return false
            }
        case .nine:
            if !res{
                if imageResults.count >= 9 {
                    WisdomHUD.showText(text: "最多选择9张",delay: TimeInterval(0.5))
                    return false
                }
                imageResults.append(image)
                indexPathResults.append(index)
                
                updateCount()
                return true
            }else{
                for (ix,path) in indexPathResults.enumerated() {
                    if path == index{
                        imageResults.remove(at: ix)
                        indexPathResults.remove(at: ix)
                    }
                }
                updateCount()
                return false
            }
        default:
            break
        }
        return true
    }
    
    
    private func updateCount(){
        if imageResults.count > 0 {
            rightBtn.isHidden = false
            rightBtn.setTitle("(" + String(imageResults.count) + ") 重选", for: .normal)
            selectBar.display(res: true)
        }else{
            rightBtn.isHidden = true
            rightBtn.setTitle("   重选", for: .normal)
            selectBar.display(res: false)
        }
    }
    
    
    @objc fileprivate func reset(btn: UIButton){
        selectBar.display(res: false)
        btn.isHidden = true
        btn.setTitle("   重选", for: .normal)
        imageResults.removeAll()
        indexPathResults.removeAll()
        listView.reloadData()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        if assetsFetchResults.count > 0 {
            imageManager.stopCachingImagesForAllAssets()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension WisdomPhotoSelectVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsFetchResults.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoSelectCellID, for: indexPath) as! WisdomPhotoSelectCell
        
        imageManager.requestImage(for: assetsFetchResults[indexPath.item],
                                  targetSize: assetGridThumbnailSize,
                                  contentMode: PHImageContentMode.aspectFit,
                                  options: nil,
                                              resultHandler: { (image, _) -> Void in
            cell.image = image
            if indexPath.item == 0{
                self.beginImage = image
            }
        })
        
        if indexPathResults.contains(indexPath){
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
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoSelectCell
        let window = UIApplication.shared.delegate?.window!
        let rect = cell.convert(cell.bounds, to: window)
        currentShowImagerRect = rect
        
        beginShow(index: indexPath.item, coverViewFrame: cell.frame)
    }
    
    
    /** begin show HUDImageList*/
    fileprivate func beginShow(index: Int, coverViewFrame: CGRect){
        
        imageManager.requestImage(for: assetsFetchResults[index],
                                  targetSize: UIScreen.main.bounds.size,
                                  contentMode: PHImageContentMode.aspectFit,
                                  options: options,
                                  resultHandler: { (image, _) -> Void in
           if image != nil {

               WisdomScanKit.startPhotoChrome(startIconIndex: index,
                                              startIconAnimatRect: self.currentShowImagerRect,
                                              fetchResult: self.assetsFetchResults,
                                              didScrollTask: {[weak self] (currentIndex: Int) -> CGRect in
                                                
                   if currentIndex >= (self?.assetsFetchResults)!.count{
                       return .zero
                   }
                                                
                   let indexPath = IndexPath(item: currentIndex, section: 0)
                   self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
                                                
                   let window = UIApplication.shared.delegate?.window!
                   let cell = self?.listView.cellForItem(at: indexPath)
                   var rect: CGRect = .zero
                                                
                   if cell != nil{
                       rect = cell!.convert(cell!.bounds, to: window)
                       self?.currentShowImagerRect = rect
                   }
                                                
                   return rect
               })
           }else{
               WisdomHUD.showInfo(text: "图加载失败")
           }
        })
    }
}
