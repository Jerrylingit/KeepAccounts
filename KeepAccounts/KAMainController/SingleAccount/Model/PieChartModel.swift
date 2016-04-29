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


class LineChartInfoData:NSObject{
    let money:Float
    let date:String
    let week:String
    init(money:Float, date:String, week:String){
        self.money = money
        self.date = date
        self.week = week
        super.init()
    }
}

private let secondsPerDay:NSTimeInterval = 86400
private let weekChinese = ["日", "一", "二", "三", "四", "五", "六"]
private let allDataKey:Int = -1

class PieChartModel: NSObject {
    
    //MARK: - properties (public)
    var yearArray = [String]()
    var monthArray = [Int]()
    
    var lineChartTableViewData = [RotateLayerData]()
    var lineChartInfoArray = [LineChartInfoData]()
    var rotateLayerDataArray:[RotateLayerData]
    
    var monthDic = [Int:[AccountItem]]()                    //while the key is month and array is items
    var mergedMonthlyData = [Int: [String:[AccountItem]]]() //the final data structrue
    
    var lineChartMoneyArray:[Float]{
        var tmp = [Float]()
        for value in lineChartInfoArray{
            tmp.append(value.money)
        }
        return tmp
    }
    var pieChartPickerData:[String]{
        var items = [String]()
        items.append("全部")
        for value in monthArray{
            if value != allDataKey{
                let interval = NSTimeInterval(value)
                let month = NSDate.intervalToDateComponent(interval).month
                items.append("\(month)月")
            }
        }
        return items
    }
    var lineChartPickerData:[String]{
        var items = [String]()
        for value in monthArray{
            if value != allDataKey{
                let interval = NSTimeInterval(value)
                let month = NSDate.intervalToDateComponent(interval).month
                items.append("\(month)月")
            }
        }
        return items
    }
    
    //MARK: - properties (private)
    private var initDBName:String
    private var dbData:[AccountItem]{
        return AccoutDB.selectDataOrderByDate(initDBName)
    }
    
    //MARK: - init
    init(dbName:String){
        initDBName = dbName
        let rotateItem = RotateLayerData(title: "一般", money: "0.00", icon: "type_big_1", percent: "100%", count: "0笔")
        rotateLayerDataArray = [rotateItem]
        let comp = NSDate.dateToDateComponent(NSDate())
        yearArray = ["\(comp.year)年", "\(comp.year)年"]
        monthArray = [allDataKey, Int(NSDate().timeIntervalSince1970)]
        super.init()
        //deal with raw data
        groupDateByMonth()
        mergeEachMetaData()
        setRotateLayerDataArrayAtIndex(0)
        setLineChartTableViewDataAtIndex(0)
        setLineChartInfoArrayAtIndex(0)
    }
    //MARK: - operation(internal)
    func setRotateLayerDataArrayAtIndex(i:Int){
        if let dataItem = getMergedMonthlyDataAtIndex(i){
            self.rotateLayerDataArray = getLayerDataItem(dataItem)
        }
    }
    
    func getLayerDataItem(dataItem:[String:[AccountItem]])->[RotateLayerData] {
        var amount:Float = 0
        var layerData = [CGFloat]()
        var array = [RotateLayerData]()
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
            array.append(RotateLayerData(title: title, money: money, icon: icon, percent: "", count: count))
        }
        
        for (i,data) in array.enumerate() {
            let tmpPercent = Float(layerData[i]) / amount
            let percentage = "\(Int(tmpPercent * 100))%"
            data.percent = percentage
        }
        
