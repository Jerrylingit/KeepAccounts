//
//  SingleAccountView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let HeadBarHeight:CGFloat = 155

private let BtnWidth:CGFloat = 35
private let BtnMargin:CGFloat = 10
private let StatusBarHeight:CGFloat = 20

private let MidBtnWidth:CGFloat = 60
private let MidBtnHeight:CGFloat = 20
private let MidBtnMarginTop:CGFloat = 20


private let LabelMargin:CGFloat = 15
private let LabelWidth:CGFloat = 145
private let LabelHeight:CGFloat = 30


class SingleAccountView: UIView {
    

    
    weak var delegate:SingleAccountVC?
    var tableView:UITableView?
    var totalIncomeNum:UILabel?
    var totalCostNum:UILabel?
    var incomeText:String?{
        get {
            return totalIncomeNum?.text
        }
        set(newValue){
            totalIncomeNum?.text = newValue
        }
    }
    var costText:String?{
        get {
            return totalCostNum?.text
        }
        set(newValue){
            totalCostNum?.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame:CGRect, delegate:AnyObject!){
        self.init(frame: frame)
        //tableView的数据源和代理应该在其初始化之前就建立好
        self.delegate = delegate as? SingleAccountVC
        setup(frame)
    }
    
    private func setup(frame:CGRect){
        
        
        //头部view
        setupHeadBar(CGRectMake(0, 0, frame.width, HeadBarHeight))
        //中间add按钮
        setupMidAddBtn(frame)
        //收入支出栏
        setupIncomeCostBar(frame)
        //流水账
        let DayAccountsY = HeadBarHeight + LabelMargin * 2  + LabelHeight * 2
        setupDayAccounts(CGRectMake(0, DayAccountsY, frame.width, frame.height - DayAccountsY))
    }
    
    //头部view
    private func setupHeadBar(frame:CGRect){
        
        let HeadBarWidth:CGFloat = frame.width
        
        let headBar = UIImageView(frame: frame)
        headBar.image = UIImage(named: "background1")
        headBar.userInteractionEnabled = true
        
        let manageBtn = UIButton(frame: CGRectMake(BtnMargin, BtnMargin + StatusBarHeight, BtnWidth, BtnWidth))
        manageBtn.setImage(UIImage(named: "btn_menu"), forState: .Normal)
        manageBtn.addTarget(self, action: "clickManageBtn:", forControlEvents: .TouchUpInside)
        
        let midBtn = UIButton(frame: CGRectMake(0, 0, MidBtnWidth, MidBtnHeight))
        midBtn.center = CGPointMake(HeadBarWidth/2, MidBtnMarginTop + StatusBarHeight)
        midBtn.setTitle("日常账本", forState: .Normal)
        midBtn.titleLabel?.font = UIFont(name: "Courier", size: 12)
        midBtn.layer.cornerRadius = 10
        midBtn.layer.borderColor = UIColor.whiteColor().CGColor
        midBtn.layer.borderWidth = 1
        
        let takePhotoBtn = UIButton(frame: CGRectMake(HeadBarWidth - BtnMargin - BtnWidth, BtnMargin + StatusBarHeight, BtnWidth, BtnWidth))
        takePhotoBtn.setImage(UIImage(named: "btn_camera"), forState: .Normal)
        
        headBar.addSubview(manageBtn)
        headBar.addSubview(midBtn)
        headBar.addSubview(takePhotoBtn)
        
        self.addSubview(headBar)
    }
    //中间add按钮
    private func setupMidAddBtn(frame:CGRect){
        let MidAddBtnWidth:CGFloat = 90
        let midAddBtn = UIButton(frame: CGRectMake(0, 0, MidAddBtnWidth, MidAddBtnWidth))
        midAddBtn.center = CGPointMake(frame.width/2, HeadBarHeight)
        midAddBtn.setImage(UIImage(named: "circle_btn"), forState: .Normal)
        midAddBtn.backgroundColor = UIColor.whiteColor()
        midAddBtn.layer.cornerRadius = 45
        midAddBtn.addTarget(self, action: "clickMidAddBtn:", forControlEvents: .TouchUpInside)
        
        self.addSubview(midAddBtn)
    }
    //收入支出栏
    private func setupIncomeCostBar(frame:CGRect){
        
        let income = UILabel(frame: CGRectMake(LabelMargin, HeadBarHeight + LabelMargin, LabelWidth, LabelHeight))
        income.text = "收入"
        
        let CostX = frame.width - LabelWidth - LabelMargin
        let cost = UILabel(frame: CGRectMake(CostX, HeadBarHeight + LabelMargin, LabelWidth, LabelHeight))
        cost.textAlignment = .Right
        cost.text = "支出"
        
        let IncomeNumY = HeadBarHeight + LabelMargin + LabelHeight
        let incomeNum = UILabel(frame: CGRectMake(LabelMargin, IncomeNumY, LabelWidth, LabelHeight))
        incomeNum.text = "0.00"
        self.totalIncomeNum = incomeNum
        
        let costNum = UILabel(frame: CGRectMake(CostX, IncomeNumY, LabelWidth, LabelHeight))
        costNum.textAlignment = .Right
        costNum.text = "0.00"
        self.totalCostNum = costNum
        
        self.addSubview(income)
        self.addSubview(cost)
        self.addSubview(incomeNum)
        self.addSubview(costNum)
    }
    //流水账
    private func setupDayAccounts(frame:CGRect){
        let DayAccountsView = UITableView(frame: frame)
        DayAccountsView.separatorStyle = .None
        DayAccountsView.registerNib(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "AccountCell")
        DayAccountsView.dataSource = delegate
        DayAccountsView.delegate = delegate
        DayAccountsView.rowHeight = UITableViewAutomaticDimension
        DayAccountsView.showsVerticalScrollIndicator = false
        let midColumnLine = UIView(frame: CGRectMake(self.center.x - 2, -300, 1, 300))
        midColumnLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        DayAccountsView.addSubview(midColumnLine)
        
        tableView = DayAccountsView
        self.addSubview(DayAccountsView)
    }
    
    func clickManageBtn(sender:AnyObject!){
        if (delegate?.respondsToSelector("clickManageBtn:") != nil){
            delegate?.clickManageBtn(sender)
        }
        
    }
    func clickMidAddBtn(sender:AnyObject!){
        if (delegate?.respondsToSelector("clickMidAddBtn:") != nil){
            delegate?.clickMidAddBtn(sender)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
