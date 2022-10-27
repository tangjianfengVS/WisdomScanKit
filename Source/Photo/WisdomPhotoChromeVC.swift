//
//  WisdomPhotoChromeVC.swift
//  WisdomScanKitDemo
//
//  Created by 汤建锋 on 2022/10/25.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit
import WisdomHUD
import Photos

class WisdomPhotoChromeVC: UIViewController {
    
    private let spacing: CGFloat = 3.5
    
    private let isCustomChrome: Bool
    
    private lazy var lineCount: CGFloat = { return view.bounds.width > 330 ? 4:3 }()
    
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
        collectionVI.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
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
    
    /** 选择的结果资源 */
    private let images: [UIImage]
    
    private var assets = PHFetchResult<PHAsset>()
    
    /** 浏览页正在展示的图片 */
    private var curShowImageRect: CGRect = .zero
    
    private var beginImage: UIImage?
    
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
    
    init(title: String,
         transform: WisdomScanTransformStyle,
         theme: WisdomScanThemeStyle) {
        self.images = []
        self.theme = theme
        self.transform = transform
        self.isCustomChrome = false
        super.init(nibName: nil, bundle: nil)
    }
    
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
        if !isCustomChrome {
            authoriza()
        }
        
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
            let image = UIColor.init(white: 0, alpha: 0.85).asImage(CGSize(width: view.bounds.width, height: 88)) ?? UIImage() ///设置导航栏背景图片
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        if assets.count > 0 {
            imageManager.stopCachingImagesForAllAssets()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomPhotoChromeVC: WisdomPhotoChromeControllerable {
    
    internal func setNavbarUI(){
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
    }
    
    internal func authoriza() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            switch status {
            case .authorized:
                DispatchQueue.global().async { loadSystemImages() }
            case .denied:
                showAlert()
            case .restricted:
                showAlert()
            case .notDetermined:
                DispatchQueue.global().async { loadSystemImages() }
            default: break
            }
        })
        
        func showAlert(){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) { [weak self] in
                self?.wisdom_showAlert(title: "相册访问权限已关闭",
                                 message: "App需要您的同意，才能访问相册，读取本地图片，立即开启？",
                                 cancelActionTitle: "取消",
                                 rightActionTitle: "立即开启") { (action) in
                    if let title = action.title {
                        if title == "立即开启"{
                            _=WisdomScanManager.openSystemSetting()
                        }
                    }
                    self?.clickBackBtn()
                }
            }
        }
        
        func loadSystemImages() {
            /** 则获取所有资源 */
            let allPhotosOptions = PHFetchOptions()
            /** 按照创建时间倒序排列 */
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            /** 只获取图片 */
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
    
            DispatchQueue.main.async { [weak self] in
                self?.listView.reloadData()
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
    }
    
    internal func beginShow(index: Int, coverViewFrame: CGRect){
        if isCustomChrome {
            WisdomScanKit.startPhotoChrome(startIndex: index,
                                           startAnimaRect: curShowImageRect,
                                           images: images,
                                           didChromeClosure: { [weak self] (currentIndex: Int) -> CGRect in
                if currentIndex >= self?.images.count ?? 0 {
                    return .zero
                }
                return didChrome(currentIndex: currentIndex)
            })
        }else {
            WisdomScanKit.startPhotoChrome(startIndex: index,
                                           startAnimaRect: curShowImageRect,
                                           assets: assets,
                                           didChromeClosure: { [weak self] (currentIndex: Int) -> CGRect in
                if currentIndex >= self?.assets.count ?? 0 {
                    return .zero
                }
                return didChrome(currentIndex: currentIndex)
            })
        }
        
        func didChrome(currentIndex: Int)->CGRect{
            let indexPath = IndexPath(item: currentIndex, section: 0)
            listView.scrollToItem(at: indexPath, at: .top, animated: false)

            let window = UIApplication.shared.delegate?.window!
            var rect: CGRect = .zero

            if let cell = listView.cellForItem(at: indexPath) {
                rect = cell.convert(cell.bounds, to: window)
                curShowImageRect = rect
            }
            return rect
        }
    }
    
    @objc internal func clickBackBtn(){
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
//        if transform == .alpha {
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
//        }
    }
}

extension WisdomPhotoChromeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCustomChrome {
            return images.count
        }
        return assets.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WisdomPhotoBaseCell.self)", for: indexPath) as! WisdomPhotoBaseCell
        
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
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoBaseCell
        
        let window = UIApplication.shared.delegate?.window!
        let rect = cell.convert(cell.bounds, to: window)
        curShowImageRect = rect
        
        beginShow(index: indexPath.item, coverViewFrame: cell.frame)
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
