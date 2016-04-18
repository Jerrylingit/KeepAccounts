//
//  PieChartModel.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit
//data displayed in piechartview
class RotateLayerData:NSObject {
    let title:String
    let money:String
    let icon:String
    var percent:String
    let count:String
    
    init(title:String, money:String, icon:String, percent:String, count:String){
        self.title = title
        self.money = money
        self.icon = icon
        self.percent = percent
        self.count = count
        super.init()
    }
}

class PieChartModel: NSObject {
    //MARK: - properties (public)
    
    var mergedMonthlyData = [Int: [String:[AccountItem]]]() //the final data structrue
    var yearArray = [String]()
    var rotateLayerDataArray = [RotateLayerData]()
    var mergedDBDataDic = [String:[AccountItem]]() // while the key is iconName and array is items
    var keysOfMergedMonthlyDataAfterDeal:[String]{
        var items = [String]()
        let itemsArray = Array(mergedMonthlyData.keys)
        items.append("全部")
        for (_, value) in itemsArray.enumerate(){
            if value != -1{
                let interval = NSTimeInterval(value)
                let month = NSDate.intervalToDateComponent(interval).month
                items.append("\(month)月")
            }
        }
        return items
    }
    
    
    //MARK: - properties (private)
    private var initDBName:String
    private var monthDic = [Int:[AccountItem]]() //while the key is month and array is items
    
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
    //MARK: - operation(internal)
    func getLayerDataItem(dataItem:[String:[AccountItem]])->[RotateLayerData] {
        var amount:Float = 0
        var layerData = [CGFloat]()
        var rotateLayerDataArray = [RotateLayerData]()
        for (_, items) in dataItem{
            var value:Float = 0
            var title = ""
            var money = ""
            var icon = ""
            let count = "\(items.count)笔"
            for item in items{
                value += Float(item.money) ?? 0
                title = item.iconTitle
                icon = item.iconName
            }
            money = String(format: "%.2f", value)
            amount += value
            layerData.append(CGFloat(value))
            rotateLayerDataArray.append(RotateLayerData(title: title, money: money, icon: icon, percent: "", count: count))
        }
        
        for (i,data) in rotateLayerDataArray.enumerate() {
            let tmpPercent = Float(layerData[i]) / amount
            let percentage = "\(Int(tmpPercent * 100))%"
            data.percent = percentage
        }
        self.rotateLayerDataArray = rotateLayerDataArray
        return rotateLayerDataArray
    }
    
    func getMergedMonthlyDataAtIndex(index:Int) -> [String:[AccountItem]] {
        let itemsArray = Array(mergedMonthlyData.keys)
        let key = itemsArray[index]
        return mergedMonthlyData[key]!
    }
    
    //MARK: - methods (private)
    private func groupDateByMonth(){
        if dbData.count > 0 {
            var eachMonthItems = [AccountItem]()
            
            var dateCompRef = NSDate.intervalToDateComponent(NSTimeInterval(dbData[0].date))
            var monthKey = dbData[0].date
            yearArray.append("\(dateCompRef.year)年")
            
            for (_, value) in dbData.enumerate(){
                let dateComp = NSDate.intervalToDateComponent(NSTimeInterval(value.date))
                if dateCompRef.year == dateComp.year && dateCompRef.month == dateComp.month {
                    //same month, append item to eachMonthItems
//                    if dateCompRef.month == dateComp.month{
                        eachMonthItems.append(value)
//                    }
//                    //different month, put eachMonthItems into monthDic with monthKey, remove all items in eachMonthItems and add current dbData[i]
//                    else{
//                        yearArray.append("\(dateComp.year)年")
//                        monthDic[monthKey] = eachMonthItems  //put eachMonthItems into monthDic with monthKey
//                        
//                        eachMonthItems.removeAll() //remove all items in eachMonthItems
//                        monthKey = value.date //update monthKey
//                        eachMonthItems.append(value) //add current dbData[i]
//                        
//                        dateCompRef = dateComp //change dateCompRef to current dbData[i]
//                    }
                }
                else{
                    yearArray.append("\(dateComp.year)年")
                    
                    monthDic[monthKey] = eachMonthItems
                    
                    eachMonthItems.removeAll() //remove all items in eachMonthItems
                    monthKey = value.date
                    eachMonthItems.append(value) //add current dbData[i]
                    
                    dateCompRef = dateComp //change dateCompRef to current dbData[i]
                }
            }
            //put the last key-value into monthDic
            monthDic[monthKey] = eachMonthItems
            if yearArray[yearArray.endIndex - 1] == yearArray[yearArray.startIndex]{
                let allYear = yearArray[yearArray.startIndex]
                yearArray.insert(allYear, atIndex: 0)
            }
            else{
                let allYear = yearArray[yearArray.endIndex - 1] + "~" + yearArray[yearArray.startIndex]
                yearArray.insert(allYear, atIndex: 0)
            }
            
        }
    }
    private func mergeSameItem(data:[AccountItem])->[String:[AccountItem]]{
        
        var isChecked = [Bool](count: data.count, repeatedValue: false)
        var dataDic = [String : [AccountItem]]()
        for (var i = 0; i < data.count; i += 1){
            if isChecked[i] == false {
                let imageRef = data[i].iconName
                var tmpData = [AccountItem]()
                for (j,_) in data.enumerate(){
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
        if dbData.count > 0  {
            //all
            mergedDBDataDic = mergeSameItem(dbData)
            mergedMonthlyData[-1] = mergeSameItem(dbData)
            //monthly
            for (key, monthDataArray) in monthDic{
                mergedMonthlyData[key] = mergeSameItem(monthDataArray)
            }
        }
    }
}
