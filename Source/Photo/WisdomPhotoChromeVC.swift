//
//  WisdomPhotoChromeVC.swift
//  WisdomScanKitDemo
//
//  Created by 汤建锋 on 2022/10/25.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit
import WisdomHUD

class WisdomPhotoChromeVC: UIViewController {
    
    private let spacing: CGFloat = 3.5
    
    private let isCustomChrome: Bool
    
    /** 底部Bar高度 */
//    fileprivate var barHeght: CGFloat = 45
    
    /** 导航栏高度 */
//    fileprivate var navBarHeght: CGFloat = 64
    
    private lazy var lineCount: CGFloat = {
        return self.view.bounds.width > 330 ? 4:3
    }()
    
    private lazy var listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionVI = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVI.register(WisdomPhotoSelectCell.self, forCellWithReuseIdentifier: "\(WisdomPhotoSelectCell.self)")
        collectionVI.register(WisdomPhotoBaseCell.self, forCellWithReuseIdentifier: "\(WisdomPhotoBaseCell.self)")
        
        collectionVI.delegate = self
        collectionVI.dataSource = self
        layout.itemSize = CGSize(width: (view.bounds.width-(lineCount-1)*spacing)/lineCount,
                                 height: (view.bounds.width-(lineCount+1)*spacing)/lineCount)
        
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
        
        let scale = UIScreen.main.scale
        let cellSize = layout.itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width*scale, height:cellSize.height*scale)
        collectionVI.backgroundColor = .clear
        collectionVI.translatesAutoresizingMaskIntoConstraints = false
//        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: barHeght, right: 0)
        return collectionVI
    }()
    
    private lazy var navBackBtn: WisdomNavBackBtn = {
        let btn = WisdomNavBackBtn(frame: CGRect(x: 0, y: 0, width: 45, height: 30), theme: theme)
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        return btn
    }()
    
    private var headerTitle="所有照片"
    
    private let transform: WisdomScanTransformStyle
    
    private let theme: WisdomScanThemeStyle
    
    /** 取得的资源集合，用了存放的PHAsset */
//    fileprivate var assetsFetchResults: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    
    /** 选择的结果资源 */
    private let images: [UIImage]
    
//    fileprivate var indexPathResults: [IndexPath] = []
    
    /** 浏览页正在展示的图片 */
    private var currentShowImagerRect: CGRect = .zero
    
//    fileprivate var beginImage: UIImage?
    
    var isCreatNav: Bool=false
    
    init(title: String,
         images: [UIImage],
         transform: WisdomScanTransformStyle,
         theme: WisdomScanThemeStyle) {
        self.images = images
        self.theme = theme
        self.transform = transform
        self.isCustomChrome = true
        super.init(nibName: nil, bundle: nil)
    }
    