        array.sortInPlace{(item1, item2)->Bool in
            let item1MoneyFloat = Float(item1.money)
            let item2MoneyFloat = Float(item2.money)
            return item1MoneyFloat > item2MoneyFloat
        }
        return array
    }
    func setLineChartTableViewDataAtIndex(i:Int){
        if let dataItem = getMergedMonthlyDataAtIndex(i + 1){
            self.lineChartTableViewData = getLayerDataItem(dataItem)
        }
    }
    
    func setLineChartInfoArrayAtIndex(i:Int){
        
        if i + 1 < monthArray.count{
            let month = monthArray[i + 1]
            let tmpDate =  NSDate(timeIntervalSince1970: NSTimeInterval(month))
            let numOfDays = NSDate.numberOfDaysInMonthWithDate(tmpDate)
            var firstDateOfMonth = NSDate.getFirstDayOfMonthWithDate(tmpDate)!
            var tmpLineChartInfoArray = [LineChartInfoData]()
            
            for _ in 1...numOfDays{
                
                let compRef = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday], fromDate: firstDateOfMonth)
                var money:Float = 0.0
                let date = "\(compRef.month)月\(compRef.day)日"
                let week = "星期\(weekChinese[compRef.weekday - 1])"
                
                if let item = monthDic[month]{
                    let reverseItem = item.reverse()
                    for value in reverseItem{
                        let itemComp = getCompWithDate(value.date)
                        if compRef.day == itemComp.day{
                            money += Float(value.money) ?? 0
                        }
                    }
                }
                
                tmpLineChartInfoArray.append(LineChartInfoData(money: money, date: date, week: week))
                let nextDateInterval = firstDateOfMonth.timeIntervalSince1970 + secondsPerDay
                firstDateOfMonth = NSDate(timeIntervalSince1970: nextDateInterval)
            }
            lineChartInfoArray = tmpLineChartInfoArray
        }
    }
    
    
    
    func getMergedMonthlyDataAtIndex(index:Int) -> [String:[AccountItem]]? {
        guard index < monthArray.count else{
            return nil
        }
        let key = monthArray[index]
        return mergedMonthlyData[key]
    }
    
    //MARK: - methods (private)
    private func getCompWithDate(date:Int)->NSDateComponents{
        let itemDate = NSDate(timeIntervalSince1970: NSTimeInterval(date))
        let itemComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday], fromDate: itemDate)
        return itemComp
    }
    
    private func groupDateByMonth(){
        
        
        //if there is any data in database
        if dbData.count > 0 {
            var tmpYearArray = [String]()
            var tmpMonthArray = [Int]()
            var tmpMonthDic = [Int:[AccountItem]]()
            var eachMonthItems = [AccountItem]()
            
            var dateCompRef = NSDate.intervalToDateComponent(NSTimeInterval(dbData[0].date))
            var monthKey = dbData[0].date
            tmpYearArray.append("\(dateCompRef.year)年")
            for (_, value) in dbData.enumerate(){
                let dateComp = NSDate.intervalToDateComponent(NSTimeInterval(value.date))
                if dateCompRef.year == dateComp.year && dateCompRef.month == dateComp.month {
                    eachMonthItems.append(value)
                }
                else{
                    tmpYearArray.append("\(dateComp.year)年")
                    tmpMonthArray.append(monthKey)
                    tmpMonthDic[monthKey] = eachMonthItems
                    
                    eachMonthItems.removeAll()          //remove all items in eachMonthItems
                    monthKey = value.date
                    eachMonthItems.append(value)        //add current dbData[i]
                    
                    dateCompRef = dateComp              //change dateCompRef to current dbData[i]
                }
            }
            //put the last key-value into monthDic
            tmpMonthArray.append(monthKey)
            tmpMonthDic[monthKey] = eachMonthItems
            
            yearArray = tmpYearArray
            monthArray = tmpMonthArray
            monthDic = tmpMonthDic
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
        if dbData.count > 0 {
            //all
            if yearArray[yearArray.endIndex - 1] == yearArray[yearArray.startIndex]{
                let allYear = yearArray[yearArray.startIndex]
                yearArray.insert(allYear, atIndex: 0)
            }
            else{
                let allYear = yearArray[yearArray.endIndex - 1] + "~" + yearArray[yearArray.startIndex]
                yearArray.insert(allYear, atIndex: 0)
            }
            mergedMonthlyData[allDataKey] = mergeSameItem(dbData)
            monthArray.insert(allDataKey, atIndex: 0)
            //monthly
            for (key, monthDataArray) in monthDic{
                mergedMonthlyData[key] = mergeSameItem(monthDataArray)
            }
        }
    }
}
