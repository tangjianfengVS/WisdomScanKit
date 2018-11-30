//
//  WisdomPhotoChromeFlowLayout.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/29.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoChromeFlowLayout: UICollectionViewFlowLayout {
    fileprivate let space: CGFloat=15.0
    
    fileprivate var currentOffsetX: CGFloat = 0.0
    
    fileprivate let handers: ((Int)->())!
    
    init(hander: @escaping ((Int)->())) {
        handers = hander
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.bounds.size
        scrollDirection = .horizontal
        minimumLineSpacing = space
    }
    
    /** 更新下偏移尺寸 */
    func updateCurrentOffsetX(index: Int) {
        currentOffsetX = CGFloat(index) * (collectionView!.bounds.size.width + space)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        /** 加速手势体验优化 */
        var contentOffset: CGFloat = proposedContentOffset.x
       
        if velocity.x > 0.30 {
            contentOffset = contentOffset + itemSize.width
        }else if -velocity.x > 0.30 {
            contentOffset = contentOffset - itemSize.width
        }
        
        if contentOffset <= itemSize.width {
            if contentOffset <= itemSize.width/2{
                currentOffsetX = 0.0
                handers(0)
                return .zero
            }else{
                currentOffsetX = itemSize.width + space
                handers(1)
                return CGPoint(x: currentOffsetX, y: 0)
            }
        }else if contentOffset > (itemSize.width + space) {
            let res = contentOffset - currentOffsetX
            let fabsfRes: CGFloat = CGFloat(fabsf(Float(res)))
            
            if fabsfRes <= itemSize.width/2{
                handers(Int(currentOffsetX / (itemSize.width + space)))
                return CGPoint(x: currentOffsetX, y: 0)
                
            }else if res > 0{
                currentOffsetX = currentOffsetX + (itemSize.width + space)
            }else if res < 0{
                currentOffsetX = currentOffsetX - (itemSize.width + space)
                if currentOffsetX < 0{
                    currentOffsetX = 0
                }
            }
            handers(Int(currentOffsetX / (itemSize.width + space)))
            return CGPoint(x: currentOffsetX, y: 0)
        }
        handers(0)
        return .zero
    }
}
