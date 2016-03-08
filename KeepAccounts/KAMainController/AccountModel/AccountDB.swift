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
private let insertSQL = "INSERT INTO AccountModel(ID, ICONNAME, ICONTITLE, MONEY, DAY, MONTH, YEAR, PHOTO, REMARK) VALUES(?,?,?,?,?,?,?,?,?)"
private let updateSQL = "UPDATE AccountModel SET ICONNAME=?, ICONTITLE=? MONEY=? DAY=? MONTH=? YEAR=? PHOTO=? REMARK=? WHERE ID=?"
private let deleteSQL = "DELETE FROM AccountModel WHERE ID=?"
private let selectSQL = "SELECT * FROM AccountModel WHERE ID=?"

class AccountItem: NSObject {
    var ID:Int = 0
    var iconName = ""
    var iconTitle = ""
    var money = ""
    var day = ""
    var month = ""
    var year = ""
    var remark = ""
    var photo:NSData = NSData()
}

class AccoutDB: NSObject {

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
        db.executeUpdate(insertSQL, withArgumentsInArray: [item.ID, item.iconName, item.iconTitle, item.money, item.day, item.month, item.year, item.photo, item.remark])
        db.close()
    }
    //更新数据
    class func updateData(item:AccountItem){
        let db = self.getDB()
        db.open()
        db.executeUpdate(updateSQL, withArgumentsInArray: [item.ID, item.iconName, item.iconTitle, item.money, item.day, item.month, item.year, item.photo, item.remark])
        db.close()
    }
    //删除数据
    class func deleteData(item:AccountItem){
        let db = self.getDB()
        db.open()
        db.executeUpdate(deleteSQL, withArgumentsInArray: [item.ID])
        db.close()
    }
    //查询数据
    class func selectData(id:Int)->AccountItem{
        let db = self.getDB()
        db.open()
        let rs = db.executeQuery(selectSQL, withArgumentsInArray: [id])
        let item = AccountItem()
        while rs.next(){
            item.ID = Int(rs.intForColumn("ID"))
            item.iconName = rs.stringForColumn("ICONNAME")
            item.iconTitle = rs.stringForColumn("ICONTITLE")
            item.money = rs.stringForColumn("MONEY")
            item.day = rs.stringForColumn("DAY")
            item.month = rs.stringForColumn("MONTH")
            item.year = rs.stringForColumn("YEAR")
            item.remark = rs.stringForColumn("REMARK")
            item.photo = rs.dataForColumn("PHOTO")
        }
        return item
    }
    
    
}
