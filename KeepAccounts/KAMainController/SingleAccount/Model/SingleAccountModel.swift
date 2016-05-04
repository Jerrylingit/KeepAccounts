//
//  SingleAccountModel.swift
//  KeepAccounts
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit



class SingleAccountModel: NSObject {
    
    //MARK: - properties (public)
    var itemAccounts:[AccountItem] = []
    var totalIncome:Float = 0
    var totalCost:Float = 0
    
    
    
    
    
    //数据库名和标题
    var initDBName:String
    var accountTitle:String
    
    //MARK: - properties (private)
    private let lastCellInterval:NSTimeInterval = NSDate().timeIntervalSince1970 + 86400
    
    //MARK: - init (internal)
    init(initDBName:String, accountTitle:String){
        self.initDBName = initDBName
        self.accountTitle = accountTitle
        super.init()
        setAccountBookDataInModel()
    }
    //MARK: - operation (internal)
    
    func setAccountBookDataInModel(){
        //总支出和总收入
        let totalIncome:Float = 0
        var totalCost:Float = 0
        var lastInterval = lastCellInterval
        var dayCostItem:AccountItem = AccountItem()
        //从数据库中取出所有数据
        itemAccounts = AccoutDB.selectDataOrderByDate(initDBName)
        //处理符合显示要求的数据
        //1、分开日期； 2、计算日金额
        var tmpItemAccounts:[AccountItem] = []
        for sourceItem in itemAccounts {
            //1、比较大小
            let showDate = compareDate(NSTimeInterval(sourceItem.date), lastInterval: lastInterval)
            //2、保存当前的日期值到lastCellInterval
            lastInterval = NSTimeInterval(sourceItem.date)
            //3、修改原数据
            sourceItem.dateString = showDate
            sourceItem.dayCost = sourceItem.money
            //累加
            if let money = Float(sourceItem.money){
                totalCost += money
            }
            //4、判断showDate是否为空字符串，为空则加上本次的金额，不为空则替换cell
            if showDate == "" {
                let dayCostTmp = Float(dayCostItem.dayCost) ?? 0
                let moneyTmp = Float(sourceItem.money) ?? 0
                let curMoney = dayCostTmp + moneyTmp
                dayCostItem.dayCost = NSString(format: "%.2f", curMoney) as String
                sourceItem.dayCost = ""
            }
            else{
                dayCostItem = sourceItem
            }
            tmpItemAccounts.append(sourceItem)
        }
        self.itemAccounts = tmpItemAccounts
        self.totalIncome = totalIncome
        self.totalCost = totalCost
    }
    
    private func compareDate(currentInterval:NSTimeInterval, lastInterval:NSTimeInterval) -> String{
        let currentCom = NSDate.intervalToDateComponent(currentInterval)
        let lastCom = NSDate.intervalToDateComponent(lastInterval)
        let yearEqual = currentCom.year == lastCom.year
        let monthEqual = currentCom.month == lastCom.month
        let dayEqual = currentCom.day == lastCom.day
        if yearEqual == true{
            if monthEqual == true{
                if dayEqual == true{
                    return ""
                }
                else{
                    return "\(currentCom.day)日"
                }
            }
            else{
                return "\(currentCom.month)月\(currentCom.day)日"
            }
        }
        else{
            return "\(currentCom.year)年\(currentCom.month)月\(currentCom.day)日"
        }
    }
}
