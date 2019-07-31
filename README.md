# WisdomsScanKit

   一：简介
   
    推荐一个强大，好用的摄像，扫描器框架： WisdomScanKit 。
    WisdomScanKit 最低支持  iOS 8.0 / Swift 4 编写，SDK处理了系统兼容性问题，并且兼容OC项目调用。
    WisdomScanKit 目前支持四大功能： 一：系统相册图片选择器;   二：全屏摄像功能;   三：扫二维码功能;   四：图片浏览器功能;
        
  二：系统相册图片选择器 功能
  
    1:API：
      MARK: - startElectSystemPhoto (UIViewController extension method) 
      - 跳转加载系统相册图片浏览器，并选择图片
      
       - Parameters:
         - startType:    The `StartTransformType` value.                
         - countType:    The `ElectPhotoCountType`, `once` by default.  
         - theme:        The `ElectPhotoTheme`, `whiteLight` by default.
         - delegate:     The `ElectPhotoDelegate`, custom navbar item.
         - photoTask:    The `WisdomPhotoTask`, back images array.                     
      - Return:          The created `WisdomPhotoSelectVC`.
      @discardableResult
      @objc public func startElectSystemPhoto(startType: StartTransformType = .present,
                                              countType: ElectPhotoCountType = .nine,
                                              theme:     ElectPhotoTheme = .darkDim,
                                              delegate:  ElectPhotoDelegate? = nil,
                                              photoTask: @escaping WisdomPhotoTask ) -> WisdomPhotoSelectVC {
          return WisdomPhotoSelectVC()
      }

    2:入参：
       `StartTransformType`   支持转场动画样式:       【.push   .present   .alpha】
       `ElectPhotoCountType`  支持图片选择的数量：     【.once   .four      .nine】
       `ElectPhotoTheme`      支持UI的主题风格：       【.whiteLight    .darkDim】
       `ElectPhotoDelegate`   自定义导航栏代理：       【导航栏返回按钮，导航栏主题文字】
       `WisdomPhotoTask`      图片选择完成回调
       
   二：全屏摄像 功能
   
     1:API：
     - MARK: - startScanPhoto (UIViewController extension method) 

     - Parameters:
       - startType:    The `StartTransformType` value.                  
       - countType:    The `ElectPhotoCountType`, `once` by default.    
       - electTheme:   The `ElectPhotoTheme`, `whiteLight` by default.  
       - photosTask:   The `WisdomPhotoTask`, back photos array.        
     - Returns:        The created `WisdomPhotosVC`.
     @discardableResult
     @objc public func startScanPhoto(startType:  StartTransformType = .push,
                                      countType:  ElectPhotoCountType = .nine,
                                      electTheme: ElectPhotoTheme = .whiteLight,
                                      photosTask: @escaping WisdomPhotoTask) -> WisdomPhotosVC {
         return WisdomPhotosVC()
     }

    2:入参：
      `StartTransformType`   支持转场动画样式:      【.push   .present   .alpha】
      `ElectPhotoCountType`  支持图片选择的数量：    【.once   .four      .nine】
      `ElectPhotoTheme`      支持删选UI主题风格：    【.whiteLight     .darkDim】
      `WisdomPhotoTask`      图片选择完成回调

       
