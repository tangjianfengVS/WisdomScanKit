//
//  WisdomScanKit+Extension.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /** 系统界面提示 */
    @objc public func showAlert(title: String,
                                message: String,
                                cancelActionTitle: String?,
                                rightActionTitle: String?,
                                handler: @escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelActionTitle != nil {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        if rightActionTitle != nil {
            let rightAction = UIAlertAction(title: rightActionTitle, style: UIAlertAction.Style.default, handler: { action in
                handler(action)
            })
            alert.addAction(rightAction)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension UIColor {
    
    public func asImage(_ size: CGSize) -> UIImage? {
        var resultImage: UIImage? = nil
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return resultImage
        }
        
        context.setFillColor(self.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}


extension UIImage {
    /**
     *   计算填充屏幕尺寸:
     *   说明：以填充屏幕尺寸为目标， 计算原声图片在屏幕上的Rect
     */
    @objc func getImageChromeRect() -> CGRect {
        let bounds = UIScreen.main.bounds
        if size.width == size.height {
            return CGRect(x: 0,
                          y: (bounds.height - bounds.width)/2,
                          width: bounds.size.width,
                          height: bounds.size.width)
        }else if size.width < bounds.width && size.height < bounds.height{
            
            if (bounds.size.height - size.height) > (bounds.size.width - size.width){
                let height = size.height/size.width * bounds.width
                return CGRect(x: 0,y: (bounds.height - height)/2, width: bounds.size.width,height: height)
            }else{
                let width = size.width/size.height * bounds.height
                return CGRect(x: (bounds.size.width - width)/2,y: 0, width: width,height: bounds.size.height)
            }
        }else if size.width > bounds.width && size.height > bounds.height {
            let wB = size.width/bounds.width
            let hB = size.height/bounds.height
            if wB > hB{
                let height = size.height/size.width * bounds.width
                return CGRect(x: 0,y: (bounds.height - height)/2,width: bounds.width,height: height)
            }else{
                let width = size.width/size.height * bounds.height
                return CGRect(x: (bounds.width - width)/2, y: 0, width: width, height: bounds.height)
            }
        }else if size.width > bounds.width && size.height <= bounds.height {
            
            let height = size.height/size.width * bounds.width
            return CGRect(x: 0,y: (bounds.height - height)/2,width: bounds.width,height: height)
        }else if size.width < bounds.width && size.height >= bounds.height {
            
            let width = size.width/size.height * bounds.height
            return CGRect(x: (bounds.width - width)/2, y: 0,width: width,height: bounds.height)
        }
        return CGRect(x: (bounds.size.width - size.width)/2,
                      y: (bounds.size.height - size.height)/2,
                      width: size.width,
                      height: size.height)
    }
}
