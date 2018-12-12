//
//  WisdomPhotoChromeCell.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/28.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomPhotoChromeCell: UICollectionViewCell {
    /** 图片允许的最大放大倍率 */
    fileprivate var imageMaximumZoomScale: CGFloat = 2.0
    
    /** 图片缩放容器 */
    fileprivate var imageContainer = UIScrollView()
    
    /** 图片拖动时回调 */
    public var panChangedCallback: ((_ scale: CGFloat)-> ())?
    
    /** 图片拖动松手回调 */
    public var panReleasedCallback: ((_ image: UIImage,_ endRect: CGRect)->())?
    
    /** 记录pan手势开始时imageView的位置 */
    fileprivate var beganFrame = CGRect.zero
    
    /** 记录pan手势开始时，手势位置 */
    fileprivate var beganTouch = CGPoint.zero
    
    fileprivate(set) lazy var imageView: UIImageView = {
        let view = UIImageView(frame: self.contentView.frame)
        return view
    }()
    
    var image: UIImage? {
        didSet{
            let rect = WisdomScanKit.getImageChromeRect(image: image!)
            imageView.image = image
            imageView.frame = rect
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        
        imageContainer.maximumZoomScale = imageMaximumZoomScale
        imageContainer.delegate = self
        imageContainer.showsVerticalScrollIndicator = false
        imageContainer.showsHorizontalScrollIndicator = false
        
        imageContainer.frame = contentView.bounds
        imageContainer.setZoomScale(1.0, animated: false)
        imageContainer.setZoomScale(1.0, animated: false)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        imageContainer.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension WisdomPhotoChromeCell {
    /** 计算图片复位坐标 */
//    fileprivate var resettingCenter: CGPoint {
//        let deltaWidth = bounds.width - imageContainer.contentSize.width
//        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
//        let deltaHeight = bounds.height - imageContainer.contentSize.height
//        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
//        return CGPoint(x: imageContainer.contentSize.width * 0.5 + offsetX,
//                       y: imageContainer.contentSize.height * 0.5 + offsetY)
//    }

    /** 计算图片适合的size */
//    fileprivate var fitSize: CGSize {
//        guard let image = imageView.image else {
//            return CGSize.zero
//        }
//        var width: CGFloat
//        var height: CGFloat
//        if imageContainer.bounds.width < imageContainer.bounds.height {
//            // 竖屏
//            width = imageContainer.bounds.width
//            height = (image.size.height / image.size.width) * width
//        } else {
//            // 横屏
//            height = imageContainer.bounds.height
//            width = (image.size.width / image.size.height) * height
//            if width > imageContainer.bounds.width {
//                width = imageContainer.bounds.width
//                height = (image.size.height / image.size.width) * width
//            }
//        }
//        return CGSize(width: width, height: height)
//    }

    /** 复位ImageView */
    fileprivate func resetImageView(size: CGSize) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.center = self.contentView.center
            self.imageView.bounds.size = size
        }) { (_) in
            self.panChangedCallback?(1)
        }
    }
}

extension WisdomPhotoChromeCell: UIScrollViewDelegate {
    /** 响应拖动 */
    @objc fileprivate func onPan(_ pan: UIPanGestureRecognizer) {
        guard imageView.image != nil else {
            return
        }
        switch pan.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = pan.location(in: imageContainer)
        case .changed:
            let result = panResult(pan)
            imageView.frame = result.0
            panChangedCallback?(result.1)
        case .ended, .cancelled:
            imageView.frame = panResult(pan).0
            //let isDown = pan.velocity(in: self).y > 0
            let size = WisdomScanKit.getImageChromeRect(image: image!).size
            
            if  imageView.frame.height <= size.height/3*2.2 {
                panReleasedCallback?(imageView.image!, imageView.frame)
            }else{
                resetImageView(size: size)
            }
        default:
            break
            //resetImageView()
        }
    }

    /** 计算拖动时图片应调整的frame和scale值*/
    fileprivate func panResult(_ pan: UIPanGestureRecognizer) -> (CGRect, CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: imageContainer)
        let currentTouch = pan.location(in: imageContainer)

        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))

        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale

        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX

        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY

        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = self.contentView.center
    }
}


extension WisdomPhotoChromeCell: UIGestureRecognizerDelegate {
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只响应pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if imageContainer.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
   }
}
