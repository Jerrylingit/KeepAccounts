//
//  NSString+Path.swift
//  KeepAccounts
//
//  Created by 林若琳 on 16/3/6.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation


extension String{
     public static func createFilePathInDocumentWith(fileName:String) -> String? {
        //返回的paths可能不存在
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let docPath = paths.firstObject as? NSString
        return docPath?.stringByAppendingPathComponent(fileName)
    }
}