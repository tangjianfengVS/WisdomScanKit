//
//  WisdomPhotoEditVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/13.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomPhotoEditVC: UIViewController {
    /** 浏览页正在展示的图片 */
    fileprivate var currentShowImagerRect: CGRect = .zero
    
    fileprivate let theme: ElectPhotoTheme
    
    fileprivate var imageArray: [UIImage] = []
    
    fileprivate let beginCenter: CGPoint!
    
    fileprivate let beginSize: CGSize!
    
    fileprivate let callBack: ((Bool,[UIImage])->())!
    
    fileprivate let PhotoEditCellKey = "WisdomPhotoEditCellkey"
    
    fileprivate let spacing: CGFloat = 10
    
    fileprivate let BSpacing: CGFloat = 25
    
    fileprivate let ASpacing: CGFloat = 50
    
    fileprivate lazy var emptyView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 28*100/48))
        let image = WisdomScanManager.bundleImage(name: "empty_icon")
        imageView.image = image
        imageView.center = self.view.center
        return imageView
    }()
    
//    fileprivate lazy var coverView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.init(white: 0.90, alpha: 1)
//        view.isHidden = true
//        return view
//    }()
    
    fileprivate lazy var listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let rect = CGRect(x: BSpacing, y: ASpacing, width: self.view.bounds.width-BSpacing*2, height: self.view.bounds.height-ASpacing*2)
        let view = UICollectionView(frame: rect, collectionViewLayout: layout)
        view.register(WisdomPhotoEditCell.self, forCellWithReuseIdentifier: PhotoEditCellKey)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        return view
    }()
    
    fileprivate lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 30, y: self.view.bounds.height - 40, width: 50, height: 30))
        btn.addTarget(self, action: #selector(clickBack(btn:)), for: .touchUpInside)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(self.theme == .whiteLight ?UIColor.black:UIColor.white, for: .normal)
        return btn
    }()
    
    fileprivate lazy var realBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.view.bounds.width - 30 - 50,
                                         y: self.view.bounds.height - 40, width: 50, height: 30))
        btn.addTarget(self, action: #selector(clickBack(btn:)), for: .touchUpInside)
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(self.theme == .whiteLight ?UIColor.black:UIColor.white, for: .normal)
        return btn
    }()
    
    
    private lazy var toolImgv: UIImageView = {
        let imgv = UIImageView(image: WisdomScanManager.bundleImage(name: "wisdom_timg"))
        imgv.frame = self.view.frame
        return imgv
    }()
    
    
    init(imageList: [UIImage],
         startIconAnimatRect: CGRect,
         colorTheme: ElectPhotoTheme,
         endTask: @escaping (Bool,[UIImage])->()) {
        
        if startIconAnimatRect == CGRect.zero {
            beginCenter = CGPoint.zero
            beginSize = CGSize.zero
        }else{
            beginSize = startIconAnimatRect.size
            beginCenter = CGPoint(x: startIconAnimatRect.minX + beginSize.width/2, y: startIconAnimatRect.minY + beginSize.height/2)
        }
        
        callBack = endTask
        imageArray = imageList
        theme = colorTheme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(toolImgv)
        
        let start: UIBarStyle = self.theme == .whiteLight ? UIBarStyle.default : UIBarStyle.blackTranslucent
        let bar = UIToolbar(frame: self.view.frame)
        bar.barStyle = start
        
        toolImgv.addSubview(bar)
        view.addSubview(listView)
        //listView.addSubview(coverView)
        view.addSubview(backBtn)
        view.addSubview(realBtn)
        
        view.insertSubview(emptyView, aboveSubview: listView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateIndex(notif:)), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateIndex_Key), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(updateCover), name: NSNotification.Name(rawValue: WisdomPhotoChromeUpdateCover_Key), object: nil)
    }
    
    
    //@objc private func updateCover(){
    //    coverView.isHidden = true
    //}
    
    
    /**
     *  处理浏览页面图片在本页面滚动跟踪的Rect
     *  作用：用于浏览结束动画的Rect锁定
     */
    @objc private func updateIndex(notif: Notification){
        if let index = notif.object as? Int {
            if index >= imageArray.count{
                return
            }
            let indexPath = IndexPath(item: index, section: 0)
            listView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
            
            let window = UIApplication.shared.delegate?.window!
            let cell = listView.cellForItem(at: indexPath)
            var rect: CGRect = .zero
            
            if cell != nil{
                rect = cell!.convert(cell!.bounds, to: window)
                //self.coverView.frame = cell!.frame
                self.currentShowImagerRect = rect
            }
            
            DispatchQueue.global().async {
                NotificationCenter.default.post(name: NSNotification.Name(WisdomPhotoChromeUpdateFrame_Key), object: self.currentShowImagerRect)
            }
        }
    }
    
    @objc fileprivate func clickBack(btn: UIButton){
        let scbl = beginSize.width/view.bounds.width
        let ydblW = view.center.x-beginCenter.x
        let ydblY = beginCenter.y-view.center.y
        
        UIView.animate(withDuration: 0.35, animations: {
            self.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
            self.view.transform = self.view.transform.scaledBy(x: scbl, y: scbl)
        }) { (_) in
            self.view.isHidden = true
            if btn == self.backBtn {
                self.callBack(false,[])
            }else if btn == self.realBtn {
                self.callBack(true,self.imageArray)
            }
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WisdomPhotoEditVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyView.isHidden = imageArray.count > 0 ? true:false
        return imageArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditCellKey, for: indexPath) as! WisdomPhotoEditCell
        cell.image = imageArray[indexPath.item]
        cell.electTheme = theme
        cell.callBack = {[weak self] in
            self?.imageArray.remove(at: indexPath.item)
            self?.listView.reloadData()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = (view.bounds.width - BSpacing*2 - spacing*2)/3/view.bounds.width
        let size = CGSize(width: (view.bounds.width - BSpacing*2 - spacing*2)/3,
                          height: view.bounds.height*height)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WisdomPhotoEditCell
    
        let window = UIApplication.shared.delegate?.window!
        let rect = cell.convert(cell.bounds, to: window)
        currentShowImagerRect = rect
        
        WisdomScanKit.startPhotoChrome(startIconIndex: indexPath.item, startIconAnimatRect: rect, iconList: imageArray)
    }
}
