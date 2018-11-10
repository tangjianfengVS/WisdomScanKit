//
//  WisdomRQCodeVC.swift
//  WisdomScanKit
//
//  Created by jianfeng on 2018/11/9.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import AVFoundation

class WisdomRQCodeVC: UIViewController {
    private let answerTask: WisdomAnswerTask!
    
    private let errorTask: WisdomErrorTask!
    
    private var type: WisdomScanningType = .push
    
    private var themeType: WisdomRQCodeThemeType = .green
    
    private var scanSession : AVCaptureSession?
    
    private let scanAnimationDuration = 2.5
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.qr]
    
    private var lightOn = false
    
    private var isStartScan: Bool = false{
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
    
    private lazy var titleLab : UILabel = {
        let label: UILabel = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = "请对准二维/条形码，即可自动扫描"
        return label
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton()
    
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
    
    private lazy var scanPane: UIImageView = {
        let scan = UIImageView(image: UIImage.init(named: "QRCode_ScanBox"))
        return scan
    }()
    
    private lazy var scanLine : UIImageView = {
        let scanLine = UIImageView(image: UIImage.init(named: "QRCode_ScanLine"))
        return scanLine
    }()
    
    private lazy var lightBtn : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "qrcode_scan_btn_flash_down"), for: .selected)
        btn.setBackgroundImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for: .normal)
        btn.addTarget(self, action: #selector(light(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        //navigationController?.navigationBar.tintColor = UIColor.white
        //navigationController?.setNavigationBarHidden(true, animated: true)
        isStartScan = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    init(types: WisdomScanningType, themeTypes: WisdomRQCodeThemeType?,
                                   answerTasks: @escaping WisdomAnswerTask,
                                    errorTasks: @escaping WisdomErrorTask) {
        type = types
    
        if themeTypes != nil{
            themeType = themeTypes!
        }
        answerTask = answerTasks
        errorTask = errorTasks
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScanSession()
        
        switch themeType {
        case .green:
            print("")
        case .snowy:
            scanPane.image = nil
            scanLine.image = nil
            
            scanPane.layer.borderWidth = 0.8
            scanPane.layer.borderColor = UIColor(red: 212, green: 224, blue: 244, alpha: 1).cgColor
            
            titleLab.textColor = UIColor(red: 212, green: 224, blue: 244, alpha: 1)
            scanLine.backgroundColor =  UIColor(red: 212, green: 224, blue: 244, alpha: 1)
        }
    }
    
    private func setupUI() {
        view.addSubview(backBtn)
        view.addSubview(scanPane)
        scanPane.addSubview(scanLine)
        view.addSubview(lightBtn)
        view.addSubview(titleLab)
        
        backBtn.frame = CGRect(x: 18, y: 30, width: 34, height: 34)
        
        scanPane.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        scanPane.center = view.center
        
        if themeType == .snowy {
            scanLine.frame = CGRect(x: 25, y: 60, width: scanPane.bounds.width - 50, height: 0.8)
        }else{
            scanLine.frame = CGRect(x: 5, y: 60, width: scanPane.bounds.width - 10, height: 3)
        }
        
        lightBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 60)
        lightBtn.center = view.center
        var frame = lightBtn.frame
        frame.origin.y = scanPane.frame.maxY + 30
        lightBtn.frame = frame
        
        titleLab.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
        titleLab.center = view.center
        frame = titleLab.frame
        frame.origin.y = scanPane.frame.minY - 60
        titleLab.frame = frame
    }
    
    @objc private func clickBackBtn(){
        if type == .push {
            
            if  navigationController != nil {
                navigationController!.popViewController(animated: true)
            }else{
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                }) { (_) in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }else if type == .present{
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupScanSession(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            open()
        case .denied:
            upgrades()
        case .notDetermined:
            open()
        case .restricted:
            print("")
            //ZHInvestScanManager.confirm(title: "温馨提示", message: "摄像头不可用", controller: self)
        }
    }
    
    private func open() {
        do{
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            let input = try AVCaptureDeviceInput.init(device: device!)
            scanSession = AVCaptureSession()
            let output = AVCaptureMetadataOutput()
            
            scanSession!.canSetSessionPreset(AVCaptureSession.Preset.high)
            if (scanSession!.canAddInput(input)){
                scanSession!.addInput(input)
            }
            if (scanSession!.canAddOutput(output)){
                scanSession!.addOutput(output)
            }
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = supportedCodeTypes
            
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession!)
            scanPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            scanPreviewLayer.frame = view.layer.bounds
            view.layer.insertSublayer(scanPreviewLayer, at: 0)
            //自动对焦
            if (device?.isFocusModeSupported(.autoFocus))!{
                do {
                    try input.device.lockForConfiguration()
                } catch{
                    
                }
                input.device.focusMode = .autoFocus
                input.device.unlockForConfiguration()
            }
            let rect = CGRect(x: scanPane.frame.origin.y/UIScreen.main.bounds.height,
                              y: scanPane.frame.origin.x/UIScreen.main.bounds.width,
                              width: scanPane.frame.height/UIScreen.main.bounds.height,
                              height: scanPane.frame.width/UIScreen.main.bounds.width)
            output.rectOfInterest = rect
        }catch{
            print("")
            //ZHInvestScanManager.confirm(title: "温馨提示", message: "摄像头不可用", controller: self)
        }
    }
    
    private func upgrades(){
        view.backgroundColor = UIColor.black
        let alert = UIAlertController(title: "开启照相机提示", message: "App需要您的同意,才能访问相机,用于扫码和摄像", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "去开启", style: .default, handler: {
            action in
            
            
            let url = URL(string: UIApplication.openSettingsURLString)
            if url != nil && UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.openURL(url!)
            }
            
            
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func light(sender: UIButton){
        lightOn = !lightOn
        sender.isSelected = lightOn
        turnTorchOn()
    }
    
    
    private func scanAnimation() -> CABasicAnimation{
        let startPoint = CGPoint(x: 240/2 , y: 10)
        let endPoint = CGPoint(x: 240/2, y: 240-20)
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        return translation
    }
    
    private func turnTorchOn(){
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
                }
                if !lightOn && device.torchMode == .on{
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }
            catch{ }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("扫码释放")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WisdomRQCodeVC : AVCaptureMetadataOutputObjectsDelegate{
    //4.播放声音
    class func playAlertSound(sound:String){
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }
        
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    private func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //播放声音
        //WisdomRQCodeVC.playAlertSound(sound: "noticeMusic.caf")
        if metadataObjects.count > 0{
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                let strvalue = resultObj.stringValue
                
                if strvalue != nil {
                    answerTask(strvalue!,&isStartScan)
                }else{
                    errorTask("扫描结果为空",&isStartScan)
                }
            }
        }else{
            errorTask("扫描结果为空",&isStartScan)
        }
    }
}
