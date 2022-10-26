//
//  WisdomRQCodeVC.swift
//  WisdomScanKit
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation
//import WisdomHUD

public class WisdomRQCodeVC: UIViewController {
    
    fileprivate let answerTask: WisdomRQCodeFinishTask!
    
    fileprivate let errorTask: WisdomRQCodeErrorTask!
    
    fileprivate let startType: StartTransformType!
    
    /** 主题风格 */
    fileprivate let themeType: WisdomRQCodeThemeType!
    
    fileprivate var scanSession: AVCaptureSession?
    
    fileprivate let scanAnimationDuration = 2.5
    
    fileprivate let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                          AVMetadataObject.ObjectType.pdf417,
                                          AVMetadataObject.ObjectType.code39,
                                          AVMetadataObject.ObjectType.code39Mod43,
                                          AVMetadataObject.ObjectType.code93,
                                          AVMetadataObject.ObjectType.code128,
                                          AVMetadataObject.ObjectType.ean8,
                                          AVMetadataObject.ObjectType.ean13,
                                          AVMetadataObject.ObjectType.aztec,
                                          AVMetadataObject.ObjectType.qr]
    
    fileprivate(set) var navbarDelegate: ScanRQCodeDelegate?
    
    fileprivate var navbarBackBtn: UIButton?
    
    fileprivate var headerTitle: String="WisdomScanKit"
    
    fileprivate var rightBtn: UIButton?
    
    fileprivate var lightOn = false
    
    var isCreatNav: Bool=false
    
    fileprivate var isStartScan: Bool = false{
        didSet{
            if isStartScan {
                scanLine.layer.add(scanAnimation(), forKey: "scan")
                guard let scanSession = scanSession else{
                    return
                }
                if !scanSession.isRunning{
                    scanSession.startRunning()
                }
            }else{
                scanSession!.stopRunning()
                scanLine.layer.removeAllAnimations()
            }
        }
    }
    
    fileprivate lazy var titleLab: UILabel = {
        let label: UILabel = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = "请对准二维/条形码，即可自动扫描"
        return label
    }()
    
    fileprivate lazy var backBtn: UIButton = {
        let btn = UIButton()
        let image = WisdomScanManager.bundleImage(name: "white_backIcon")
        btn.setImage(image, for: .normal)
        
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        //btn.backgroundColor = UIColor(white: 1, alpha: 0.15)
        //btn.layer.cornerRadius = 17
        //btn.layer.masksToBounds = true
        return btn
    }()
    
    fileprivate lazy var scanPane: UIImageView = {
        let image = WisdomScanManager.bundleImage(name: "QRCode_ScanBox")
        let scan = UIImageView(image: image)
        return scan
    }()
    
    fileprivate lazy var scanLine: UIImageView = {
        let image = WisdomScanManager.bundleImage(name: "QRCode_ScanLine")
        let scanLine = UIImageView(image: image)
        return scanLine
    }()
    
    fileprivate lazy var lightBtn: UIButton = {
        let btn = UIButton()
        var image = WisdomScanManager.bundleImage(name: "light_scan_on")
        btn.setBackgroundImage(image, for: .selected)
        image = WisdomScanManager.bundleImage(name: "light_scan_off")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(light(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override public func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if navbarDelegate == nil {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        isStartScan = true
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navbarDelegate == nil {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    init(startTypes: StartTransformType,
         themeTypes: WisdomRQCodeThemeType,
         navDelegate: ScanRQCodeDelegate?,
         answerTasks: @escaping WisdomRQCodeFinishTask,
         errorTasks: @escaping WisdomRQCodeErrorTask) {
        startType = startTypes
        themeType = themeTypes
        navbarDelegate = navDelegate
        answerTask = answerTasks
        errorTask = errorTasks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNavbarUI()
        setupScanSession()
        
        if scanPaneShowCover{
            showCover()
        }
    }
    
    private func setupUI() {
        title = headerTitle
        view.backgroundColor = UIColor.black
        view.addSubview(backBtn)
        view.addSubview(scanPane)
        scanPane.addSubview(scanLine)
        view.addSubview(lightBtn)
        view.addSubview(titleLab)
        
        backBtn.frame = CGRect(x: 15, y: 30, width: 35, height: 35)
        
        scanPane.frame = CGRect(x: 0, y: 0, width: scanPaneWidth, height: scanPaneWidth)
        scanPane.center = view.center
        
        if themeType == .snowy {
            scanLine.frame = CGRect(x: 25, y: 60, width: scanPane.bounds.width - 50, height: 0.8)
        }else{
            scanLine.frame = CGRect(x: 5, y: 60, width: scanPane.bounds.width - 10, height: 3)
        }
        
        lightBtn.frame = CGRect(x: 0, y: 0, width: 52, height: 22)
        lightBtn.center = view.center
        var frame = lightBtn.frame
        frame.origin.y = scanPane.frame.maxY + 30
        lightBtn.frame = frame
        
        titleLab.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
        titleLab.center = view.center
        frame = titleLab.frame
        frame.origin.y = scanPane.frame.minY - 60
        titleLab.frame = frame
        
        if themeType == .snowy {
            scanPane.image = nil
            scanLine.image = nil
            
            scanPane.layer.borderWidth = 1
            scanPane.layer.borderColor = UIColor(red: 212, green: 224, blue: 244, alpha: 1).cgColor
            
            titleLab.textColor = UIColor(red: 212, green: 224, blue: 244, alpha: 1)
            scanLine.backgroundColor = UIColor(red: 212, green: 224, blue: 244, alpha: 1)
        }else if themeType == .green{
            
        }
    }
    
    fileprivate func setNavbarUI(){
        if navbarDelegate != nil {
            navbarBackBtn = navbarDelegate?.scanRQCodeNavbarBackItme(navigationVC: navigationController!)
            rightBtn = navbarDelegate?.scanRQCodeNavbarRightItme(navigationVC: navigationController!)
            let customView = navbarDelegate?.scanRQCodeNavbarCustomTitleItme(navigationVC: navigationController!)
            
            navigationItem.titleView = customView
            
            navbarBackBtn!.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        }
        
        if navbarBackBtn != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navbarBackBtn!)
        }
        
        if rightBtn != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn!)
        }
    }
    
    
    @objc fileprivate func clickBackBtn(){
        if startType == .push {
            if navigationController != nil && isCreatNav {
                UIView.animate(withDuration: 0.35, animations: {
                    self.navigationController!.view.transform = CGAffineTransform(translationX: self.navigationController!.view.bounds.width, y: 0)
                }) { (_) in
                    self.navigationController!.view.removeFromSuperview()
                    self.navigationController!.removeFromParent()
                }
            }else if navigationController != nil && !isCreatNav {
                navigationController!.popViewController(animated: true)
            }else{
                UIView.animate(withDuration: 0.35, animations: {
                    self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                }) { (_) in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }else if startType == .present {
            if navigationController != nil {
                navigationController!.dismiss(animated: true, completion: nil)
            }else{
                dismiss(animated: true, completion: nil)
            }
        }else if startType == .alpha {
            if navigationController != nil {
                UIView.animate(withDuration: 0.35, animations: {
                    self.navigationController!.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }) { (_) in
                    self.navigationController!.view.removeFromSuperview()
                    self.navigationController!.removeFromParent()
                }
            }else{
                UIView.animate(withDuration: 0.35, animations: {
                    self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }) { (_) in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }
    }
    
    
    fileprivate func setupScanSession(){
//        let authStatus = WisdomScanKit.authorizationStatus()
//        switch authStatus {
//        case .authorized:
//            open()
//        case .denied:
//            upgrades()
//        case .notDetermined:
//            open()
//        case .restricted:
//            upgrades()
//        default:
//            break
//        }
    }
    
    fileprivate func showCover(){
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: scanPane.frame.minY))
        let bottomView = UIView(frame: CGRect(x: 0, y: scanPane.frame.maxY, width: view.bounds.width, height: view.frame.maxY - scanPane.frame.maxY))
        let leftView = UIView(frame: CGRect(x: 0, y: scanPane.frame.minY, width: scanPane.frame.minX, height: scanPane.bounds.height))
        let rightView = UIView(frame: CGRect(x: scanPane.frame.maxX, y: scanPane.frame.minY, width: view.bounds.width - scanPane.frame.maxX, height: scanPane.bounds.height))
        
        view.insertSubview(topView, belowSubview: backBtn)
        view.insertSubview(bottomView, belowSubview: backBtn)
        view.insertSubview(leftView, belowSubview: backBtn)
        view.insertSubview(rightView, belowSubview: backBtn)
 
        topView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        leftView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        rightView.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }
    
    fileprivate func open() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
//            WisdomHUD.showText(text: "无可用设备")
            return
        }
        
        do {
            let input =  try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            scanSession = AVCaptureSession()

            if scanSession!.canAddInput(input){
                scanSession!.addInput(input)
            }
            
            if scanSession!.canAddOutput(output){
                scanSession!.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = supportedCodeTypes
                
                /// 扫描区域
                if rectOfInterestSize.width < scanPaneWidth {
                    rectOfInterestSize = CGSize(width: scanPaneWidth,height: rectOfInterestSize.height)
                }
                
                if rectOfInterestSize.height < scanPaneWidth {
                    rectOfInterestSize = CGSize(width: rectOfInterestSize.width,height: scanPaneWidth)
                }
                
                var offsetX = scanPane.frame.origin.y
                var offsetY = scanPane.frame.origin.x
                if rectOfInterestSize.width > scanPaneWidth{
                    offsetY = offsetY - (rectOfInterestSize.width - scanPaneWidth)/2
                }
                
                if rectOfInterestSize.height > scanPaneWidth{
                    offsetX = offsetX - (rectOfInterestSize.height - scanPaneWidth)/2
                }
                
                let rect = CGRect(x: offsetX/UIScreen.main.bounds.height,
                                  y: offsetY/UIScreen.main.bounds.width,
                              width: rectOfInterestSize.height/UIScreen.main.bounds.height,
                             height: rectOfInterestSize.width/UIScreen.main.bounds.width)
                output.rectOfInterest = rect
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: scanSession!)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.layer.bounds
            view.layer.insertSublayer(previewLayer, at: 0)
            //持续对焦
            if device.isFocusModeSupported(.continuousAutoFocus){
                try  input.device.lockForConfiguration()
                input.device.focusMode = .continuousAutoFocus
                input.device.unlockForConfiguration()
            }
        } catch  {
//            WisdomHUD.showText(text: "无可用设备")
        }
    }
    
    fileprivate func upgrades(){
        
        showAlert(title: "摄像使用权限已关闭", message: "App需要您同意，才能使用相机扫码功能", cancelActionTitle: "取消", rightActionTitle: "立即开启") { (action) in
            
            if let title = action.title {
                if title == "立即开启"{
//                    WisdomScanKit.authorizationScan()
                }
            }
            //self?.clickBackBtn()
        }
    }
    
    @objc fileprivate func light(sender: UIButton){
        lightOn = !lightOn
        sender.isSelected = lightOn
        WisdomScanManager.turnTorchOn(light: lightOn)
    }
    
    fileprivate func scanAnimation() -> CABasicAnimation{
        let startPoint = CGPoint(x: scanPaneWidth/2 , y: 10)
        let endPoint = CGPoint(x: scanPaneWidth/2, y: scanPaneWidth-20)
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        return translation
    }
    
    deinit{
        print("扫码控制器释放")
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WisdomRQCodeVC : AVCaptureMetadataOutputObjectsDelegate{
    
    class fileprivate func playAlertSound(sound:String){
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
        isStartScan = false
        
        if metadataObjects.count > 0{
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                let strvalue = resultObj.stringValue
                if strvalue != nil {
                    let type = answerTask(strvalue!)
                    returnRQCodeFinish(returnType: type, str: strvalue!)
                }else{
                    let type = errorTask()
                    returnRQCodeFinish(returnType: type, str: "")
                }
            }
        }else{
            let type = errorTask()
            returnRQCodeFinish(returnType: type, str: "")
        }
    }
    
    
    fileprivate func returnRQCodeFinish(returnType: WisdomScanReturnType, str: String){
        
        switch returnType {
        case .closeScan:
            clickBackBtn()
        case .pauseScan:
            break;
        case .continueScan:
            isStartScan = true
        case .hudFailScan:
            if str.count > 0{
//                WisdomHUD.showText(text: str, delay: 2.5).setDelayHander {[weak self] (timeInterval, type) in
//                    self?.isStartScan = true
//                }
            }else {
//                WisdomHUD.showError(text: "识别失败").setDelayHander {[weak self] (timeInterval, type) in
//                    self?.isStartScan = true
//                }
            }
        default:
            break
        }
    }
}