//    init(startTypes: StartTransformType,
//         countTypes: ElectPhotoCountType,
//         colorTheme: ElectPhotoTheme,
//         delegates:  ElectPhotoDelegate?,
//         photoTasks: @escaping WisdomPhotoTask) {
//
//        startType = startTypes
//        countType = countTypes
//        theme = colorTheme
//        delegate = delegates
//        photoTask = photoTasks
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(listView)
        
        view.wisdom_addConstraint(with: listView,
                                  topView: view,
                                  leftView: view,
                                  bottomView: view,
                                  rightView: view,
                                  edgeInset: UIEdgeInsets.zero)
        
        setNavbarUI()
        authoriza()
        
        var color = (UIColor.white, UIColor.black)
        switch theme {
        case .light: color = (UIColor.white, UIColor.black)
        case .dark: color = (UIColor.black, UIColor.white)
        default: color = (UIColor.white, UIColor.black)
        }
        title = headerTitle
        view.backgroundColor = color.0
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:color.1]
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if theme == .dark {
            navigationController?.navigationBar.isTranslucent = true///设置导航栏半透明
            let image = UIColor.init(white: 0, alpha: 0.8).asImage(CGSize(width: view.bounds.width, height: 88)) ?? UIImage() ///设置导航栏背景图片
            navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if theme == .dark {
            navigationController?.navigationBar.isTranslucent = false///设置导航栏半透明
            navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        }
    }
    
    fileprivate func authoriza() {
//        PHPhotoLibrary.requestAuthorization({ (status) in
//            switch status {
//            case .authorized:
//                DispatchQueue.global().async {
//                    self.loadSystemImages()
//                }
//            case .denied:
//                self.upgrades()
//            case .restricted:
//                self.upgrades()
//            case .notDetermined:
//                DispatchQueue.global().async {
//                    self.loadSystemImages()
//                }
//
//            default:
//                break
//            }
//        })
    }
    
    override public func viewSafeAreaInsetsDidChange() {
//        if #available(iOS 11.0, *) {
//            if view.safeAreaInsets.bottom > 10{
//                barHeght = 64
////                selectBar.updateHeight(height: barHeght)
//            }
//            navBarHeght = view.safeAreaInsets.top
//        }
//        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: barHeght, right: 0)
    }
    
    fileprivate func upgrades(){
        showAlert(title: "相册访问权限已关闭", message: "App需要您同意，才能访问相册读取图片", cancelActionTitle: "取消", rightActionTitle: "立即开启") {[weak self] (action) in
            
            if let title = action.title {
                if title == "立即开启"{
//                    WisdomScanKit.authorizationScan()
                }
            }
            
            self?.clickBackBtn()
        }
    }
    
    /** 加载系统所有图片 */
    fileprivate func loadSystemImages() {
        /** 则获取所有资源 */
//        let allPhotosOptions = PHFetchOptions()
//        /** 按照创建时间倒序排列 */
//        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
//                                                             ascending: false)]
//        /** 只获取图片 */
//        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//        assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
//
//        DispatchQueue.main.async {
//            self.listView.reloadData()
//        }
        
        // 新建一个PHImageRequestOptions对象
        //let imageRequestOption = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        //imageRequestOption.isSynchronous = true
        // 缩略图的压缩模式设置为无
        //imageRequestOption.resizeMode = .none
        // 缩略图的质量为高质量，不管加载时间花多少
        //imageRequestOption.deliveryMode = .highQualityFormat
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
//        if assetsFetchResults.count > 0 {
//            imageManager.stopCachingImagesForAllAssets()
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoChromeVC {
    
    private func setNavbarUI(){
//        if (delegate != nil) {
//            let backBtn = delegate!.electPhotoNavbarBackItme(navigationVC: navigationController!)
//            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
//            backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
//
//            let customView = delegate!.electPhotoNavbarCustomTitleItme(navigationVC: navigationController!)
//            navigationItem.titleView = customView
//        }else{
        if let _ = navigationController {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBackBtn)
        }else {
            navBackBtn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(navBackBtn)
            
            navBackBtn.wisdom_addConstraint(width: 45, height: 30)
            view.wisdom_addConstraint(with: navBackBtn,
                                      topView: view,
                                      leftView: view,
                                      bottomView: nil,
                                      rightView: nil,
                                      edgeInset: UIEdgeInsets(top: 80, left: 20, bottom: 0, right: 0))
        }
        
        
//            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        
//        }
//
//        rightBtn.titleLabel?.textAlignment = .right
//
//        if countType == .once {
//            rightBtn.isHidden = true
//        }
    }
    
    private func beginShow(index: Int, coverViewFrame: CGRect){
        if isCustomChrome {
            WisdomScanKit.startPhotoChrome(startIndex: index,
                                           startAnimaRect: currentShowImagerRect,
                                           images: images,
                                           didChromeClosure: { [weak self] (currentIndex: Int) -> CGRect in
                // 更新结束动画 Rect
                let indexPath = IndexPath(item: currentIndex, section: 0)
                let window = UIApplication.shared.delegate?.window!
                
                if let cell = self?.listView.cellForItem(at: indexPath) {
                    let rect = cell.convert(cell.bounds, to: window)
                    return rect
                }
                return .zero
            })
        }
        
//        imageManager.requestImage(for: assetsFetchResults[index],
//                                  targetSize: UIScreen.main.bounds.size,
//                                  contentMode: PHImageContentMode.aspectFit,
//                                  options: options,
//                                  resultHandler: { (image, _) -> Void in
//           if image != nil {
//
//               WisdomScanKit.startPhotoChrome(startIndex: index,
//                                              startAnimatRect: self.currentShowImagerRect,
//                                              fetchResult: self.assetsFetchResults,
//                                              didChromeClosure: {[weak self] (currentIndex: Int) -> CGRect in
//
//                   if currentIndex >= (self?.assetsFetchResults)!.count{
//                       return .zero
//                   }
//
//                   let indexPath = IndexPath(item: currentIndex, section: 0)
//                   self?.listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
//
//                   let window = UIApplication.shared.delegate?.window!
//                   let cell = self?.listView.cellForItem(at: indexPath)
//                   var rect: CGRect = .zero
//
//                   if cell != nil{
//                       rect = cell!.convert(cell!.bounds, to: window)
//                       self?.currentShowImagerRect = rect
//                   }
//
//                   return rect
//               })
//           }else{
////               WisdomHUD.showText(text: "图加载失败")
//           }
//        })
    }
    
    @objc private func clickBackBtn(){
//        if startType == .push {
//            if navigationController != nil && isCreatNav {
//                UIView.animate(withDuration: 0.35, animations: {
//                    self.navigationController!.view.transform = CGAffineTransform(translationX: self.navigationController!.view.bounds.width, y: 0)
//                }) { (_) in
//                    self.navigationController!.view.removeFromSuperview()
//                    self.navigationController!.removeFromParent()
//                }
//            }else if navigationController != nil && !isCreatNav {
//                navigationController!.popViewController(animated: true)
//            }else{
//                UIView.animate(withDuration: 0.35, animations: {
//                    self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
//                }) { (_) in
//                    self.view.removeFromSuperview()
//                    self.removeFromParent()
//                }
//            }
//        }else if startType == .present{
//            if navigationController != nil {
//                navigationController!.dismiss(animated: true, completion: nil)
//            }else{
//                dismiss(animated: true, completion: nil)
//            }
//        }else
        if transform == .alpha {
            if let nav = navigationController {
                UIView.animate(withDuration: 0.35, animations: {
                    nav.view.alpha = 0
                }) { (_) in
                    nav.dismiss(animated: false)
                }
            }else {
                UIView.animate(withDuration: 0.35, animations: { [weak self] in
                    self?.view.alpha = 0
                }) { [weak self] (_) in
                    self?.dismiss(animated: false)
                }
            }
        }
    }
}

