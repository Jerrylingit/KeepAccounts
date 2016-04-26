//
//  SingleAccountVC.swift
//  KeepAccounts
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

public let accountModelPath = "DatabaseDoc/AccountModel.db"

protocol SubViewProtocol{
    func clickManageBtn(sender:AnyObject!)
    func clickMidAddBtn(sender:AnyObject!)
    func presentVC(VC:UIViewController, animated:Bool, completion:(()->Void)?)
}

class SingleAccountVC: UIViewController{
    
    //MARK: - properties (private)
    private var singleAccountModel:SingleAccountModel
    private var pieChartModel:PieChartModel!
    private var pieChartView:PieChartView!
    private var mainView:SingleAccountView!
    private var lineChartView:LineChartView!
    
    //MARK: - init
    init(model:SingleAccountModel){
        self.singleAccountModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadDataAndViews", name: "ChangeDataSource", object: nil)
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化界面
        setupMainView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - operation (internal)
    func reloadDataAndViews(){
        //更新数据和界面
        singleAccountModel.setAccountBookDataInModel()
        mainView.reloadViews()
    }
    
    //MARK: - setup views (private)
    private func setupMainView(){
        let bgScrollView = setupBgScrollView(self.view.bounds)
        
        mainView = setupSingleAccountView(self.view.bounds)

        let pieChartView = setupPickerView(CGRectMake(self.view.bounds.width, 0, self.view.bounds.width, self.view.bounds.height))
        
        self.lineChartView = setupLineView(CGRectMake(self.view.bounds.width * 2, 0, self.view.bounds.width, self.view.bounds.height))
        
        bgScrollView.addSubview(mainView)
        bgScrollView.addSubview(pieChartView)
        bgScrollView.addSubview(lineChartView)
        self.view.addSubview(bgScrollView)
    }
    private func setupBgScrollView(frame:CGRect)->UIScrollView{
        let bgScrollView = BgScrollView(frame: frame)
        bgScrollView.contentSize = CGSizeMake(self.view.bounds.width * 4, self.view.bounds.height)
        bgScrollView.bounces = false
        bgScrollView.pagingEnabled = true
        return bgScrollView
    }
    private func setupSingleAccountView(frame:CGRect)->SingleAccountView{
        let singleAccountView = SingleAccountView(frame: self.view.bounds, delegate:self)
        //标题、收入和支出
        singleAccountView.costText = String(format: "%.2f", singleAccountModel.totalCost)
        singleAccountView.incomeText = String(format: "%.2f", singleAccountModel.totalIncome)
        
        return singleAccountView
    }
    
    private func setupPickerView(frame:CGRect) -> PieChartView{
        let pieChartModel = PieChartModel(dbName: singleAccountModel.initDBName)
        self.pieChartModel = pieChartModel
        pieChartModel.setRotateLayerDataArrayWithDataItem(pieChartModel.mergedDBDataDic)
        let pieChartView = PieChartView(frame: frame, layerData: pieChartModel.rotateLayerDataArray, delegate:self, dataSource:self)
        pieChartView.pieChartTotalCost =  String(format: "%.2f", singleAccountModel.totalCost)
        // maybebug
        pieChartView.setYear(pieChartModel.yearArray[0])
        self.pieChartView = pieChartView
        return pieChartView
    }
    private func setupLineView(frame:CGRect)->LineChartView{
        let lineView = LineChartView(frame: frame, delegate: self, dataSource: self, tableViewDelegate: self)
        lineView.pieChartTotalCost =  String(format: "%.2f", singleAccountModel.totalCost)
        pieChartModel.setLineChartTableViewDataWithDataItem(pieChartModel.getMergedMonthlyDataAtIndex(1))
        
        // maybebug
        lineView.setYear(pieChartModel.yearArray[1])
        return lineView
    }
}

extension SingleAccountVC: AKPickerViewDataSource, AKPickerViewDelegate{
    
    // MARK: - AKPickerViewDataSource
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        var count = 0
        if pickerView.superview?.isKindOfClass(PieChartView) == true{
            count = self.pieChartModel.keysOfMergedMonthlyDataAfterDeal.count
        }
        else if pickerView.superview?.isKindOfClass(LineChartView) == true{
            count = self.pieChartModel.keysOfMergedMonthlyDataAfterDeal.count - 1
            count = count >= 0 ? count : 0
        }
        return count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        var title = ""
        if pickerView.superview?.isKindOfClass(PieChartView) == true{
            title = self.pieChartModel.keysOfMergedMonthlyDataAfterDeal[item]
        }
        else if pickerView.superview?.isKindOfClass(LineChartView) == true{
            title = self.pieChartModel.keysOfMergedMonthlyDataAfterDeal[item + 1]
        }
        return title
    }
    
    // MARK: - AKPickerViewDelegate
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        
        if pickerView.superview?.isKindOfClass(PieChartView) == true{
            pieChartModel.setRotateLayerDataArrayWithDataItem(pieChartModel.getMergedMonthlyDataAtIndex(item))
            pieChartView.updateByLayerData(pieChartModel.rotateLayerDataArray)
            pieChartView.setYear(pieChartModel.yearArray[item])
        }
        else if pickerView.superview?.isKindOfClass(LineChartView) == true{
            lineChartView.setYear(pieChartModel.yearArray[item + 1])
        }
    }
}

