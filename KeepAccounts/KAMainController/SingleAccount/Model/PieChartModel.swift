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
    
    var mergedMonthlyData = [Int: [String:[AccountItem]]]() //the final data structure
    var yearArray = [String]()
    var mergedDBDataDic = [String:[AccountItem]]() // while the key is iconName and array is items
    var monthArray:[String]{
        var items = [String]()
        let itemsArray = Array(mergedMonthlyData.keys)
        for i in 0...itemsArray.count - 1{
            let interval = NSTimeInterval(itemsArray[i])
            let month = NSDate.intervalToDateComponent(interval).month
            items.append("\(month)月")
        }
        items.insert("全部", atIndex: 0)
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
    func getLayerDataItem(dataItem:[String:[AccountItem]])->[CGFloat] {
        var layerData = [CGFloat]()
        for (_, items) in dataItem{
            var value:Float = 0
            for item in items{
                value += Float(item.money) ?? 0
            }
            layerData.append(CGFloat(value))
        }
        return layerData
    }
    //MARK: - methods (private)
    private func groupDateByMonth(){
        if dbData.count > 0 {
            var eachMonthItems = [AccountItem]()
            
            var dateCompRef = NSDate.intervalToDateComponent(NSTimeInterval(dbData[0].date))
            var monthKey = dbData[0].date
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
                        monthKey = dbData[i].date //update monthKey
                        eachMonthItems.append(dbData[i]) //add current dbData[i]
                        
                        dateCompRef = dateComp //change dateCompRef to current dbData[i]
                    }
                }
                else{
                    yearArray.append("\(dateComp.year)年")
                    
                    monthDic[monthKey] = eachMonthItems
                    
                    eachMonthItems.removeAll() //remove all items in eachMonthItems
                    monthKey = dbData[i].date
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
}
