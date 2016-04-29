//
//  UITableView+EmptyData.swift
//  KeepAccounts
//
//  Created by admin on 16/4/29.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

extension UITableView{
    public func tableViewDisplayWithMsg(msg:String, ifNecessaryForRowCount rowCount:Int){
        if rowCount == 0 {
            let msgLabel = UILabel()
            msgLabel.text = msg
            msgLabel.font = UIFont(name: "", size: 14)
            msgLabel.textColor = UIColor.grayColor()
            msgLabel.textAlignment = .Center
            
            self.backgroundView = msgLabel
        }
        else{
            self.backgroundView = nil
        }
    }
}