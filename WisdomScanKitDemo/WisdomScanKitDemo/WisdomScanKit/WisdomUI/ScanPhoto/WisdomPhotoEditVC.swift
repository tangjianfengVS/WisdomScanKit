//
//  WisdomPhotoEditVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/13.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoEditVC: UIViewController {
    fileprivate var imageArray: [UIImage] = []
    
    fileprivate let beginCenter: CGPoint!
    
    fileprivate let beginSize: CGSize!
    
    fileprivate let callBack: ((Bool,[UIImage])->())!
    
    fileprivate let PhotoEditCellKey = "WisdomPhotoEditCellkey"
    
    fileprivate let spacing: CGFloat = 3
    
    fileprivate let BSpacing: CGFloat = 16
    
    fileprivate lazy var listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(WisdomPhotoEditCell.self, forCellWithReuseIdentifier: PhotoEditCellKey)
        view.delegate = self
        view.dataSource = self
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: BSpacing, bottom: 0, right: BSpacing)
        return view
    }()
    
    fileprivate lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 30, y: self.view.bounds.height - 40, width: 50, height: 30))
        btn.addTarget(self, action: #selector(clickBack(btn:)), for: .touchUpInside)
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    
    fileprivate lazy var realBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.view.bounds.width - 30 - 50,
                                         y: self.view.bounds.height - 40, width: 50, height: 30))
        btn.addTarget(self, action: #selector(clickBack(btn:)), for: .touchUpInside)
        btn.setTitle("完成", for: .normal)
        return btn
    }()
    
    init(imageList: [UIImage],
         beginCenters: CGPoint,
         beginSizse: CGSize,
         endTask: @escaping ((Bool,[UIImage])->())) {
        beginCenter = beginCenters
        beginSize = beginSizse
        callBack = endTask
        imageArray = imageList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(listView)
        view.addSubview(backBtn)
        view.addSubview(realBtn)
        listView.frame = view.bounds
    }
    
    @objc fileprivate func clickBack(btn: UIButton){
        let scbl = beginSize.width/view.bounds.width
        let ydblW = view.center.x-beginCenter.x
        let ydblY = beginCenter.y-view.center.y
        
        UIView.animate(withDuration: 0.35, animations: {
            self.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
            self.view.transform = self.view.transform.scaledBy(x: scbl, y: scbl)
        }) { (_) in
        
            if btn == self.backBtn {
                self.callBack(false,[])
            }else if btn == self.realBtn {
                self.callBack(true,self.imageArray)
            }
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    class func showEdit(rootVC: UIViewController,
                        imageList: [UIImage],
                        beginCenter: CGPoint,
                        beginSize: CGSize,
                        endTask: @escaping ((Bool,[UIImage])->())) {
        let editVC = WisdomPhotoEditVC(imageList: imageList,
                                       beginCenters:beginCenter,
                                       beginSizse: beginSize,
                                       endTask: endTask)
        editVC.view.frame = rootVC.view.frame
        
        rootVC.addChild(editVC)
        rootVC.view.addSubview(editVC.view)
        
        let scbl = beginSize.width/rootVC.view.bounds.width
        let ydblW = rootVC.view.center.x-beginCenter.x
        let ydblY = -rootVC.view.center.y+beginCenter.y
        
        editVC.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
        editVC.view.transform = editVC.view.transform.scaledBy(x: scbl, y: scbl)
        
        UIView.animate(withDuration: 0.35, animations: {
            editVC.view.transform = .identity
        })
    }
    
    deinit {
        print("编辑器释放")
    }
}

extension WisdomPhotoEditVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditCellKey, for: indexPath) as! WisdomPhotoEditCell
        cell.image = imageArray[indexPath.item]
        cell.callBack = {[weak self] in
            self?.imageArray.remove(at: indexPath.item)
            self?.listView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (view.bounds.width - 2*spacing - 2*BSpacing)/3,
                          height: view.bounds.height*(view.bounds.width - 2*spacing - 2*BSpacing)/3/view.bounds.width)
        return size
    }
}