//MARK: - SubViewProtocol
extension SingleAccountVC: SubViewProtocol{
    func clickManageBtn(sender:AnyObject!){
        self.presentLeftMenuViewController(sender)
    }
    func clickMidAddBtn(sender:AnyObject!){
        let chooseItemVC = ChooseItemVC()
        chooseItemVC.dissmissCallback = {(item) in
            AccoutDB.insertData(self.singleAccountModel.initDBName, item:item)
        }
        self.presentViewController(chooseItemVC, animated: true, completion: nil)
    }
    func presentVC(VC: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.presentViewController(VC, animated: animated, completion: completion)
    }
}


extension SingleAccountVC:UITableViewDataSource, UITableViewDelegate{
    //MARK: - tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat = 0
        if tableView.superview?.isKindOfClass(SingleAccountView) == true {
            height = CGFloat(80)
        }
        else if tableView.superview?.isKindOfClass(LineChartView) == true {
            height = CGFloat(60)
        }
        return height
    }
    //MARK: - tableview datasource
    func itemFromDataSourceWith(indexPath:NSIndexPath) -> AccountItem{
        if indexPath.row < singleAccountModel.itemAccounts.count{
           return singleAccountModel.itemAccounts[indexPath.row]
        }
        return AccountItem()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView.superview?.isKindOfClass(SingleAccountView) == true {
            count = singleAccountModel.itemAccounts.count
        }
        else if tableView.superview?.isKindOfClass(LineChartView) == true {
            count = pieChartModel.rotateLayerDataArray.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.superview?.isKindOfClass(SingleAccountView) == true {
            let rowAmount = tableView.numberOfRowsInSection(indexPath.section)
            let item = itemFromDataSourceWith(indexPath)
            let identify = "AccountCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! AccountCell
            cell.selectionStyle = .None
            cell.presentVCBlock = {[weak self] in
                if let strongSelf = self{
                    let model = ChooseItemModel()
                    let item = AccoutDB.selectDataWithID(strongSelf.singleAccountModel.initDBName, id: item.ID)
                    model.mode = "edit"
                    model.dataBaseId = item.ID
                    model.costBarMoney = item.money
                    model.costBarTitle = item.iconTitle
                    model.costBarIconName = item.iconName
                    model.costBarTime = NSTimeInterval(item.date)
                    model.topBarRemark = item.remark
                    model.topBarPhotoName = item.photo
                    
                    let editChooseItemVC = ChooseItemVC(model: model)
                    editChooseItemVC.dissmissCallback = {(item) in
                        
                        AccoutDB.updateData(strongSelf.singleAccountModel.initDBName, item:item)
                    }
                    strongSelf.presentViewController(editChooseItemVC, animated: true, completion: nil)
                }
                
            }
            cell.deleteCell = {[weak self] in
                if let strongSelf = self{
                    let alertView = UIAlertController(title: "删除账目", message: "您确定要删除吗？", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                    alertView.addAction(UIAlertAction(title: "确定", style: .Default){(action) in
                        AccoutDB.deleteDataWith(strongSelf.singleAccountModel.initDBName, ID: item.ID)
                        strongSelf.reloadDataAndViews()
                        })
                    strongSelf.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            
            cell.botmLine.hidden = false
            cell.dayIndicator.hidden = true
            
            let imagePath = String.createFilePathInDocumentWith(item.photo) ?? ""
            cell.cellID = item.ID
            cell.iconTitle.text = item.iconTitle
            cell.icon.setImage(UIImage(named: item.iconName), forState: .Normal)
            cell.itemCost.text = item.money
            cell.remark.text = item.remark
            cell.dayCost.text = item.dayCost
            cell.date.text = item.dateString
            
            //图片
            if let data = NSData(contentsOfFile: imagePath){
                cell.photoView.image = UIImage(data: data)
            }
            //日期指示器
            if item.dayCost != "" && item.dateString != ""{
                cell.dayIndicator.hidden = false
            }
            
            //最后一个去掉尾巴
            if indexPath.row == rowAmount - 1{
                cell.botmLine.hidden = true
            }
            
            return cell
        }
        else if tableView.superview?.isKindOfClass(LineChartView) == true {
            let cell = tableView.dequeueReusableCellWithIdentifier("LineChartTableViewCell", forIndexPath: indexPath) as! LineChartTableViewCell
            
            let item = pieChartModel.rotateLayerDataArray[indexPath.row + 1]
            cell.money.text = item.money
            cell.title.text = item.title
            cell.icon.image = UIImage(named: item.icon)
            
            let widthScale = Float(item.money)! / Float(pieChartModel.rotateLayerDataArray[0].money)!
            cell.percentage.width = cell.percentage.width * CGFloat(widthScale)
            cell.percentage.backgroundColor = UIColor(hue: CGFloat(widthScale), saturation: 0.7, brightness: 0.5, alpha: 1.0)
            
            return cell
        }
        return UITableViewCell()
    }
}