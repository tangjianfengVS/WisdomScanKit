//
//  WisdomAlbumItem.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/22.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit
import Photos

struct WisdomAlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult: PHFetchResult<PHAsset>
    
    init(title:String?,fetchResult:PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }

}
