//
//  AccountDataSource.swift
//  KeepAccounts
//
//  Created by admin on 16/3/11.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class AccountDataSource: NSObject, UITableViewDataSource {
    
    var itemAccounts:[AccountItem] = []
    
    override init() {
        itemAccounts = AccoutDB.selectDataOrderByDate()
    }
    
    func itemFromDataSourceWith(indexPath:NSIndexPath) -> AccountItem{
        if indexPath.row < itemAccounts.count{
            return itemAccounts[indexPath.row]
        }
        return AccountItem()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identify = "AccountCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! AccountCell
        let item = itemFromDataSourceWith(indexPath)
        cell.iconTitle.text = item.iconTitle
        cell.icon.setImage(UIImage(named: item.iconName), forState: .Normal)
        cell.itemCost.text = item.money
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemAccounts.count
    }
}
