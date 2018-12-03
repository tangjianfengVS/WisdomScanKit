//
//  WisdomPhotoSelectVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/22.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

class WisdomPhotoSelectVC: UIViewController {
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
    
    fileprivate lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
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
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate var navbarBackBtn: UIButton = {
        let btn = UIButton()
        let image = WisdomScanKit.bundleImage(name: "black_backIcon")
        btn.setImage(image, for: .normal)
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    fileprivate lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("   重置", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(reset(btn:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var selectBar: WisdomPhotoSelectBar = {
        let bar = WisdomPhotoSelectBar(frame: CGRect(x: 0, y: self.view.bounds.height - barHeght,
                                                     width: self.view.bounds.width, height: barHeght),
                                                     handers: { [weak self] (res) in
            if res{
                if self?.imageResults.count == 0{
                    return
                }
                self?.photoTask((self?.imageResults)!)
                self?.clickBackBtn()
            }else{
                self?.coverView.isHidden = false
                let indexPath = IndexPath(item: 0, section: 0)
                self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
                self?.currentShowImagerRect = CGRect(x: (self?.spacing)!,
                                                     y: (self?.navBarHeght)! + (self?.spacing)!,
                                                     width: ItemSize, height: ItemSize)
                
                self?.coverView.frame = CGRect(x: (self?.spacing)!,y: (self?.spacing)!,
                                               width: ItemSize, height: ItemSize)
                
                WisdomScanKit.startPhotoChrome(beginImage: nil,
                                               beginIndex: 0,
                                               imageList: (self?.imageList)!,
                                               beginRect: (self?.currentShowImagerRect)!)
            }
        })
        return bar
    }()
    
    fileprivate var headerTitle: String="我的相册"
    
    fileprivate let startType: WisdomScanStartType!
    
    //fileprivate let electType: WisdomShowElectPhotoType!
    
    //fileprivate var delegate: WisdomScanNavbarDelegate?
    
    fileprivate let countType: WisdomPhotoCountType!
    
    fileprivate let photoTask: WisdomPhotoTask!
    
    fileprivate let errorTask: WisdomErrorTask!
    
    var isCreatNav: Bool=false
    
    /** 缩略图大小 */
    fileprivate var assetGridThumbnailSize: CGSize!
    
    /** 取得的资源集合，用了存放的PHAsset */
    fileprivate var assetsFetchResults: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    
    /** 取得的屏幕比例资源集合 */
    fileprivate var imageList: [UIImage] = []
    
    /** 选择的结果资源 */
    fileprivate var imageResults: [UIImage] = []
    
    fileprivate var indexPathResults: [IndexPath] = []
    
    /** 浏览页正在展示的图片 */
    fileprivate var currentShowImagerRect: CGRect = .zero
    
    /** 带缓存的图片管理对象 */
    fileprivate let imageManager = PHCachingImageManager()
    
    init(startTypes: WisdomScanStartType,
         //electTypes: WisdomShowElectPhotoType,
         countTypes: WisdomPhotoCountType,
         photoTasks: @escaping WisdomPhotoTask,
         errorTasks: @escaping WisdomErrorTask) {
        startType = startTypes
        //electType = electTypes
        countType = countTypes
        photoTask = photoTasks
        errorTask = errorTasks
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(listView)
        listView.addSubview(coverView)
        view.addSubview(selectBar)
        setNavbarUI()
        authoriza()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(notif:)), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateIndex_Key), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCover), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateCover_Key), object: nil)
    }
    
    @objc private func updateCover(){
        coverView.isHidden = true
    }
    
    /**
     *  处理浏览页面图片在本页面滚动跟踪的Rect
     *  作用：用于浏览结束动画的Rect锁定
     */
    @objc private func updateIndex(notif: Notification){
        if let index = notif.object as? Int {
            if index >= imageList.count{
                return
            }
            let indexPath = IndexPath(item: index, section: 0)
            listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
            
            let window = UIApplication.shared.delegate?.window!
            let cell = listView.cellForItem(at: indexPath)
            var rect: CGRect = .zero
            
            if cell != nil{
                rect = cell!.convert(cell!.bounds, to: window)
                self.coverView.frame = cell!.frame
                self.currentShowImagerRect = rect
            }else{
            //var newPoint: CGPoint = .zero
            //if self.currentShowImagerRect.maxX + self.spacing >= self.listView.bounds.width{
            //    newPoint = CGPoint(x: self.spacing, y: self.listView.frame.height - self.currentShowImagerRect.size.height - self.listView.contentInset.bottom)
            //}else{
                //newPoint = CGPoint(x: currentShowImagerRect.maxX + currentShowImagerRect.size.width + spacing, y: currentShowImagerRect.maxY)
            //}
            //self.currentShowImagerRect = CGRect(origin: newPoint, size: self.currentShowImagerRect.size)
            }
            
            DispatchQueue.global().async {
                NotificationCenter.default.post(name: NSNotification.Name(WisdomPhotoChromeUpdateFrame_Key), object: self.currentShowImagerRect)
            }
        }
    }
    
    fileprivate func authoriza() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            switch status {
            case .authorized:
                self.loadSystemImages()
                
            case .denied:
                if self.errorTask(WisdomScanErrorType.denied){
                    self.upgrades()
                }
            case .restricted:
                if self.errorTask(WisdomScanErrorType.restricted){
                    
                }
            case .notDetermined:
                self.loadSystemImages()
            default:
                break
            }
        })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            if view.safeAreaInsets.bottom > 0{
                barHeght = 64
                selectBar.frame = CGRect(x: 0, y: self.view.bounds.height - barHeght,
                                         width: self.view.bounds.width, height: barHeght)
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
        let imageRequestOption = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        assetsFetchResults.enumerateObjects({ ( asset : PHAsset, index : Int, ss : UnsafeMutablePointer<ObjCBool>) in
            
            self.imageManager.requestImage(for: asset,
                                      targetSize: UIScreen.main.bounds.size,
                                      contentMode: PHImageContentMode.aspectFit,
                                      options: imageRequestOption,
                                      resultHandler: { (image, _) -> Void in
                if image != nil{
                    self.imageList.append(image!)
                }
            })
        })
    }
    
    fileprivate func setNavbarUI(){
        //if delegate != nil {
        //    navbarBackBtn = delegate!.wisdomNavbarBackBtnItme(navigationVC: navigationController)
        //    headerTitle = delegate!.wisdomNavbarThemeTitle(navigationVC: navigationController)
        //    let btn = delegate!.wisdomNavbarRightBtnItme(navigationVC: navigationController)
        //    if btn != nil{
        //       rightBtn = btn!
        //    }
        //}
        rightBtn.frame = CGRect(x: 0, y: 0, width: 56, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navbarBackBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        navbarBackBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        title = headerTitle
        rightBtn.isEnabled = false
        rightBtn.titleLabel?.textAlignment = .right
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
            rightBtn.isEnabled = true
            rightBtn.setTitle("(" + String(imageResults.count) + ") 重置", for: .normal)
            selectBar.display(res: true)
        }else{
            rightBtn.isEnabled = false
            rightBtn.setTitle("   重置", for: .normal)
            selectBar.display(res: false)
        }
    }
    
    @objc fileprivate func reset(btn: UIButton){
        btn.isEnabled = false
        btn.setTitle("   重置", for: .normal)
        imageResults.removeAll()
        indexPathResults.removeAll()
        listView.reloadData()
    }
    
    deinit {
        imageManager.stopCachingImagesForAllAssets()
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoSelectVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsFetchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoSelectCellID, for: indexPath) as! WisdomPhotoSelectCell
        
        imageManager.requestImage(for: assetsFetchResults[indexPath.item],
                                              targetSize: assetGridThumbnailSize,
                                              contentMode: PHImageContentMode.aspectFit,
                                              options: nil,
                                              resultHandler: { (image, _) -> Void in
                cell.image = image
        })
        
        if self.indexPathResults.contains(indexPath){
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoSelectCell
        let window = UIApplication.shared.delegate?.window!
        let rect = cell.convert(cell.bounds, to: window)
        coverView.isHidden = false
        coverView.frame = cell.frame
        currentShowImagerRect = rect
        
        if assetsFetchResults.count == imageList.count {
            WisdomScanKit.startPhotoChrome(beginImage: cell.image,
                                           beginIndex: indexPath.item,
                                           imageList: imageList,
                                           beginRect: currentShowImagerRect)
        }else{
//            let time: Double = Double(assetsFetchResults.count - imageList.count)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time * 0.08) {
//                WisdomScanKit.startPhotoChrome(beginImage: cell.image,
//                                               beginIndex: indexPath.item,
//                                               imageList: self.imageList,
//                                               beginRect: self.currentShowImagerRect)
//            }
        }
    }
}
