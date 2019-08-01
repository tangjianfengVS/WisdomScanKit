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

  三：扫二维码功能
    
    1:API:
    - MARK: - startScanRQCode
    
    - Parameters:
       - startType:      The `StartTransformType` value.               
       - themeType:      The `WisdomRQCodeThemeType`, `green` by default.
       - delegate:       The `ScanRQCodeDelegate`, custom navbar item.
       - answerTask:     The `WisdomRQCodeFinishTask`, back code string.  
       - errorTask:      The `WisdomRQCodeErrorTask`,  Returns Bool Value, to next?.             
    - Returns:           The created `WisdomRQCodeVC`.
    @discardableResult
    @objc public func startScanRQCode(startType:  StartTransformType = .push,
                                      themeType:  WisdomRQCodeThemeType = .green,
                                      delegate:   ScanRQCodeDelegate? = nil,
                                      answerTask: @escaping WisdomRQCodeFinishTask,
                                      errorTask:  @escaping WisdomRQCodeErrorTask) -> WisdomRQCodeVC {
        return WisdomRQCodeVC()
    }

    2:入参：
      `StartTransformType`     支持转场动画样式:    【.push   .present   .alpha】
      `WisdomRQCodeThemeType`  支持扫描页面主题风格：【.green   .snowy】
      `ScanRQCodeDelegate`     自定义导航栏代理：   【导航栏返回按钮，导航栏主题文字，导航栏右边操作按钮】
      `WisdomRQCodeFinishTask` 扫描成功回调         value: String  return: [.closeScan .pauseScan  .continueScan .hudFailScan]
      `WisdomRQCodeErrorTask`  扫描失败回调         return: [.closeScan .pauseScan  .continueScan  .hudFailScan]
  
    3: 属性设置
      【1】：public var scanPaneShowCover: Bool = false
            说明： 全局非扫码区域是否显示覆盖效果,可赋值，
                  在调用 开启扫描页面 之前调用。
      
      【2】：public var rectOfInterestSize: CGSize = {
                let size = CGSize(width: scanPaneWidth,height: scanPaneWidth)
                return size
            }()

            说明：全局掩藏的扫描区域大小,可赋值
                 在调用 开启扫描页面 之前调用。
                 
                 默认掩藏的扫描区域大小是：  let scanPaneWidth: CGFloat = 240.0
                 

  四：酷炫图片浏览器
  
     1:API:
     - MARK: - WisdomPhotoChromeHUD
     - Parameters:
       - startIconIndex:         show begin image index frame array.  (当前展示图片在数组中的下标)
       - startIconAnimatRect:    show begin image animation the frame.(开始展示动画的屏幕Frame)
       - iconList:               show images.                         (图片集合)
       - didScrollTask:          The "WisdomDidScrollTask".           (滑动回调)
     - Returns:                  The created `WisdomPhotoChromeHUD`.
     @discardableResult
     @objc public class func startPhotoChrome(startIconIndex:      Int=0,
                                              startIconAnimatRect: CGRect,
                                              iconList:            [UIImage],
                                              didScrollTask:       WisdomDidScrollTask?) -> WisdomPhotoChromeHUD {
        return WisdomPhotoChromeHUD()
     }
     
     2:入参：
      `startIconIndex`         当前展示图片在数组中的下标
      `startIconAnimatRect`    开始展示动画的屏幕Frame
      `iconList`               图片集合
      `WisdomDidScrollTask`    滑动回调， ((Int) -> (CGRect))： 参数 int 是当前展示图片下标，返回 CGRect：结束动画Frame
 
    
       
