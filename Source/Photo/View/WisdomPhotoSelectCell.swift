//
//  WisdomPhotoSelectCell.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/23.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit


class WisdomPhotoBaseCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: contentView.bounds)
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
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
        backgroundColor  = UIColor.clear
        
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(imageView)
        
        contentView.wisdom_addConstraint(with: imageView,
                                         topView: contentView,
                                         leftView: contentView,
                                         bottomView: contentView,
                                         rightView: contentView,
                                         edgeInset: UIEdgeInsets.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class WisdomPhotoSelectCell: WisdomPhotoBaseCell {
    
    private(set) lazy var selectBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: contentView.bounds.width - 23, y: 2, width: 21, height: 21))
        
        var image = WisdomPhotoSelectImage()
        btn.setBackgroundImage(image.imageOfEmpty, for: .normal)
        btn.setBackgroundImage(image.imageOfSelect, for: .selected)// Wisdom_Select_Empty   Wisdom_Select_Ing
        
        btn.addTarget(self, action: #selector(clickSelectedBtn), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickSelectedBtn(btn: UIButton){
        if let closure = hander, let selImage = image {
            let res = closure(btn.isSelected, selImage)
            btn.isSelected = res
        }
    }
}


//class WisdomPhotoSelectedImage: UIImage {
    
//    override init() {
//        super.init()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    private lazy var circleLayer: CAShapeLayer = {
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
//                        radius: (size - getLineWidth())/2,
//                    startAngle: Double.pi*1.25,
//                      endAngle: Double.pi*3.25,
//                     clockwise: true)
//
//        path.move(to: CGPoint(x: size/3.9, y: size/2))
//        path.addLine(to: CGPoint(x: size/5*2.2, y: size/3*2))
//        path.addLine(to: CGPoint(x: size*0.74, y: size/2.7))
//
//        let circle = CAShapeLayer()
//        circle.fillColor = UIColor.clear.cgColor
//        circle.strokeColor = UIColor.white.cgColor
//        circle.lineCap = CAShapeLayerLineCap.round
//        circle.lineWidth = getLineWidth()
//        circle.strokeEnd = 1.0
//        circle.path = path.cgPath
//        return circle
//    }()
//
//    private lazy var animation: CABasicAnimation = {
//        let anim = CABasicAnimation(keyPath: "strokeEnd")
//        anim.duration = Self.getAnimDuration()
//        anim.fromValue = 0
//        anim.toValue = 1
//        anim.timingFunction = CAMediaTimingFunction(name: .linear)
//        return anim
//    }()
//
//    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
//        super.init(size: size)
//        switch barStyle {
//        case .dark:
//            circleLayer.strokeColor = UIColor.white.cgColor
//        case .light:
//            circleLayer.strokeColor = Self.getLightColor()
//        case .hide:
//            circleLayer.strokeColor = UIColor.white.cgColor
//        }
//        layer.addSublayer(circleLayer)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc public override func getLineWidth()->CGFloat{
//        return size/24//29-1.2
//    }
//
//    @objc public override class func getAnimDuration()->CGFloat{
//        return 0.8
//    }
//
//    @objc public override class func getLightColor()->CGColor{
//        return UIColor.black.cgColor
//    }
//
//    @objc public override func beginAnimation(isRepeat: Bool){
//        animation.repeatCount = isRepeat ? MAXFLOAT : 1
//        circleLayer.add(animation, forKey: "animateCircle")
//    }
//}


//class WisdomPhotoSelectImage: UIImage {
    
