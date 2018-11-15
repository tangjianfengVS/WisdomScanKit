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
    
    private var maxCount: Int = 8 {
        didSet{
            if maxCount == 8 {
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
        btn.setBackgroundImage(UIImage.init(named: "ic_waterprint_revolve"), for: .normal)
        btn.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        return btn
    }()

    private lazy var photoLightBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: "qrcode_light_normal"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "qrcode_light_pressed"), for: .selected)
        btn.addTarget(self, action: #selector(clickPhotoLightBtn), for: .touchUpInside)
        return btn
    }()

    private lazy var cameraBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: kScreenHeight - bottomSizeHight - 72,
                                     width: 72, height: 72))
        btn.center.x = self.view.center.x
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setBackgroundImage(UIImage(named: "share_coupon_btn_bg_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "share_coupon_btn_bg"), for: .disabled)
        btn.setTitle("上限", for: .disabled)
        btn.setTitleColor(UIColor.black, for: .disabled)
        btn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancel: UIButton = {
        let btn = UIButton(frame: CGRect(x: (self.bgView.bounds.width - 55)/2,
                                         y: (self.bgView.bounds.height - 55)/2,
                                         width: 55, height: 55))
        btn.setBackgroundImage(UIImage(named: "scan_icon_cancel"), for: .normal)
        btn.addTarget(self, action: #selector(onceCancelAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var save: UIButton = {
        let btn = UIButton(frame: CGRect(x: (self.bgView.bounds.width - 55)/2,
                                         y: (self.bgView.bounds.height - 55)/2,
                                         width: 55, height: 55))
        btn.setBackgroundImage(UIImage(named: "list_icon_choose"), for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 16, y: 30, width: 34, height: 34))
        
        if type == .push{
            btn.setImage(UIImage.init(named: "左右箭头"), for: .normal)
        }else if type == .present{
            btn.setImage(UIImage.init(named: "左右箭头"), for: .normal)
        }
        
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        btn.layer.cornerRadius = 17
        btn.layer.masksToBounds = true
        return btn
    }()

    /** 音视频采集会话 */
    private let captureSession = AVCaptureSession()
    
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
    
    public var bottomSizeHight: CGFloat = 40
    
    private var currentImageList: [UIImage] = []
    
    private var currentImageView: UIImageView?
    
    init(photosTypes: WisdomPhotosType?,
         photosTasks: @escaping WisdomPhotosTask,
         errorTasks: @escaping WisdomErrorTask) {
        photosTask = photosTasks
        errorTask = errorTasks
        
        if photosTypes != nil{
            photosType = photosTypes!
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
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
    
    @objc func photoAction(){
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
        currentImageView = imageView
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.3
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 1.0
        scaleDown.toValue = 0.2
        
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = NSValue(cgPoint: imageView.layer.position)
        position.toValue = NSValue(cgPoint: center)
        
        groupAnimation.animations = [scaleDown, position]
        groupAnimation.delegate = self
        imageView.layer.add(groupAnimation, forKey: "WisdomPhotoAnimation")
        
        if maxCount < 0{
            cameraBtn.isEnabled = false
            captureSession.stopRunning()
        }
    }
    
    @objc private func onceCancelAction(){
        maxCount = 8
        cameraBtn.isHidden = false
        captureSession.startRunning()
        
        UIView.animate(withDuration: 0.25) {
            self.cancel.transform = CGAffineTransform.identity
            self.save.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func nineCancelAction(){
        maxCount = 8
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
        turnTorchOn(lightOn: btn.isSelected)
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
    
    @objc private func showEidtView(){
        captureSession.stopRunning()
        WisdomPhotoEditVC.showEdit(rootVC: self,
                                   imageList: currentImageList,
                                   beginCenter: center,
                                   beginSize: animationViewSize)
    }
    
    private func upgrades(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let alert = UIAlertController(title: "打开照相机提示", message: "需要扫码来同步消息,添加好友和上传图片,您是否允许打开相机?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "去开启", style: .default, handler: {
                action in
                //NotificationCenter.default.post(name: NSNotification.Name(OpenURL_Notification_Name), object: OpenURLFuncType.cameraCodeType)
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("摄像头释放")
    }
}

extension WisdomPhotosVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate, CAAnimationDelegate {
    /** 切换摄像头 */
    @objc private func toggleCamera() {
        let res : Bool = (currentDevice?.torchMode == .on) ? true : false
        if res && currentDevice == backFacingCamera{
            turnTorchOn(lightOn : false)
            photoLightBtn.isSelected = false
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
    
    private func turnTorchOn(lightOn : Bool){
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else{
            if lightOn{
                //ZHInvestScanManager.confirm(title: "温馨提示", message: "闪光灯不可用", controller: self)
            }
            return
        }
        if device.hasTorch{
            do{
                try device.lockForConfiguration()
                if lightOn && device.torchMode == .off{
                    device.torchMode = .on
                }else{
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }catch{
                
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            currentImageView?.removeFromSuperview()
            currentImageView = nil
            animationBgBtn.isHidden = false
            animationBgBtn.setBackgroundImage(currentImageList.last, for: .normal)
        }
    }
}
