//
//  AccountDB.swift
//  KeepAccounts
//
//  Created by 林若琳 on 16/3/6.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

private let accountModelPath = "DatabaseDoc/AccountModel.db"
private let createTableSQL = "CREATE TABLE IF NOT EXISTS AccountModel(ID INTEGER PRIMARY KEY, ICONNAME TEXT, ICONTITLE TEXT, MONEY TEXT, DAY TEXT, MONTH TEXT, YEAR TEXT, PHOTO OLE OBJECT, REMARK TEXT)"
private let insertSQL = "INSERT INTO AccountModel(ID, IMAGENAME, ICONTITLE, MONEY, DAY, MONTH, YEAR, PHOTO, REMARK) VALUES(?,?,?,?,?,?,?,?,?)"

class AccountItem: NSObject {
    var ID:Int?
    var iconName:String?
    var iconTitle:String?
    var money:String?
    var day:String?
    var month:String?
    var year:String?
    var remark:String?
    var photo:UIImage?
}

class AccoutModel: NSObject {

    //取得数据库文件
    class func getDB()->FMDatabase{
        
        //创建文件路径“TypeBtn.db”
        let btnPath = String.createFilePathInDocumentWith(accountModelPath) ?? ""
        
        //创建filemanager
        let fileManager = NSFileManager.defaultManager()
        //不存在要创建的文件则进入创建操作
        if fileManager.fileExistsAtPath(btnPath) == false {
            //创建.db文件
            let db = FMDatabase(path: btnPath)
            //判断是否创建成功
            if (db != nil){
                if db.open() == true{
                    let sql_stmt = createTableSQL
                    if db.executeStatements(sql_stmt) == false  {
                        //执行语句错误
                        print("Error: \(db.lastErrorMessage())")
                    }
                    db.close()
                }
                else{
                    //打不开文件
                    print("Error: \(db.lastErrorMessage())")
                }
            }
            else{
                //文件创建不成功
                print("Error: \(db.lastErrorMessage())")
            }
        }
        return FMDatabase(path: btnPath)
    }
    //插入数据
    class func insertData(item:AccountItem){
        let db = self.getDB()
        db.open()
        db.executeUpdate(insertSQL, withArgumentsInArray: [item.ID!,item.iconName!, item.iconTitle!])
        db.close()
    }
    
    
    
}
