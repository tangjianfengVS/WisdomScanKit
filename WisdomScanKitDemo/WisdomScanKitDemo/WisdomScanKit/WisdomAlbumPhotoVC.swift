//
//  WisdomAlbumPhotoVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/27.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

class HandleSelectionPhotosManager: NSObject {
    static let share = HandleSelectionPhotosManager()
    
    var maxCount: Int = 0
    var callbackPhotos: WisdomPhotosHander?
    
    private override init() {
        super.init()
    }
    
    func getSelectedPhotos(with count: Int, callback completeHandle: WisdomPhotosHander? ) {
        // 限制图片数量
        maxCount = count < 1 ? 1 : (count > 9 ? 9 : count)
        self.callbackPhotos = completeHandle
    }
}

enum AlbumTransformChina: String {
    case Favorites
    case RecentlyDeleted = "Recently Deleted"
    case Screenshots
    
    func chinaName() -> String {
        switch  self {
        case .Favorites:
            return "最爱"
        case .RecentlyDeleted:
            return "最近删除"
        case .Screenshots:
            return "手机截屏"
        }
    }
}

/// 相册类型
///
/// - albumAllPhotos: 所有
/// - albumSmartAlbums: 智能
/// - albumUserCollection: 收藏
enum AlbumSession: Int {
    case albumAllPhotos = 0
    //   case albumSmartAlbums
    case albumUserCollection
    
    static let count = 2
}

class WisdomAlbumPhotoVC: UITableViewController {
    fileprivate let WisdomAlbumPhotoCellID = "WisdomAlbumPhotoCellIdentifier"
    
    fileprivate var allPhotos: PHFetchResult<PHAsset>!
    
    fileprivate var smartAlbums: PHFetchResult<PHAssetCollection>!
    
    fileprivate var userCollections: PHFetchResult<PHCollection>!
    
    fileprivate let sectionTitles = ["", "智能相册", "相册"]
    
    fileprivate var MaxCount: Int = 0
    
    fileprivate var handleSelectionAction: (([String], [String]) -> Void)?
    
    var isCreatNav: Bool=false
    
    fileprivate let startType: WisdomScanStartType!
    
    init(startTypes: WisdomScanStartType) {
        startType = startTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "照片"
        addCancleItem()
        fetchAlbumsFromSystemAlbum()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    /** 获取所有系统相册概览信息 */
    private func fetchAlbumsFromSystemAlbum() {
        let allPhotoOptions = PHFetchOptions()
        /** 时间排序 */
        allPhotoOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotoOptions)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        /** 监测系统相册增加，即使用期间是否拍照 */
        PHPhotoLibrary.shared().register(self)
        
        tableView.register(WisdomAlbumPhotoCell.self, forCellReuseIdentifier: WisdomAlbumPhotoCellID)
    }
    
    
    /** 添加取消按钮 */
    private func addCancleItem() {
        let barItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissAction))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return AlbumSession.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch AlbumSession(rawValue: section)! {
        case .albumAllPhotos:
            return 1
        //    case .albumSmartAlbums: return smartAlbums.count
        case .albumUserCollection:
            return userCollections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WisdomAlbumPhotoCellID, for: indexPath) as! WisdomAlbumPhotoCell
        cell.selectionStyle = .none
        
        switch AlbumSession(rawValue: indexPath.section)! {
        case .albumAllPhotos:
            cell.asset = allPhotos.firstObject
            cell.albumTitleAndCount = ("所有照片", allPhotos.count)
            //        case .albumSmartAlbums:
            //            let collection = smartAlbums.object(at: indexPath.row)
            //            cell.asset = PHAsset.fetchAssets(in: collection, options: nil).firstObject
        //            cell.albumTitleAndCount = (collection.localizedTitle, PHAsset.fetchAssets(in: collection, options: nil).count)
        case .albumUserCollection:
            let collection = userCollections.object(at: indexPath.row)
            cell.asset = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: nil).firstObject
            cell.albumTitleAndCount = (collection.localizedTitle, PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: nil).count)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let gridVC = HsuAssetGridViewController()
//        switch AlbumSession(rawValue: indexPath.section)! {
//        case .albumAllPhotos:
//            gridVC.fetchAllPhtos = allPhotos
//            //        case .albumSmartAlbums:
//            //            gridVC.assetCollection = smartAlbums.object(at: indexPath.row)
//        //            gridVC.fetchAllPhtos = PHAsset.fetchAssets(in: gridVC.assetCollection!, options: nil)
//        case .albumUserCollection:
//            gridVC.assetCollection = userCollections.object(at: indexPath.row) as? PHAssetCollection
//            gridVC.fetchAllPhtos = PHAsset.fetchAssets(in: gridVC.assetCollection!, options: nil)
//        }
//        let currentCell = tableView.cellForRow(at: indexPath) as! MasterTableViewCell
//        gridVC.title = currentCell.albumTitleAndCount?.0
//        navigationController?.pushViewController(gridVC, animated: true)
//
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
}

extension WisdomAlbumPhotoVC: PHPhotoLibraryChangeObserver {
    /// 系统相册改变
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        DispatchQueue.main.sync {
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            //
            //            if let changeDetail = changeInstance.changeDetails(for: smartAlbums) {
            //                smartAlbums = changeDetail.fetchResultAfterChanges
            //                tableView.reloadSections(IndexSet(integer: AlbumSession.albumSmartAlbums.rawValue), with: .automatic)
            //            }
            
            if let changeDetail = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetail.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: AlbumSession.albumUserCollection.rawValue), with: .automatic)
            }
        }
    }
}

