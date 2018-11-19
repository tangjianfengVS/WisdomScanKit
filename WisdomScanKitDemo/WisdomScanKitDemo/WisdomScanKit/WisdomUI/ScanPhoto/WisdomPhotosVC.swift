//
//  WisdomScanKit.swift
//  WisdomScanKit
//
//  Created by 汤建锋 on 2018/1/26.
//  Copyright © 2018年 ZHInvest. All rights reserved.
//

import UIKit
import AVFoundation

class WisdomPhotosVC: UIViewController {
    private let animationViewSize = CGSize(width: 65, height: UIScreen.main.bounds.height*65/UIScreen.main.bounds.width)
    
    private var maxCount: Int = 9 {
        didSet{
            if maxCount == 9 {
                editView.isHidden = true
            }else{
                editView.isHidden = false
            }
        }
    }
    
    private lazy var editView: WisdomPhotoEditView = {
        let view = WisdomPhotoEditView.initWithNib(callBacks: {[weak self] (actionType) in
            if actionType == .cancel{
                self!.nineCancelAction()
            }else if actionType == .edit{
                self!.showEidtView()
            }else if actionType == .real{
                self!.saveAction()
            }
        })
        
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        view.center = CGPoint(x: self.view.center.x, y: self.cameraBtn.center.y - 95)
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    
    private lazy var center: CGPoint = {
        return CGPoint(x: animationViewSize.width/2 + 15,
                       y: self.view.frame.maxY - animationViewSize.height/2 - 15)
    }()
    
    private lazy var animationBgBtn: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero, size: animationViewSize))
        btn.center = center
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.white.cgColor
        btn.isHidden = true
        btn.layer.shadowOpacity = 0.9
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.addTarget(self, action: #selector(showEidtView), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel(frame: CGRect(x: 0, y: -25, width: 30, height: 20))
        lab.layer.cornerRadius = 10
        lab.layer.masksToBounds = true
        lab.layer.borderWidth = 0.7
        lab.layer.borderColor = UIColor.white.cgColor
        lab.textAlignment = .center
        lab.textColor = UIColor.white
        lab.text = "0"
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        return lab
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0,y: cameraBtn.frame.minY - bottomSizeHight,
                                    width: self.view.bounds.width,
                                   height: cameraBtn.bounds.height + bottomSizeHight * 2))
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.layoutIfNeeded()
        return view
    }()

    private lazy var photoBtn: UIButton = {
        let btn = UIButton()
        let image = WisdomScanKit.bundleImage(name: "ic_waterprint_revolve")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        return btn
    }()

    private lazy var photoLightBtn: UIButton = {
        let btn = UIButton()
        var image = WisdomScanKit.bundleImage(name: "qrcode_light_normal")
        btn.setBackgroundImage(image, for: .normal)
        image = WisdomScanKit.bundleImage(name: "qrcode_light_pressed")
        btn.setBackgroundImage(image, for: .selected)
        btn.addTarget(self, action: #selector(clickPhotoLightBtn), for: .touchUpInside)
        return btn
    }()

    private lazy var cameraBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: kScreenHeight - bottomSizeHight - 72,
                                     width: 72, height: 72))
        btn.center.x = self.view.center.x
        btn.setTitleColor(UIColor.white, for: .normal)
        var image = WisdomScanKit.bundleImage(name: "share_coupon_btn_bg_normal")
        btn.setBackgroundImage(image, for: .normal)
        image = WisdomScanKit.bundleImage(name: "share_coupon_btn_bg")
        btn.setBackgroundImage(image, for: .disabled)
        btn.setTitle("上限9张", for: .disabled)
        btn.setTitleColor(UIColor.lightText, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.black, for: .disabled)
        btn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancel: UIButton = {
        let btn = UIButton(frame: CGRect(x: (self.bgView.bounds.width - 55)/2,
                                         y: (self.bgView.bounds.height - 55)/2,
                                         width: 60, height: 60))
        let image = WisdomScanKit.bundleImage(name: "scan_icon_cancel")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(onceCancelAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var save: UIButton = {
        let btn = UIButton(frame: CGRect(x: (self.bgView.bounds.width - 55)/2,
                                         y: (self.bgView.bounds.height - 55)/2,
                                         width: 52, height: 52))
        let image = WisdomScanKit.bundleImage(name: "list_icon_choose")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 15, y: 30, width: 34, height: 34))
        
        if type == .push{
            let image = WisdomScanKit.bundleImage(name: "black_backIcon")
            btn.setImage(image, for: .normal)
        }else if type == .present{
            let image = WisdomScanKit.bundleImage(name: "black_backIcon")
            btn.setImage(image, for: .normal)
        }
        
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        btn.layer.cornerRadius = 17
        btn.layer.masksToBounds = true
        return btn
    }()

    /** 音视频采集会话 */
    private lazy var captureSession: AVCaptureSession={
        let session = AVCaptureSession()
        session.beginConfiguration()
        return session
    }()
    
    private var backFacingCamera: AVCaptureDevice?
    
    private var frontFacingCamera: AVCaptureDevice?
    /** 当前正在使用的设备 */
    private var currentDevice: AVCaptureDevice?
    /** 静止图像输出端 */
    private var stillImageOutput: AVCaptureStillImageOutput?
    /** 相机预览图层 */
    private var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    private var type: WisdomScanningType = .push
    
    private var photosType: WisdomPhotosType = .once
    
    private let photosTask: WisdomPhotosTask!
    
    private let errorTask: WisdomErrorTask!
    
    private let kScreenHeight = UIScreen.main.bounds.height
    
    public var bottomSizeHight: CGFloat = 38
    
    private var currentImageList: [UIImage] = []
    
    init(types: WisdomScanningType,
         photosTypes: WisdomPhotosType?,
         photosTasks: @escaping WisdomPhotosTask,
         errorTasks: @escaping WisdomErrorTask) {
        photosTask = photosTasks
        errorTask = errorTasks
        type = types
        if photosTypes != nil{
            photosType = photosTypes!
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if navigationController != nil {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController != nil {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScanSession()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black
        view.addSubview(backBtn)
    }
    
    private func setupScanSession(){
        let authStatus = WisdomScanKit.authorizationStatus()
        switch authStatus {
        case .authorized:
            createSession()
        case .denied:
            upgrades()
        case .notDetermined:
            createSession()
        case .restricted:
            print("")
        }
    }
    
    private func createSession(){
        DispatchQueue.global().async {
            self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            let devices = AVCaptureDevice.devices(for: AVMediaType.video)
            if devices.count == 0{
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
            }
        }
    }
    
    private func createPhotoBtn(){
        view.addSubview(cameraBtn)
        view.addSubview(photoBtn)
        view.addSubview(photoLightBtn)
        
        photoBtn.frame = CGRect(x: view.bounds.width - 40, y: 60, width: 26, height: 22)
        photoLightBtn.frame = CGRect(x: view.bounds.width - 40, y: 100, width: 26, height: 26)
        
        switch photosType {
        case .once:
            view.addSubview(bgView)
            bgView.addSubview(save)
            bgView.addSubview(cancel)
        case .nine:
            view.addSubview(animationBgBtn)
            view.addSubview(editView)
            animationBgBtn.addSubview(titleLab)
        }
    }
    
    @objc private func photoAction(){
        let videoConnection = stillImageOutput?.connection(with: AVMediaType.video)
        /** 输出端以异步方式采集静态图像 */
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            /** 获得采样缓冲区中的数据 */
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
            if let stillImage = UIImage(data: imageData!) {
                self.currentImageList.append(stillImage)
                
                if self.photosType == .once{
                    self.stopRunning()
                }else if self.photosType == .nine {
                    self.photoAnimation(image: stillImage)
                }
            }
        })
    }
    
    private func stopRunning(){
        captureSession.stopRunning()
        bgView.isHidden = false
        cameraBtn.isHidden = true
        
        UIView.animate(withDuration: 0.25) {
            self.cancel.transform = CGAffineTransform.init(translationX: -50, y: 0)
            self.save.transform = CGAffineTransform.init(translationX: 50, y: 0)
        }
    }
    
    private func photoAnimation(image: UIImage){
        maxCount -= 1
        let num = Int(titleLab.text!)
        titleLab.text = String(num! + 1)
        
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        view.insertSubview(imageView, belowSubview: backBtn)
        
        if maxCount <= 0{
            cameraBtn.isEnabled = false
            captureSession.stopRunning()
        }
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
    
    @objc private func onceCancelAction(){
        maxCount = 9
        cameraBtn.isHidden = false
        bgView.isHidden = true
        captureSession.startRunning()
        
        UIView.animate(withDuration: 0.25) {
            self.cancel.transform = CGAffineTransform.identity
            self.save.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func nineCancelAction(){
        maxCount = 9
        cameraBtn.isEnabled = true
        animationBgBtn.isHidden = true
        titleLab.text = "0"
        currentImageList.removeAll()
        captureSession.startRunning()
    }
    
    @objc private func saveAction(){
        photosTask!(currentImageList)
        clickBackBtn()
    }
    
    @objc private func clickPhotoLightBtn(btn: UIButton){
        btn.isSelected = !btn.isSelected
        WisdomScanKit.turnTorchOn(light: btn.isSelected)
    }
    
    @objc private func clickBackBtn(){
        if type == .push {
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
        }else if type == .present{
            if navigationController != nil {
                navigationController!.dismiss(animated: true, completion: nil)
            }else{
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func upgrades(){
        showAlert(title: "开启照相机提示", message: "App需要您同意，才能访问相机扫码和摄像", cancelActionTitle: "取消", rightActionTitle: "去开启") { (action) in
            WisdomScanKit.authorizationScan()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("摄像头释放")
    }
}

extension WisdomPhotosVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /** 切换摄像头 */
    @objc fileprivate func toggleCamera() {
        let res : Bool = (currentDevice?.torchMode == .on) ? true : false
        if res && currentDevice == backFacingCamera{
            photoLightBtn.isSelected = false
            WisdomScanKit.turnTorchOn(light: false)
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
    @objc func showEidtView(){
        captureSession.stopRunning()
        WisdomPhotoEditVC.showEdit(rootVC: self,
                                   imageList: currentImageList,
                                   beginCenter: center,
                                   beginSize: animationViewSize, endTask: {[weak self](res, list) in
           if res{
                self?.currentImageList = list
                if (self?.currentImageList.count)! > 0{
                    self?.maxCount = 9 - (self?.currentImageList.count)!
                    let numbStr = String((self?.currentImageList.count)!)
                    self?.titleLab.text = numbStr
                    self?.animationBgBtn.setBackgroundImage(self?.currentImageList.last, for: .normal)
                }else{
                    self?.nineCancelAction()
                }
           }
           self?.cameraBtn.isEnabled = (self?.currentImageList.count)! == 9 ? false:true
           if (self?.currentImageList.count)! < 9 {
               self?.captureSession.startRunning()
           }
        })
    }
}
