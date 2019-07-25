//
//  ViewController.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/10.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let spacing: CGFloat = 4
    
    /** 底部Bar高度 */
    fileprivate var barHeght: CGFloat = 45
    
    /** 导航栏高度 */
    fileprivate var navBarHeght: CGFloat = 64
    
    /** 横排个数 */
    fileprivate lazy var lineCount: CGFloat = {
        return self.view.bounds.width > 330 ? 4:3
    }()
    
    private let imageList: [UIImage]
    
    var handler: ((Int,CGRect) -> ())?
    
    private let ViewControllerCellID = "ViewControllerCellID"
    
    
    public lazy var listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.register(ViewControllerCell.self, forCellWithReuseIdentifier: ViewControllerCellID)
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
        view.backgroundColor = UIColor.init(white: 0.90, alpha: 1)
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.90, alpha: 1)
        view.addSubview(listView)
        setNavbarUI()
    }
    
    
    fileprivate func setNavbarUI(){

        let navbarBackBtn: UIButton = {
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            let image = WisdomScanManager.bundleImage(name: "black_backIcon")
            btn.setImage(image, for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
            
            btn.addTarget(self, action: #selector(clickBackBtn(btn:)), for: .touchUpInside)
            return btn
        }()
        
        if (navigationController != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navbarBackBtn)
            title = "动画浏览图片"
        }
    }
    
    
    @objc func clickBackBtn(btn: UIButton){
        if navigationController != nil {
            navigationController!.dismiss(animated: true, completion: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    public init(images: [UIImage]) {
        imageList = images
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerCellID, for: indexPath) as! ViewControllerCell
        
        cell.image = imageList[indexPath.item]
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ViewControllerCell
        let window = UIApplication.shared.delegate?.window!
        let rect = cell.convert(cell.bounds, to: window)
//        currentShowImagerRect = rect

//        beginShow(index: indexPath.item, coverViewFrame: cell.frame)
        if handler != nil {
            handler!(indexPath.item,rect)
        }
    }
}




class ViewControllerCell: UICollectionViewCell {
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.contentView.bounds)
        view.backgroundColor = UIColor.cyan
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    public var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    public var hander: ((Bool,UIImage)->(Bool))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
