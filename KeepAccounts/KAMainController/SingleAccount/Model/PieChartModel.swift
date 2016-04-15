//
//  PieChartModel.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class PieChartModel: NSObject {
    
    //MARK: - properties (public)
    
    var mergedMonthlyData = [String: [String:[AccountItem]]]() //the final data structure
    var yearArray = [String]()
    var monthArray:[String]{
        var itemsArray = Array(mergedMonthlyData.keys)
        itemsArray.insert("全部", atIndex: 0)
        return itemsArray
    }
    
    //MARK: - properties (private)
    private var initDBName:String
    private var monthDic = [String:[AccountItem]]() //while the key is month and array is items
    private var mergedDBDataDic = [String:[AccountItem]]() // while the key is iconName and array is items
    private var dbData:[AccountItem]{
        return AccoutDB.selectDataOrderByDate(initDBName)
    }
    
    //MARK: - init
    init(dbName:String){
        initDBName = dbName
        super.init()
        //deal with raw data
        groupDateByMonth()
        mergeEachMetaData()
    }
    
    private func groupDateByMonth(){
        if dbData.count > 0 {
            var eachMonthItems = [AccountItem]()
            
            var dateCompRef = NSDate.intervalToDateComponent(NSTimeInterval(dbData[0].date))
            var monthKey = "\(dateCompRef.month)月"
            yearArray.append("\(dateCompRef.year)年")
            eachMonthItems.append(dbData[0])
            
            for i in 1...dbData.count - 1{
                let dateComp = NSDate.intervalToDateComponent(NSTimeInterval(dbData[i].date))
                if dateCompRef.year == dateComp.year{
                    //same month, append item to eachMonthItems
                    if dateCompRef.month == dateComp.month{
                        eachMonthItems.append(dbData[i])
                    }
                    //different month, put eachMonthItems into monthDic with monthKey, remove all items in eachMonthItems and add current dbData[i]
                    else{
                        monthDic[monthKey] = eachMonthItems  //put eachMonthItems into monthDic with monthKey
                        
                        eachMonthItems.removeAll() //remove all items in eachMonthItems
                        monthKey = "\(dateComp.month)月" //update monthKey
                        eachMonthItems.append(dbData[i]) //add current dbData[i]
                        
                        dateCompRef = dateComp //change dateCompRef to current dbData[i]
                    }
                }
                else{
                    yearArray.append("\(dateComp.year)年")
                    
                    monthDic[monthKey] = eachMonthItems
                    
                    eachMonthItems.removeAll() //remove all items in eachMonthItems
                    monthKey = "\(dateComp.month)月"
                    eachMonthItems.append(dbData[i]) //add current dbData[i]
                    
                    dateCompRef = dateComp //change dateCompRef to current dbData[i]
                }
            }
            //put the last key-value into monthDic
            monthDic[monthKey] = eachMonthItems
        }
    }
    private func mergeSameItem(data:[AccountItem])->[String:[AccountItem]]{
        var isChecked = [Bool](count: data.count, repeatedValue: false)
        var dataDic = [String : [AccountItem]]()
        for i in 0...isChecked.count - 1{
            if isChecked[i] == false {
                let imageRef = data[i].iconName
                var tmpData = [AccountItem]()
                for j in 0...data.count - 1{
                    if isChecked[j] == false && imageRef == data[j].iconName{
                        tmpData.append(data[j])
                        isChecked[j] = true
                    }
                }
                dataDic[imageRef] = tmpData
            }
        }
        return dataDic
    }
    private func mergeEachMetaData(){
        //all
        mergedDBDataDic = mergeSameItem(dbData)
        //monthly
        for (key, monthDataArray) in monthDic{
            mergedMonthlyData[key] = mergeSameItem(monthDataArray)
        }
        
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
