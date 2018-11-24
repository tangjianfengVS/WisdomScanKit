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
    
    fileprivate let spacing: CGFloat = 5
    
    fileprivate var barHight: CGFloat = 45
    
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
        let bar = WisdomPhotoSelectBar(frame: CGRect(x: 0, y: self.view.bounds.height - barHight,
                                                     width: self.view.bounds.width, height: barHight),
                                                     handers: { [weak self] (res) in
            if self?.imageResults.count == 0{
                return
            }
            
            self?.photoTask((self?.imageResults)!)
            self?.clickBackBtn()
        })
        return bar
    }()
    
    fileprivate var headerTitle: String="我的相册"
    
    fileprivate let startType: WisdomScanStartType!
    
    fileprivate let showElectType: WisdomShowElectPhotoType!
    
    fileprivate let countType: WisdomPhotoCountType!
    
    fileprivate var delegate: WisdomScanNavbarDelegate?
    
    fileprivate let photoTask: WisdomPhotoTask!
    
    fileprivate let errorTask: WisdomErrorTask!
    
    var isCreatNav: Bool=false
    
    //fileprivate var items: [WisdomAlbumItem] = []
    
    /** 缩略图大小 */
    var assetGridThumbnailSize: CGSize!
    
    /** 带缓存的图片管理对象 */
    let imageManager = PHCachingImageManager()
    
    /**取得的资源结果，用了存放的PHAsset */
    fileprivate var assetsFetchResults: PHFetchResult<PHAsset>?
    
    fileprivate var imageResults: [UIImage] = []
    
    fileprivate var indexPathResults: [IndexPath] = []
    
    init(startTypes: WisdomScanStartType,
         showElectTypes: WisdomShowElectPhotoType,
         countTypes: WisdomPhotoCountType,
         navDelegate: WisdomScanNavbarDelegate?,
         photoTasks: @escaping WisdomPhotoTask,
         errorTasks: @escaping WisdomErrorTask) {
        startType = startTypes
        showElectType = showElectTypes
        countType = countTypes
        photoTask = photoTasks
        errorTask = errorTasks
        delegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(listView)
        view.addSubview(selectBar)
        setNavbarUI()
        authoriza()
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
                barHight = 64
                selectBar.frame = CGRect(x: 0, y: self.view.bounds.height - barHight,
                                         width: self.view.bounds.width, height: barHight)
            }
        }
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: barHight + spacing, right: 0)
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
    }
    
    fileprivate func setNavbarUI(){
        if delegate != nil {
            navbarBackBtn = delegate!.wisdomNavbarBackBtnItme(navigationVC: navigationController)
            headerTitle = delegate!.wisdomNavbarThemeTitle(navigationVC: navigationController)
            
            let btn = delegate!.wisdomNavbarRightBtnItme(navigationVC: navigationController)
            if btn != nil{
               rightBtn = btn!
            }
        }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoSelectVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if assetsFetchResults == nil {
            return 0
        }
        return assetsFetchResults!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoSelectCellID, for: indexPath) as! WisdomPhotoSelectCell
        let asset = assetsFetchResults![indexPath.item]
        imageManager.requestImage(for: asset,
                                  targetSize: assetGridThumbnailSize,
                                  contentMode: PHImageContentMode.default,
                                  options: nil) { (image, nfo) in
            cell.image = image
                                    
            if self.indexPathResults.contains(indexPath){
                cell.selectBtn.isSelected = true
            }else{
                cell.selectBtn.isSelected = false
            }
        }
        
        cell.hander = {[weak self] (res, image) in
            let resCell = self?.updatePhotoSelect(res: res, image: image, index: indexPath)
            return resCell!
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let myAsset = self.assetsFetchResults[indexPath.row]
        
        //这里不使用segue跳转（建议用segue跳转）
//        let detailViewController = UIStoryboard(name: "Main", bundle: nil)
//            .instantiateViewController(withIdentifier: "detail")
//            as! ImageDetailViewController
//        detailViewController.myAsset = myAsset
//
//        // navigationController跳转到detailViewController
//        self.navigationController!.pushViewController(detailViewController,
//                                                      animated:true)
    }
    
}
