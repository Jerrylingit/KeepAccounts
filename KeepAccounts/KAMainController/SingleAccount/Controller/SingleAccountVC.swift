//
//  SingleAccountVC.swift
//  KeepAccounts
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit


protocol SubViewProtocol{
    func clickManageBtn(sender:AnyObject!)
    func clickMidAddBtn(sender:AnyObject!)
}

class SingleAccountVC: UIViewController{
    
    
    var aa = [1,2,3]
    var bb:[Int]{
        get {
            return self.aa
        }
        set(newArray){
            self.aa = newArray
        }
    }
    
    //改时间
    var mainView:SingleAccountView?
    var itemAccounts:[AccountItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadDataSource", name: "ChangeDataSource", object: nil)
        self.view.backgroundColor = UIColor.whiteColor()
        setupMainView()
        initDataSource()
    }
    func reloadDataSource(){
        initDataSource()
        mainView?.tableView?.reloadData()
    }
    
    //MARK: - datasource
    private func initDataSource(){
        itemAccounts = AccoutDB.selectDataOrderByDate()
    }
    private func setupMainView(){
        let singleAccountView = SingleAccountView(frame: self.view.frame, delegate:self)
        mainView = singleAccountView
        self.view.addSubview(singleAccountView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

extension SingleAccountVC: SubViewProtocol{
    func clickManageBtn(sender:AnyObject!){
        self.presentLeftMenuViewController(sender)
    }
    func clickMidAddBtn(sender:AnyObject!){
        self.presentViewController(ChooseItemVC(), animated: true, completion: nil)
    }
}
//MARK: - tableview delegate
extension SingleAccountVC:UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(70)
    }
}

//MARK: - tableview datasource
extension SingleAccountVC:UITableViewDataSource{
    
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
        let imagePath = String.createFilePathInDocumentWith(item.photo) ?? ""
        cell.iconTitle.text = item.iconTitle
        cell.icon.image = UIImage(named: item.iconName)
        cell.itemCost.text = item.money
        cell.remark.text = item.remark
        if let data = NSData(contentsOfFile: imagePath){
            cell.photoView.image = UIImage(data: data)
        }
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemAccounts.count
    }
    
}