//
//  ChooseItemModel.swift
//  KeepAccounts
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

class ChooseItemModel:NSObject{
    //用于标志是修改状态还是初始化状态，初始化时为“init”，修改时为“edit”
    var mode:String
    //数据库的存入Id，初始化为0
    var dataBaseId:Int
    dynamic var costBarTime:NSTimeInterval
    dynamic var costBarIconName:String
    dynamic var costBarTitle:String
    dynamic var costBarMoney:String
    dynamic var topBarRemark:String
    dynamic var topBarPhotoName:String
    
    func floatToStringRemain2Decimal(float:Float)->String {
        return String(format: "%.2f", float)
    }
    
    func getCostBarMoneyInFloat()->Float? {
        return Float(costBarMoney)
    }
    
    func setCostBarMoneyWithFloat(float:Float){
        costBarMoney = floatToStringRemain2Decimal(float)
    }
    
    func setCostBarTimeWithDate(date:NSDate){
        costBarTime = date.timeIntervalSince1970
    }
    
    func getCostBarTimeInString()->String{
        return NSDate.intervalToChinaCalander(costBarTime)
    }
    
    func getCostBarTimeInDate()->NSDate{
        return NSDate(timeIntervalSince1970: costBarTime)
    }
    
    
    override init(){
        //初始化赋值
        mode = "init"
        dataBaseId = 0
        costBarTime = NSDate().timeIntervalSince1970
        costBarIconName = "type_big_1"
        costBarTitle = "一般"
        costBarMoney = "0.00"
        topBarRemark = ""
        topBarPhotoName = ""
        super.init()
    }

}