extension WisdomPhotoChromeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCustomChrome {
            return images.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if isCustomChrome {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WisdomPhotoBaseCell.self)", for: indexPath) as! WisdomPhotoBaseCell
            cell.image = images[indexPath.item]
            return cell
        }
        
//        imageManager.requestImage(for: assetsFetchResults[indexPath.item],
//                                  targetSize: assetGridThumbnailSize,
//                                  contentMode: PHImageContentMode.aspectFit,
//                                  options: nil,
//                                              resultHandler: { (image, _) -> Void in
//            cell.image = image
//            if indexPath.item == 0{
//                self.beginImage = image
//            }
//        })
//
//        if indexPathResults.contains(indexPath){
//            cell.selectBtn.isSelected = true
//        }else{
//            cell.selectBtn.isSelected = false
//        }
//
//        cell.hander = {[weak self] (res, image) in
//            let resCell = self?.updatePhotoSelect(res: res, image: image, index: indexPath)
//            return resCell!
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WisdomPhotoSelectCell.self)", for: indexPath) as! WisdomPhotoSelectCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCustomChrome {
            let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoBaseCell
            setBeginShow(cell: cell)
        }else {
            let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoSelectCell
            setBeginShow(cell: cell)
        }
        
        func setBeginShow(cell: UICollectionViewCell){
            let window = UIApplication.shared.delegate?.window!
            let rect = cell.convert(cell.bounds, to: window)
            currentShowImagerRect = rect
            beginShow(index: indexPath.item, coverViewFrame: cell.frame)
        }
    }
}



class WisdomNavBackBtn: UIButton {
    
    init(frame: CGRect, theme: WisdomScanThemeStyle) {
        super.init(frame: frame)
        let path = UIBezierPath()
        let size = CGSize(width: 15/2, height: 15)
        
        path.move(to: CGPoint(x: size.width, y: frame.height/2-size.height/2+2))
        path.addLine(to: CGPoint(x: 0, y: frame.height/2+2))
        path.addLine(to: CGPoint(x: size.width, y: frame.height/2+size.height/2+2))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 1.8
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.cgPath
        
        switch theme {
        case .light: shapeLayer.strokeColor = UIColor.black.cgColor
        case .dark: shapeLayer.strokeColor = UIColor.white.cgColor
        default: shapeLayer.strokeColor = UIColor.black.cgColor
        }
        
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
