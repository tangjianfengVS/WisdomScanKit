//
//  WisdomScanKitRootVC.swift
//  WisdomScanKitDemo
//
//  Created by 汤建锋 on 2022/10/25.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit
import SnapKit

class WisdomScanKitRootVC: UIViewController {
    
    let list = [["自定义图片浏览", "系统图片浏览", "跳转-自定义图片浏览"]]
    
    lazy var imageList: [UIImage] = {
        var rray: [UIImage] = []
        for i in 0...18{
            let image = UIImage(named: "test_icon_" + String(i))
            rray.append(image!)
        }
        for i in 0...18{
            let image = UIImage(named: "test_icon_" + String(i))
            rray.append(image!)
        }
        return rray
    }()
    
    lazy var tableView : UITableView = {
        let tableVi = UITableView(frame: CGRect.zero, style: .grouped)
//        tableVi.register(RCCustomTitleCell.self, forCellReuseIdentifier: "\(RCCustomTitleCell.self)")
//        tableVi.register(RCCustomSwitchCell.self, forCellReuseIdentifier: "\(RCCustomSwitchCell.self)")
//        tableVi.register(RCCustomNextCell.self, forCellReuseIdentifier: "\(RCCustomNextCell.self)")
        tableVi.register(WisdomScanKitRootCell.self, forCellReuseIdentifier: "\(WisdomScanKitRootCell.self)")
        
        tableVi.delegate = self
        tableVi.dataSource = self
        tableVi.backgroundColor = .clear
        tableVi.separatorStyle = .none
        return tableVi
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "WisdomScanKit"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
}


extension WisdomScanKitRootVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WisdomScanKitRootCell.self)", for: indexPath) as! WisdomScanKitRootCell
        cell.itemView.infoLabel.text = list[indexPath.section][indexPath.row]
//        let hudStyle = WisdomHUDStyle.allCases[indexPath.section]
//        var loadingStyle: WisdomLoadingStyle?
//        var textPlaceStyle: WisdomTextPlaceStyle?
//
//        switch hudStyle {
//        case .succes: break
//        case .error: break
//        case .warning: break
//        case .loading:
//            loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row)
//        case .text:
//            textPlaceStyle = WisdomTextPlaceStyle.allCases[indexPath.row]
//        }
//
//        cell.setTitle(hudStyle: hudStyle, loadingStyle: loadingStyle, textPlaceStyle: textPlaceStyle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


extension WisdomScanKitRootVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // 自定义图片浏览
            if indexPath.row == 0 {
                let testVC = ViewController(images: imageList)
                let nav = UINavigationController(rootViewController: testVC)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
                
                testVC.handler = { [weak self] (startIconIndex: Int, startIconAnimatRect: CGRect) in
                    // 动画浏览
                    WisdomScanKit.startPhotoChrome(startIndex: startIconIndex,
                                                   startAnimaRect: startIconAnimatRect,
                                                   images: self?.imageList ?? [],
                                                   didChromeClosure: { (currentIndex: Int) -> CGRect in
                        // 更新结束动画 Rect
                        let indexPath = IndexPath(item: currentIndex, section: 0)
                        let window = UIApplication.shared.delegate?.window!
                        let cell = testVC.listView.cellForItem(at: indexPath)
                        var rect: CGRect = .zero

                        if cell != nil{
                              rect = cell!.convert(cell!.bounds, to: window)
                              return rect
                        }
                        return CGRect.zero
                    })
                }
            }else if indexPath.row == 1 {
                
            }else if indexPath.row == 2 {
                WisdomScanKit.startPhotoChrome(title: "图片浏览",
                                               images: imageList,
                                               rootVC: self,
                                               transform: .alpha,
                                               theme: .dark)
            }
        case 1: // 系统图片浏览
            // 动画浏览
//            WisdomScanKit.startPhotoChrome(startIndex: startIconIndex,
//                                           startAnimatRect: startIconAnimatRect,
//                                           iconList: self?.imageList ?? [],
//                                           didChromeClosure: { (currentIndex: Int) -> CGRect in
//                // 更新结束动画 Rect
//                let indexPath = IndexPath(item: currentIndex, section: 0)
//                let window = UIApplication.shared.delegate?.window!
//                let cell = testVC.listView.cellForItem(at: indexPath)
//                var rect: CGRect = .zero
//
//                if cell != nil{
//                      rect = cell!.convert(cell!.bounds, to: window)
//                      return rect
//                }
//                return CGRect.zero
//            })
            break
        case 2: break
            
        default: break
        }
        
//        let style: WisdomHUDStyle = WisdomHUDStyle.allCases[indexPath.section]
//        switch style {
//        case .succes:
//            WisdomHUD.showSuccess(text: "加载成功", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
//                print("")
//            }
//        case .error:
//            WisdomHUD.showError(text: "加载失败", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
//                print("")
//            }.setFocusing()
//        case .warning:
//            WisdomHUD.showWarning(text: "加载警告", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
//                print("")
//            }.setFocusing()
//        case .loading:
//            if let loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row) {
//                WisdomHUD.showLoading(text: "正在加载中", loadingStyle: loadingStyle, barStyle: sceneBarStyle, inSupView: view)
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+8) {
//
//                    //WisdomHUD.showLoading(text: "覆盖测试中", loadingStyle: loadingStyle, barStyle: .light)
//
//                    //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+8) {
//                        WisdomHUD.dismiss()
//                    //}
//                }
//            }
//        case .text:
//            switch WisdomTextPlaceStyle.allCases[indexPath.row] {
//            case .center:
//                WisdomHUD.showTextCenter(text: "添加失败，请稍后重试", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
//                    print("")//加载添加
//                }
//            case .bottom:
//                WisdomHUD.showTextBottom(text: "添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试",
//                                         barStyle: sceneBarStyle,
//                                         inSupView: view,
//                                         delays: 3) { interval in
//                    print("")//加载添加
//                }.setFocusing()
//            default: break
//            }
//        }
    }
}


