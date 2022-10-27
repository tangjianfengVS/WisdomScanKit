//
//  WisdomScanKit+Extension.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import CommonCrypto


extension UIViewController {
    
    /* 系统界面提示 */
    @objc public func wisdom_showAlert(title: String,
                                       message: String,
                                       cancelActionTitle: String?,
                                       rightActionTitle: String?,
                                       closure: @escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelActionTitle != nil {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .default, handler: { action in
                closure(action)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancelAction)
        }
        
        if rightActionTitle != nil {
            let rightAction = UIAlertAction(title: rightActionTitle, style: UIAlertAction.Style.default, handler: { action in
                closure(action)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(rightAction)
        }
        present(alert, animated: true, completion: nil)
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
    
    
    /* 图片中截取图片 */
    public func getImageFromRect(newImageRect: CGRect) ->UIImage {
        let imageRef = self.cgImage
        let subImageRef = imageRef!.cropping(to: newImageRect)
        return UIImage(cgImage: subImageRef!)
    }
    
}




// MARK: - 图片下载

let WisdomAddDocPath = "/Library/Caches/"

public let WisdomImageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    public func wisdom_setImage(imageUrl: URL, placeholderImage: UIImage?) {
        readWithFile(imageUrl: imageUrl, placeholderImage: placeholderImage)
    }
    
    
    /* read */
    private func readWithFile(imageUrl: URL, placeholderImage: UIImage?){
        let imageUrlStr = imageUrl.absoluteString
        
        let imageUrlStrMD5 = UIImageView.setMd5(imageUrl: imageUrlStr)
        
        let data = WisdomImageCache.object(forKey: imageUrlStrMD5 as AnyObject) as? Data
        if  data != nil{
            let image = UIImage(data: data!)
            
            self.image = image
        }else{
            image = nil
            
            DispatchQueue.global().async {
                let docPath = NSHomeDirectory() + WisdomAddDocPath
                
                let filePath = docPath + imageUrlStrMD5
                
                let image = UIImage(contentsOfFile: filePath)
                
                if image != nil {
                    let dataNew = image!.pngData()
                    WisdomImageCache.setObject(dataNew as AnyObject, forKey: imageUrlStrMD5 as AnyObject)
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }else{
                    self.downLoadImage(imageUrl: imageUrl, placeholderImage: placeholderImage)
                }
            }
        }
    }
    
    
    /* downLoad */
    private func downLoadImage(imageUrl: URL, placeholderImage: UIImage?) {
        let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            if error != nil {
                if placeholderImage != nil{
                    DispatchQueue.main.async {
                        self.image = placeholderImage
                    }
                }
            }else if data != nil {
                let img = UIImage(data: data!)
                
                UIImageView.save(data: data!, image: img!, imageUrl:imageUrl)
                
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        })
        
        downloadTask.resume()
    }
    

    /* save */
    public static func save(data: Data, image: UIImage, imageUrl: URL){
        let imageUrlStr = imageUrl.absoluteString
        let imageUrlStrMD5 = self.setMd5(imageUrl: imageUrlStr)
        
        let docPath = NSHomeDirectory() + WisdomAddDocPath
        let filePath = docPath + imageUrlStrMD5
        let filePathUrl = URL(fileURLWithPath: filePath)
        
        WisdomImageCache.setObject(data as AnyObject, forKey: imageUrlStrMD5 as AnyObject)
        
        do {
            try image.pngData()?.write(to: filePathUrl, options: Data.WritingOptions.atomicWrite)
        }catch {
            print(error)
        }
    }
    
    
    /* downLoad */
    public static func downLoadImage(imageUrl: URL, successClosure: ((URL)->())?, failedClosure: ((URL)->())?) {
        let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    if failedClosure != nil {
                        failedClosure!(imageUrl)
                    }
                }
            }else if data != nil {
                let img = UIImage(data: data!)
                
                UIImageView.save(data: data!, image: img!, imageUrl:imageUrl)
                
                DispatchQueue.main.async {
                    
                    if successClosure != nil {
                        successClosure!(imageUrl)
                    }
                }
            }
        })
        
        downloadTask.resume()
    }
    
    
    private static func setMd5(imageUrl: String) -> String{
        return imageUrl.wisdom_md5() + ".png"
    }
    
}


// MARK: MD5
extension String {
    
    func wisdom_md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
}
