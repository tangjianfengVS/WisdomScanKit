# WisdomsScanKit

   一：简介
   
    推荐一个强大，好用的摄像，扫描器框架： WisdomScanKit 。
    WisdomScanKit 最低支持  iOS 8.0 / Swift 4 编写，SDK处理了系统兼容性问题，并且兼容OC项目调用。
    WisdomScanKit 目前支持四大功能： 一：系统相册图片选择器;   二：全屏摄像功能;   三：扫二维码功能;   四：图片浏览器功能;
        
  二：系统相册图片选择器 功能
  
    1:API：
    // MARK: - startElectSystemPhoto (UIViewController extension method) 
    /// 跳转加载系统相册图片浏览器，并选择图片
    ///
    /// - Parameters:
    ///   - startType:    The `StartTransformType` value.                (系统相册跳转动画类型)
    ///   - countType:    The `ElectPhotoCountType`, `once` by default.  (选取数量类型)
    ///   - theme:        The `ElectPhotoTheme`, `whiteLight` by default.(UI主题风格)
    ///   - delegate:     The `ElectPhotoDelegate`, custom navbar item.
    ///   - photoTask:    The `WisdomPhotoTask`, back images array.      (完成回调)
    ///   - errorTask:    The `WisdomErrorTask`, next?.                  (失败回调)
    ///
    /// - Returns: The created `WisdomPhotoSelectVC`.
    @discardableResult
    @objc public func startElectSystemPhoto(startType: StartTransformType = .present,
                                            countType: ElectPhotoCountType = .nine,
                                            theme:     ElectPhotoTheme = .darkDim,
                                            delegate:  ElectPhotoDelegate? = nil,
                                            photoTask: @escaping WisdomPhotoTask,
                                            errorTask: @escaping WisdomErrorTask) -> WisdomPhotoSelectVC {
        return WisdomPhotoSelectVC()
    }

    3:入参：
       
       
    4:属性：
       
