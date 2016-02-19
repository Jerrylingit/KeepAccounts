//
//  btnModel.swift
//  KeepAccounts
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class btnModel: NSObject {
    var ID : Int
    var imageName : NSString
    var iconTitle : NSString
    
    init(ID:Int, imageName:NSString, iconTitle: NSString){
        self.ID = ID
        self.imageName = imageName
        self.iconTitle = iconTitle
    }
    
    
}
