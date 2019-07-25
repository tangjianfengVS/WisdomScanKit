//
//  WisdomScanKit.swift
//  WisdomScanKit
//
//  Created by 汤建锋 on 2018/1/26.
//  Copyright © 2018年 ZHInvest. All rights reserved.
//

import UIKit
import AVFoundation
import WisdomHUD

public class WisdomPhotosVC: UIViewController {
    /** 上限 */
    fileprivate let maxCount: Int!
    
    fileprivate lazy var currentCount: Int =  {
        return maxCount
    }()
    
    
    fileprivate let animationViewSize = CGSize(width: 65, height: UIScreen.main.bounds.height*65/UIScreen.main.bounds.width)
    
    
    /** 删选编辑 */
    fileprivate lazy var editView: WisdomPhotoEditView = {
        let frame = CGRect(x: self.view.center.x - 100,
                           y: self.cameraBtn.center.y - 95 - 15, width: 200, height: 28)
        let view = WisdomPhotoEditView(frame: frame, callBacks: {[weak self] (actionType) in
            if actionType == .cancel{
                self!.nineCancelAction()
            }else if actionType == .edit{
                self!.showEidtView()
            }else if actionType == .real{
                self!.saveAction()
            }
        })
        
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    
    
    fileprivate lazy var center: CGPoint = {
        return CGPoint(x: animationViewSize.width/2 + 15,
                       y: self.view.frame.maxY - animationViewSize.height/2 - 15)
    }()
    
    
    fileprivate lazy var animationBgBtn: WisdomAnimationBgBtn = {
        let btn = WisdomAnimationBgBtn(frame: CGRect(origin: .zero, size: animationViewSize))
        btn.center = center
        btn.addTarget(self, action: #selector(showEidtView), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate lazy var titleLab: UILabel = {
        let lab = UILabel(frame: CGRect(x: 0, y: -23, width: 28, height: 18))
        lab.layer.cornerRadius = 9
        lab.layer.masksToBounds = true
        lab.layer.borderWidth = 0.6
        lab.layer.borderColor = UIColor.white.cgColor
        lab.textAlignment = .center
        lab.textColor = UIColor.white
        lab.text = "0"
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        return lab
    }()
    
    
    /** 单张编辑 */
    fileprivate lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0,y: cameraBtn.frame.minY - bottomSizeHight,
                                    width: self.view.bounds.width,
                                   height: cameraBtn.bounds.height + bottomSizeHight * 2))
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.layoutIfNeeded()
        return view
    }()
    

    fileprivate lazy var photoBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: view.bounds.width - 60, y: view.bounds.height - 100, width: 35, height: 30))
        btn.center.y = cameraBtn.center.y
        let image = WisdomScanManager.bundleImage(name: "ic_waterprint_revolve")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        return btn
    }()
    

    fileprivate lazy var photoLightBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        btn.center = CGPoint(x: photoBtn.center.x, y: backBtn.center.y)
        var image = WisdomScanManager.bundleImage(name: "qrcode_light_normal")
        btn.setImage(image, for: .normal)
        image = WisdomScanManager.bundleImage(name: "qrcode_light_pressed")
        btn.setImage(image, for: .selected)
        btn.addTarget(self, action: #selector(clickPhotoLightBtn), for: .touchUpInside)
        return btn
    }()
    

    fileprivate lazy var cameraBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: kScreenHeight - bottomSizeHight - 74,
                                     width: 74, height: 74))
        btn.center.x = self.view.center.x
        btn.setTitleColor(UIColor.white, for: .normal)
        var image = WisdomScanManager.bundleImage(name: "share_coupon_btn_bg_normal")
        btn.setBackgroundImage(image, for: .normal)
        image = WisdomScanManager.bundleImage(name: "share_coupon_btn_bg")
        btn.setBackgroundImage(image, for: .disabled)
        btn.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate lazy var cancel: UIButton = {
        let btn = UIButton(frame: CGRect(x: (self.bgView.bounds.width - 55)/2,
                                         y: (self.bgView.bounds.height - 55)/2,
                                         width: 60, height: 60))
        let image = WisdomScanManager.bundleImage(name: "scan_icon_cancel")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(onceCancelAction), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate lazy var save: UIButton = {
        let btn = UIButton(frame: CGRect(x: (self.bgView.bounds.width - 55)/2,
                                         y: (self.bgView.bounds.height - 55)/2,
                                         width: 52, height: 52))
        let image = WisdomScanManager.bundleImage(name: "list_icon_choose")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 15, y: 30, width: 34, height: 34))
        
        let image = WisdomScanManager.bundleImage(name: "white_backIcon")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        //btn.backgroundColor = UIColor(white: 1, alpha: 0.1)
        //btn.layer.cornerRadius = 17
        //btn.layer.masksToBounds = true
        return btn
    }()
    

    /** 音视频采集会话 */
    fileprivate lazy var captureSession: AVCaptureSession={
        let session = AVCaptureSession()
        session.beginConfiguration()
        return session
    }()
    
    
    fileprivate var backFacingCamera: AVCaptureDevice?
    
    fileprivate var frontFacingCamera: AVCaptureDevice?
    
    /** 当前正在使用的设备 */
    fileprivate var currentDevice: AVCaptureDevice?
    
    /** 静止图像输出端 */
    fileprivate var stillImageOutput: AVCaptureStillImageOutput?
    
    /** 相机预览图层 */
    fileprivate var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    fileprivate let startType: StartTransformType!
    
    fileprivate let countType: ElectPhotoCountType!
    
    fileprivate let electTheme: ElectPhotoTheme
    
    fileprivate let photoTask: WisdomPhotoTask!
    
    fileprivate let errorTask: WisdomErrorTask!
    
    fileprivate let kScreenHeight = UIScreen.main.bounds.height
    
    fileprivate var bottomSizeHight: CGFloat = 38
    
    fileprivate var currentImageList: [UIImage] = []
    
    
    init(startTypes: StartTransformType,
         countTypes: ElectPhotoCountType,
         electTheme: ElectPhotoTheme,
         photoTasks: @escaping WisdomPhotoTask,
         errorTasks: @escaping WisdomErrorTask) {
        photoTask = photoTasks
        errorTask = errorTasks
        startType = startTypes
        countType = countTypes
        self.electTheme = electTheme
        
        switch countType! {
        case .once:
            maxCount = 1
        case .four:
            maxCount = 4
        case .nine:
            maxCount = 9
        default:
            maxCount = 1
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if navigationController != nil {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController != nil {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        view.addSubview(backBtn)
        
        setupScanSession()
    }
    

    /** 权限 */
    fileprivate func setupScanSession(){
        let authStatus = WisdomScanKit.authorizationStatus()
        switch authStatus {
        case .authorized:
            createSession()
            
        case .denied:
            if errorTask(WisdomScanErrorType.denied){
                upgrades()
            }
        case .notDetermined:
            createSession()
            
        case .restricted:
            if errorTask(WisdomScanErrorType.restricted){
                upgrades()
            }
        }
    }
    
    
    fileprivate func createSession(){
        WisdomHUD.showLoading(text: nil, enable: true)
        
        DispatchQueue.global().async {
            self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            let devices = AVCaptureDevice.devices(for: AVMediaType.video)
            if devices.count == 0{
                
                WisdomHUD.showInfo(text: "无可用设备")
                return;
            }
            
            for device in devices {
                if device.position == AVCaptureDevice.Position.back {
                    self.backFacingCamera = device
                    self.currentDevice = self.backFacingCamera
                }else if device.position == AVCaptureDevice.Position.front {
                    self.frontFacingCamera = device
                }
            }
            
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: self.currentDevice!)
                self.stillImageOutput = AVCaptureStillImageOutput()
                /** 输出图像格式设置 */
                self.stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                self.captureSession.addInput(captureDeviceInput)
                self.captureSession.addOutput(self.stillImageOutput!)
            }catch {
                WisdomHUD.showInfo(text: "无可用设备")
                return
            }
            
            /** 创建预览图层 */
            self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            DispatchQueue.main.async {
                self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
                self.cameraPreviewLayer?.frame = self.view.layer.frame
                
                /** 启动音视频采集的会话 */
                self.captureSession.commitConfiguration()
                self.captureSession.startRunning()
                self.createPhotoBtn()
                
                WisdomHUD.dismiss(delay: TimeInterval(0.2))
            }
        }
    }
    
    
    fileprivate func createPhotoBtn(){
        view.addSubview(cameraBtn)
        view.addSubview(photoBtn)
        view.addSubview(photoLightBtn)
        
        switch countType! {
        case .once:
            view.addSubview(bgView)
            bgView.addSubview(save)
            bgView.addSubview(cancel)
        case .four, .nine:
            view.addSubview(animationBgBtn)
            view.addSubview(editView)
            animationBgBtn.addSubview(titleLab)
        default: break
        }
    }
    
    
    @objc fileprivate func photoAction(){
        if currentCount <= 0 {
            WisdomHUD.showText(text: "拍摄张数已上限")
            return
        }
        
        let videoConnection = stillImageOutput?.connection(with: AVMediaType.video)
        
        /** 输出端以异步方式采集静态图像 */
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            /** 获得采样缓冲区中的数据 */
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
            if let stillImage = UIImage(data: imageData!) {
                self.currentImageList.append(stillImage)
                
                if self.countType == .once{
                    self.stopRunning()
                } else {
                    self.photoAnimation(image: stillImage)
                }
            }
        })
    }
    
    
    fileprivate func stopRunning(){
        captureSession.stopRunning()
        bgView.isHidden = false
        cameraBtn.isHidden = true
        
        UIView.animate(withDuration: 0.25) {
            self.cancel.transform = CGAffineTransform.init(translationX: -50, y: 0)
            self.save.transform = CGAffineTransform.init(translationX: 50, y: 0)
        }
    }
    
    
    fileprivate func photoAnimation(image: UIImage){
        editView.isHidden = false
        
        currentCount -= 1
        let num = Int(titleLab.text!)
        titleLab.text = String(num! + 1)
        
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        view.insertSubview(imageView, belowSubview: backBtn)
        //let groupAnimation = CAAnimationGroup()
        //groupAnimation.duration = 0.3
        //groupAnimation.isRemovedOnCompletion = false
        //groupAnimation.fillMode = CAMediaTimingFillMode.forwards

        //let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        //scaleDown.fromValue = 1.0
        //scaleDown.toValue = 0.2

        //let position = CABasicAnimation(keyPath: "position")
        //position.fromValue = NSValue(cgPoint: imageView.layer.position)
        //position.toValue = NSValue(cgPoint: center)

        //groupAnimation.animations = [scaleDown, position]
        //groupAnimation.delegate = self
        //imageView.layer.add(groupAnimation, forKey: "WisdomPhotoAnimation")
        
        let scbl = animationViewSize.width/view.bounds.width
        let ydblW = view.center.x-center.x
        let ydblY = center.y-view.center.y
        
        UIView.animate(withDuration: 0.5, animations: {
            imageView.transform = CGAffineTransform(translationX: -ydblW, y: ydblY)
            imageView.transform = imageView.transform.scaledBy(x: scbl, y: scbl)
        }) { (_) in
            imageView.removeFromSuperview()
            self.animationBgBtn.isHidden = false
            self.animationBgBtn.setBackgroundImage(self.currentImageList.last, for: .normal)
        }
    }
    
    
    @objc fileprivate func onceCancelAction(){
        currentCount = maxCount
        cameraBtn.isHidden = false
        bgView.isHidden = true
        captureSession.startRunning()
        
        UIView.animate(withDuration: 0.25) {
            self.cancel.transform = CGAffineTransform.identity
            self.save.transform = CGAffineTransform.identity
        }
    }
    
    
    @objc fileprivate func nineCancelAction(){
        currentCount = maxCount
        editView.isHidden = true
        cameraBtn.isEnabled = true
        animationBgBtn.isHidden = true
        titleLab.text = "0"
        currentImageList.removeAll()
        captureSession.startRunning()
    }
    
    
    @objc fileprivate func saveAction(){
        photoTask!(currentImageList)
        clickBackBtn()
    }
    
    
    @objc fileprivate func clickPhotoLightBtn(btn: UIButton){
        btn.isSelected = !btn.isSelected
        WisdomScanManager.turnTorchOn(light: btn.isSelected)
    }
    
    
    @objc fileprivate func clickBackBtn(){
        if startType == .push {
            if navigationController != nil  {
                navigationController!.popViewController(animated: true)
            }else{
                UIView.animate(withDuration: 0.35, animations: {
                    self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                }) { (_) in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }else if startType == .present{
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
    
    fileprivate func upgrades(){
        showAlert(title: "开启照相机提示", message: "App需要您同意，才能访问相机扫码和摄像", cancelActionTitle: "取消", rightActionTitle: "去开启") { (action) in
            WisdomScanKit.authorizationScan()
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("摄像头释放")
    }
}

extension WisdomPhotosVC {
    /** 切换摄像头 */
    @objc fileprivate func toggleCamera() {
        
        let res : Bool = (currentDevice?.torchMode == .on) ? true : false
        if res && currentDevice == backFacingCamera{
            photoLightBtn.isSelected = false
            WisdomScanManager.turnTorchOn(light: false)
        }
                
        captureSession.beginConfiguration()
        let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontFacingCamera : backFacingCamera
        
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        }catch {
            return
        }

        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    
    /** 打开图片选择编辑器 */
    @objc fileprivate func showEidtView(){
        
        captureSession.stopRunning()
        
        startPhotoEdit(imageList: currentImageList,
                       startIconAnimatRect: CGRect(x: center.x - animationViewSize.width/2,
                                                   y: center.y - animationViewSize.height/2,
                                                   width: animationViewSize.width,
                                                   height: animationViewSize.height),
                       colorTheme: electTheme,
                       finishTask: { [weak self] (res, list) in
           if res{
                self?.currentImageList = list

                if (self?.currentImageList.count)! > 0{

                    self?.currentCount = (self?.maxCount)! - (self?.currentImageList.count)!
                    let numbStr = String((self?.currentImageList.count)!)
                    self?.titleLab.text = numbStr
                    self?.animationBgBtn.setBackgroundImage(self?.currentImageList.last, for: .normal)

                }else{
                    self?.nineCancelAction()
                }
           }

           self?.cameraBtn.isEnabled = (self?.currentImageList.count)! == (self?.maxCount)! ? false:true
                        
           if (self?.currentImageList.count)! < (self?.maxCount)! {
               self?.captureSession.startRunning()
           }
        })
    }
}
