//
//  WisdomPhotoEditVC.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/13.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoEditVC: UIViewController {
    private var imageArray: [UIImage] = []
    
    private let PhotoEditCellKey = "WisdomPhotoEditCellkey"
    
    private let spacing: CGFloat = 6
    private let BSpacing: CGFloat = 15
    
    lazy var listView: UICollectionView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(listView)
        listView.frame = view.bounds
    }
    
    class func showEdit(rootVC: UIViewController,
                        imageList: [UIImage],
                        beginCenter: CGPoint,
                        beginSize: CGSize) {
        let editVC = WisdomPhotoEditVC()
        editVC.imageArray = imageList
        editVC.view.frame = rootVC.view.frame
        
        rootVC.addChild(editVC)
        rootVC.view.addSubview(editVC.view)
        
        let scbl = beginSize.width/rootVC.view.bounds.width
        let ydblW = rootVC.view.center.x-beginCenter.x
        let ydblY = -rootVC.view.center.y+beginCenter.y
        
        editVC.view.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
        editVC.view.transform = editVC.view.transform.scaledBy(x: scbl, y: scbl)
        
        UIView.animate(withDuration: 2, animations: {
            editVC.view.transform = .identity
        })
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
