//
//  MediaModel.swift
//  CXPlayer
//
//  Created by fengyan on 16/2/19.
//  Copyright © 2016年 fengyan. All rights reserved.
//

import UIKit

class MediaModel: NSObject {
    var imageName = String()
    var mp4_url = NSString()
    var playCount = Int()
    var playLength = Int()
    var title = String()
    func setModelValue(dict:NSDictionary){
        imageName = dict.objectForKey("cover") as! String
        mp4_url = dict.objectForKey("mp4_url") as! NSString
        playCount = dict.objectForKey("playCount") as! Int
        playLength = dict.objectForKey("length") as! Int
        title = dict.objectForKey("title") as! String
    }
}