//    private lazy var circleLayer: CAShapeLayer = {
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
//                        radius: (size - getLineWidth())/2,
//                    startAngle: Double.pi*1.25,
//                      endAngle: Double.pi*3.25,
//                     clockwise: true)
//
//        path.move(to: CGPoint(x: size/3.9, y: size/2))
//        path.addLine(to: CGPoint(x: size/5*2.2, y: size/3*2))
//        path.addLine(to: CGPoint(x: size*0.74, y: size/2.7))
//
//        let circle = CAShapeLayer()
//        circle.fillColor = UIColor.clear.cgColor
//        circle.strokeColor = UIColor.white.cgColor
//        circle.lineCap = CAShapeLayerLineCap.round
//        circle.lineWidth = getLineWidth()
//        circle.strokeEnd = 1.0
//        circle.path = path.cgPath
//        return circle
//    }()
//
//    private lazy var animation: CABasicAnimation = {
//        let anim = CABasicAnimation(keyPath: "strokeEnd")
//        anim.duration = Self.getAnimDuration()
//        anim.fromValue = 0
//        anim.toValue = 1
//        anim.timingFunction = CAMediaTimingFunction(name: .linear)
//        return anim
//    }()
//
//    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
//        super.init(size: size)
//        switch barStyle {
//        case .dark:
//            circleLayer.strokeColor = UIColor.white.cgColor
//        case .light:
//            circleLayer.strokeColor = Self.getLightColor()
//        case .hide:
//            circleLayer.strokeColor = UIColor.white.cgColor
//        }
//        layer.addSublayer(circleLayer)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc public override func getLineWidth()->CGFloat{
//        return size/24//29-1.2
//    }
//
//    @objc public override class func getAnimDuration()->CGFloat{
//        return 0.8
//    }
//
//    @objc public override class func getLightColor()->CGColor{
//        return UIColor.black.cgColor
//    }
//
//    @objc public override func beginAnimation(isRepeat: Bool){
//        animation.repeatCount = isRepeat ? MAXFLOAT : 1
//        circleLayer.add(animation, forKey: "animateCircle")
//    }
//}

struct WisdomPhotoSelectImage {
    
    lazy var imageOfSelect: UIImage = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 21,height: 21), false, 0)
        WisdomPhotoSelectDraw.draw(true, size: 21)
        let icon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return icon ?? UIImage()
    }()
    
    lazy var imageOfEmpty: UIImage = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 21,height: 21), false, 0)
        WisdomPhotoSelectDraw.draw(false, size: 21)
        let icon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return icon ?? UIImage()
    }()
}


class WisdomPhotoSelectDraw {
    
    class func draw(_ isSelect: Bool, size: CGFloat) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: size/2, y: size/2))
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                        radius: (size-1)/2,
                    startAngle: Double.pi*1.5,
                      endAngle: Double.pi*3.5,
                     clockwise: true)
        path.close()
        
        path.move(to: CGPoint(x: size/3.9, y: size/2))
        path.addLine(to: CGPoint(x: size/5*2.2, y: size/3*2))
        path.addLine(to: CGPoint(x: size*0.74, y: size/2.7))
        path.close()
        
//        switch type {
//        case .imageOfSelect: break
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/4, y: HUD_ImageWidth_Height/2))
//            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/5*2, y: HUD_ImageWidth_Height/3*2))
//            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/4*3, y: HUD_ImageWidth_Height/3))
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/4, y: HUD_ImageWidth_Height/3))
//            checkmarkShapePath.close()
//        case .imageOfEmpty: break
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/3-1, y: HUD_ImageWidth_Height/3-1))
//            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/3*2+1, y: HUD_ImageWidth_Height/3*2+1))
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/3-1, y: HUD_ImageWidth_Height/3*2+1))
//            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/3*2+1, y: HUD_ImageWidth_Height/3-1))
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/3-1, y: HUD_ImageWidth_Height/3-1))
//            checkmarkShapePath.close()
//        case .info:
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/2, y: 8))
//            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height/5*3))
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/2, y: 6))
//            checkmarkShapePath.close()
//            UIColor.white.setStroke()
//            checkmarkShapePath.stroke()
//
//            let checkmarkShapePath = UIBezierPath()
//            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height-8))
//            checkmarkShapePath.addArc(withCenter: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height/5*3+4),
//                                      radius: 1.2,
//                                      startAngle: 0,
//                                      endAngle: CGFloat(Double.pi*2),
//                                      clockwise: true)
//            checkmarkShapePath.close()
//
//            UIColor.white.setFill()
//            checkmarkShapePath.fill()
//        case .loading:
//            break
//        case .text:
//            break
//        }
        if isSelect {
            UIColor(red: 26/256.0, green: 100/256.0, blue: 26/256.0, alpha: 1).setStroke()
        }else {
            UIColor.white.setStroke()
        }
        path.stroke()
    }
    
}
