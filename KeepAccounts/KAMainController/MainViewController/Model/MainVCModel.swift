//
//  MainVCModel.swift
//  KeepAccounts
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation



class AccountBookBtn:NSObject, NSCoding{
    
    var btnTitle:String
    var accountCount:String
    var backgrountImageName:String
    var selectedFlag:Bool
    var dataBaseName:String
    
    init(title:String, count:String, image:String, flag:Bool, dbName:String){
        self.btnTitle = title
        self.accountCount = count
        self.backgrountImageName = image
        self.selectedFlag = flag
        self.dataBaseName = dbName
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let btnTitle = aDecoder.decodeObjectForKey("btnTitle") as? String ,
            let count = aDecoder.decodeObjectForKey("accountCount") as? String,
            let image = aDecoder.decodeObjectForKey("backgrountImageName") as? String,
            let dbName = aDecoder.decodeObjectForKey("dataBaseName") as? String
            else{ return nil }
        self.init(title: btnTitle , count: count, image: image, flag: aDecoder.decodeBoolForKey("selectedFlag"), dbName: dbName)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.btnTitle, forKey: "btnTitle")
        aCoder.encodeObject(self.accountCount, forKey: "accountCount")
        aCoder.encodeObject(self.backgrountImageName, forKey: "backgrountImageName")
        aCoder.encodeBool(self.selectedFlag, forKey: "selectedFlag")
        aCoder.encodeObject(self.dataBaseName, forKey: "dataBaseName")
    }
}

let UniqAccountPath = String.createFilePathInDocumentWith(firmAccountPath) ?? ""


class MainVCModel:NSObject{
    
    var totalAccountsIncome:Float = 0
    var totalAccountsCost:Float = 0
    var totalAccountsRemain:Float = 0
    //给collectionview用
    dynamic var accountsBtns:[AccountBookBtn] = []
    
    override init(){
        super.init()
        self.initWithAccountsBtns()
    }
    private func initWithAccountsBtns(){
        let path = String.createFilePathInDocumentWith(firmAccountPath) ?? ""
        if let accountsBtns = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [AccountBookBtn]{
            for i in 0...accountsBtns.count - 2{
                accountsBtns[i].accountCount = String(AccoutDB.itemCount(accountsBtns[i].dataBaseName))+"笔"
            }
            self.accountsBtns.removeAll()
            for element in accountsBtns{
                self.accountsBtns += [element]
            }
        }
    }
    
    func reloadModelData(){
        //更新按钮的itemCount
        let path = String.createFilePathInDocumentWith(firmAccountPath) ?? ""
        if let accountsBtns = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [AccountBookBtn]{
            for i in 0...accountsBtns.count - 2{
                accountsBtns[i].accountCount = String(AccoutDB.itemCount(accountsBtns[i].dataBaseName))+"笔"
            }
            
            self.accountsBtns.removeAll()
            for element in accountsBtns{
                self.accountsBtns += [element]
            }
            
        }
        //更新金额
    }
    
    //更新数组中的flag，互斥
    func showFlagWithIndex(index:Int){
        for i in 0...accountsBtns.count - 1{
            if i == index{
                accountsBtns[i].selectedFlag = true
                NSKeyedArchiver.archiveRootObject(accountsBtns, toFile: UniqAccountPath)
            }
            else{
                accountsBtns[i].selectedFlag = false
                NSKeyedArchiver.archiveRootObject(accountsBtns, toFile: UniqAccountPath)
            }
        }
    }
    
    //查找
    func getItemInfoAtIndex(i:Int)->AccountBookBtn?{
        guard i < accountsBtns.count else{return nil}
        return accountsBtns[i]
    }
    //增加
    func addBookItemByAppend(item:AccountBookBtn){
        accountsBtns.insert(item, atIndex: accountsBtns.count - 1)
        NSKeyedArchiver.archiveRootObject(accountsBtns, toFile: UniqAccountPath)
    }
    //删除
    func removeBookItemAtIndex(i:Int){
        if i < accountsBtns.count{
            accountsBtns.removeAtIndex(i)
            NSKeyedArchiver.archiveRootObject(accountsBtns, toFile: UniqAccountPath)
        }
    }
    //更新
    func updateBookItem(item:AccountBookBtn, atIndex index:Int){
        if index < accountsBtns.count{
            removeBookItemAtIndex(index)
            accountsBtns.insert(item, atIndex: index)
            NSKeyedArchiver.archiveRootObject(accountsBtns, toFile: UniqAccountPath)
        }
    }
}


