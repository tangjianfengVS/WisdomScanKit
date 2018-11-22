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
    
    fileprivate lazy var listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //view.register(WisdomPhotoEditCell.self, forCellWithReuseIdentifier: PhotoEditCellKey)
        //view.delegate = self
        //view.dataSource = self
        //layout.minimumInteritemSpacing = spacing
        //layout.minimumLineSpacing = spacing
        //layout.sectionInset = UIEdgeInsets(top: 0, left: BSpacing, bottom: 0, right: BSpacing)
        return view
    }()
    
    fileprivate let type: WisdomScanningType!
    
    fileprivate let setectType: WisdomSetectPhotoType!
    
    fileprivate let photoCountType: WisdomPhotosCountType!
    
    fileprivate var delegate: WisdomScanNavbarDelegate?
    
    fileprivate let photosTask: WisdomPhotosTask!
    
    fileprivate let errorTask: WisdomErrorTask!
    
    var isCreatNav: Bool=false
    
    fileprivate var allAlbums: [[PHFetchResult<AnyObject>]]?
    
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
        
        authoriza()
    }
    
    fileprivate func authoriza() {
        let authoriza = WisdomScanKit.authorizationPhoto()
        switch authoriza {
        case .authorized:
            loadSystemImages()
            
        case .denied:
            if errorTask(WisdomScanErrorType.denied){
                upgrades()
            }
        case .restricted:
            if errorTask(WisdomScanErrorType.restricted){
                
            }
        case .notDetermined:
            loadSystemImages()
        default:
            break
        }
    }
    
    fileprivate func upgrades(){
        showAlert(title: "允许访问相册提示", message: "App需要您同意，才能访问相册读取图片", cancelActionTitle: "取消", rightActionTitle: "去开启") { (action) in
            WisdomScanKit.authorizationScan()
        }
    }
    
    /** 加载系统所有图片 */
    fileprivate func loadSystemImages() {
        PHPhotoLibrary.shared().register(self)
        
        var allSmartAlbums = [PHFetchResult<PHAsset>]()//PHFetchResult<PHAsset>
        let allOptions = PHFetchOptions()//  所有图片
        allOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]//  时间排序
        let allPhotos = PHAsset.fetchAssets(with: allOptions)
        allSmartAlbums.append(allPhotos)
        
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        //  智能相册---最近添加
        let collection = smartAlbums.object(at: PHAssetCollectionSubtype.smartAlbumRecentlyAdded.hashValue)
        let recentely = PHAsset.fetchAssets(in: collection, options: nil)
        allSmartAlbums.append(recentely)

        //  智能相册---屏幕截图
        if #available(iOS 9.0, *) {
            let screenshot = smartAlbums.object(at: PHAssetCollectionSubtype.smartAlbumScreenshots.hashValue)
            let screenshotResult = PHAsset.fetchAssets(in:screenshot, options: nil)
            allSmartAlbums.append(screenshotResult)
        } else {
            
        }
        //  智能相册---个人收藏
        let favorite = smartAlbums.object(at: PHAssetCollectionSubtype.smartAlbumFavorites.hashValue)
        let favoriteResult = PHAsset.fetchAssets(in: favorite, options: nil)
        allSmartAlbums.append(favoriteResult)

        //  个人自定义相册
        let userDeterminAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let allAlbum = [allSmartAlbums,[userDeterminAlbums]] as! [[PHFetchResult<AnyObject>]]
        allAlbums = allAlbum
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoSelectVC: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
}
