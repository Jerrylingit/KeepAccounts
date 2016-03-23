//
//  NSDate+Extension.swift
//  KeepAccounts
//
//  Created by admin on 16/3/14.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

extension NSDate{
    class func intervalToChinaCalander(interval:NSTimeInterval) ->String{
        let date = NSDate(timeIntervalSince1970: interval)
        let cal = NSCalendar.currentCalendar()
        let calCom = cal.components([.Year, .Month, .Day], fromDate: date)
        let currentDate = "\(calCom.year)年\(calCom.month)月\(calCom.day)日"
        return currentDate
    }
    class func intervalToDateComponent(interval:NSTimeInterval) -> NSDateComponents{
        let date = NSDate(timeIntervalSince1970: interval)
        let cal = NSCalendar.currentCalendar()
        let calCom = cal.components([.Year, .Month, .Day], fromDate: date)
        return calCom
    }
    
}
