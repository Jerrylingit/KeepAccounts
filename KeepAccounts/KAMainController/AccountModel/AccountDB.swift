//
//  AccountDB.swift
//  KeepAccounts
//
//  Created by 林若琳 on 16/3/6.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

private let accountModelPath = "DatabaseDoc/AccountModel.db"
private let createTableSQL = "CREATE TABLE IF NOT EXISTS AccountModel(ID INTEGER PRIMARY KEY AUTOINCREMENT, ICONNAME TEXT, ICONTITLE TEXT, MONEY TEXT, DATE INTEGER, PHOTO TEXT, REMARK TEXT)"
private let insertSQL = "INSERT INTO AccountModel(ICONNAME, ICONTITLE, MONEY, DATE, PHOTO, REMARK) VALUES(?,?,?,?,?,?)"
private let updateSQL = "UPDATE AccountModel SET ICONNAME=?, ICONTITLE=? MONEY=? DATE=? PHOTO=? REMARK=? WHERE ID=?"
private let deleteSQL = "DELETE FROM AccountModel WHERE ID=?"
private let selectSQL = "SELECT * FROM AccountModel WHERE ID=?"
private let selectOrderByDateSQL = "SELECT * FROM AccountModel ORDER BY date DESC"

class AccountItem: NSObject {
    var ID = 0
    var iconName = ""
    var iconTitle = ""
    var money = ""
    var date = 0
    var remark = ""
    var photo = ""
}

class AccoutDB: NSObject {
    //取得数据库文件
    class func getDB()->FMDatabase{
        
        //创建文件路径
        let btnPath = String.createFilePathInDocumentWith(accountModelPath) ?? ""
        print(btnPath)
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
        db.executeUpdate(insertSQL, withArgumentsInArray: [item.iconName, item.iconTitle, item.money, item.date, item.photo, item.remark])
        db.close()
    }
    //更新数据
    class func updateData(item:AccountItem){
        let db = self.getDB()
        db.open()
        db.executeUpdate(updateSQL, withArgumentsInArray: [item.ID, item.iconName, item.iconTitle, item.money, item.date, item.photo, item.remark])
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
            item.date = Int(rs.intForColumn("DATE"))
            item.remark = rs.stringForColumn("REMARK")
            item.photo = rs.stringForColumn("PHOTO")
        }
        db.close()
        return item
    }
    class func selectDataOrderByDate()->[AccountItem] {
        let db = self.getDB()
        db.open()
        let rs = db.executeQuery(selectOrderByDateSQL, withArgumentsInArray: nil)
        
        var items:[AccountItem] = []
        while rs.next(){
            let item = AccountItem()
            item.ID = Int(rs.intForColumn("ID"))
            item.iconName = rs.stringForColumn("ICONNAME")
            item.iconTitle = rs.stringForColumn("ICONTITLE")
            item.money = rs.stringForColumn("MONEY")
            item.date = Int(rs.intForColumn("DATE"))
            item.remark = rs.stringForColumn("REMARK")
            item.photo = rs.stringForColumn("PHOTO")
            items.append(item)
        }
        db.close()
        return items
    }
    
    
}
