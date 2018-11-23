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
    
    fileprivate let spacing: CGFloat = 8
    
    fileprivate lazy var lineCount: CGFloat = {
        return self.view.bounds.width > 380 ? 4:3
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
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: 0, right: spacing)
        let scale = UIScreen.main.scale
        let cellSize = layout.itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width*scale, height:cellSize.height*scale)
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    fileprivate let type: WisdomScanningType!
    
    fileprivate let setectType: WisdomSetectPhotoType!
    
    fileprivate let photoCountType: WisdomPhotosCountType!
    
    fileprivate var delegate: WisdomScanNavbarDelegate?
    
    fileprivate let photosTask: WisdomPhotosTask!
    
    fileprivate let errorTask: WisdomErrorTask!
    
    var isCreatNav: Bool=false
    
    fileprivate var items: [WisdomAlbumItem] = []
    
    //缩略图大小
    var assetGridThumbnailSize: CGSize!
    
    // 带缓存的图片管理对象
    let imageManager = PHCachingImageManager()
    
    init(types: WisdomScanningType,
         setectTypes: WisdomSetectPhotoType,
         photoCountTypes: WisdomPhotosCountType,
         navDelegate: WisdomScanNavbarDelegate?,
         photoTasks: @escaping WisdomPhotosTask,
         errorTasks: @escaping WisdomErrorTask) {
        type = types
        setectType = setectTypes
        photoCountType = photoCountTypes
        photosTask = photoTasks
        errorTask = errorTasks
        delegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(listView)
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
    
    fileprivate func upgrades(){
        showAlert(title: "允许访问相册提示", message: "App需要您同意，才能访问相册读取图片", cancelActionTitle: "取消", rightActionTitle: "去开启") { (action) in
            WisdomScanKit.authorizationScan()
        }
    }
    
    /** 加载系统所有图片 */
    fileprivate func loadSystemImages() {
        // 如果没有传入值 则获取所有资源
//        if assetsFetchResults == nil {
//            //则获取所有资源
//            let allPhotosOptions = PHFetchOptions()
//            //按照创建时间倒序排列
//            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
//                                                                 ascending: false)]
//            //只获取图片
//            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
//                                                     PHAssetMediaType.image.rawValue)
//            assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
//                                                     options: allPhotosOptions)
//        }
//        // 初始化和重置缓存
//        self.imageManager = PHCachingImageManager()
//        self.resetCachedAssets()
        
        /** 列出所有系统的智能相册 */
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .albumRegular,
                                                                  options: smartOptions)
        convertCollection(collection: smartAlbums)
        /** 列出所有用户创建的相册 */
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
        
        /** 相册按包含的照片数量排序（降序）*/
        items.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }
        
        DispatchQueue.main.async{
            self.listView.reloadData()
        }
    }
    
    /** 转化处理获取到的相簿 */
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            /** 获取出但前相簿内的图片 */
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            /** 没有图片的空相簿不显示 */
            if assetsFetchResult.count > 0{
                let title = WisdomScanKit.titleOfAlbumForChinse(title: c.localizedTitle)
                items.append( WisdomAlbumItem(title: title, fetchResult: assetsFetchResult) )
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoSelectVC: UICollectionViewDelegate, UICollectionViewDataSource{

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //为了提供表格显示性能，已创建完成的单元需重复使用
//        let identify:String = "myCell"
//        //同一形式的单元格重复使用，在声明时已注册
//        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as UITableViewCell
//        let item = self.items[indexPath.row]
//        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
//        titleLabel.text = item.title
//        let countLabel = cell.contentView.viewWithTag(2) as! UILabel
//        countLabel.text = "(\(item.fetchResult.count))"
//        return cell
//    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    // CollectionView行数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].fetchResult.count
    }
    
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WisdomPhotoSelectCellID, for: indexPath) as! WisdomPhotoSelectCell
        let albumItem = items[indexPath.section]
        let asset = albumItem.fetchResult[indexPath.item]
        //获取缩略图
        self.imageManager.requestImage(for: asset,
                                       targetSize: assetGridThumbnailSize,
                                       contentMode: PHImageContentMode.default,
                                       options: nil) { (image, nfo) in
            cell.image = image
        }
        return cell
    }
    
    // 单元格点击响应
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
