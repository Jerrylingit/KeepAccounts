//
//  ChooseItemVC.swift
//  KeepAccounts
//
//  Created by admin on 16/2/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ChooseItemVC: UIViewController {

    let ScreenWidth = UIScreen.mainScreen().bounds.width
    let ScreenHeight = UIScreen.mainScreen().bounds.height
    let TopBarHeight: CGFloat = 44.0
    let CostBarHeight: CGFloat = 72.0
    let CostBarTimeHeight: CGFloat = 20.0
    
    let costBarLeftIconMargin: CGFloat = 12
    let costBarLeftIconWidth:CGFloat = 48
    
    let costBarTitleMarginLeft: CGFloat = 12+48+12
    let costBarTitleWidth:CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupTopBar()
        setupCostBar()
        setupItem()
        setupComputeBoard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //创建顶部栏
    func setupTopBar(){
        
        //底部栏
        let topBar = UIView(frame: CGRectMake(0, 20, ScreenWidth, TopBarHeight))
        
        //返回
        let topBarBack = UIButton(frame: CGRectMake(20, 10, 22, 22))
        topBarBack.setImage(UIImage(named: "back_light"), forState: UIControlState.Normal)
        //改时间
        let topBarChangeTime = createTopBarBtn(num: 1, title: "改时间", target: self, action: "ChangeTimePress:")
        
        //写备注
        let topBarAddRemark = createTopBarBtn(num: 2, title: "写备注", target: self, action: "AddRemarkPress:")
        
        //加照片
        let topBarTakePhoto = createTopBarBtn(num: 3, title: "加照片", target: self, action: "TakePhotoPress:")
        
        //分割线
        let topBarSepLine = UIView(frame: CGRectMake(0, TopBarHeight - 0.5, ScreenWidth, 0.5))
        topBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        
        //添加到topBar上
        topBar.addSubview(topBarBack)
        topBar.addSubview(topBarChangeTime)
        topBar.addSubview(topBarAddRemark)
        topBar.addSubview(topBarTakePhoto)
        topBar.addSubview(topBarSepLine)
        //添加到主view上
        self.view.addSubview(topBar)
        
    }
    
    func createTopBarBtn(num number:CGFloat, title:String, target:AnyObject, action:Selector) -> UIButton{
        let btn = UIButton(frame: CGRectMake(ScreenWidth/4 * number, 0, ScreenWidth/4, TopBarHeight))
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont(name: "Courier New", size: 14)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return btn
    }
    
    func ChangeTimePress(btn: UIButton?){
        
    }
    func AddRemarkPress(btn: UIButton?){
        
    }
    func TakePhotoPress(btn: UIButton?){
        
    }
    
    
    
    //创建图标项
    func setupItem(){
        
    }
    
    //创建消费金额栏
    func setupCostBar(){
        
        //分割线
        let costBarSepLine = UIView(frame: CGRectMake(0, 0, ScreenWidth, 0.5))
        costBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        
        //分割线时间
        let cal = NSCalendar.currentCalendar()
        let calCom = cal.components([.Year, .Month, .Day], fromDate: NSDate())
        var currentDate = String(calCom.year) + "年"
            currentDate += String(calCom.month) + "月"
            currentDate += String(calCom.day) + "日"
        
        //时间标签
        let costBarTime = UILabel(frame: CGRectMake(ScreenWidth/3, -CostBarTimeHeight/2, ScreenWidth/3, CostBarTimeHeight))
        costBarTime.textAlignment = .Center
        costBarTime.backgroundColor = UIColor.whiteColor()
        costBarTime.layer.cornerRadius = 10
        costBarTime.layer.borderWidth = 0.5
        costBarTime.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7).CGColor
        costBarTime.font = UIFont(name: costBarTime.font.fontName, size: 14)
        costBarTime.textColor = UIColor.blackColor()
        costBarTime.text = currentDate

        
        //消费金额栏
        let costBar = UIView(frame: CGRectMake(0, ScreenHeight - CostBarHeight, ScreenWidth, CostBarHeight))
        
        //最左边图标
        let costBarLeftIcon = UIImageView(frame: CGRectMake(costBarLeftIconMargin, costBarLeftIconMargin, costBarLeftIconWidth, costBarLeftIconWidth))
        costBarLeftIcon.image = UIImage(named: "type_big_1")
        
        //标题
        let costBarTitle = UILabel(frame: CGRectMake(costBarTitleMarginLeft, 0, costBarTitleWidth, CostBarHeight))
        costBarTitle.text = "一般"
        costBarTitle.font = UIFont(name: costBarTitle.font.fontName, size: 16)
        //右边金额显示
        let costBarMoney = UILabel(frame: CGRectMake(costBarTitleMarginLeft + costBarTitleWidth + 10, 0,
                                                     ScreenWidth - costBarTitleMarginLeft - costBarTitleWidth - 20 , CostBarHeight))
        costBarMoney.textAlignment = .Right
        costBarMoney.font = UIFont(name: costBarMoney.font.fontName, size: 20)
        costBarMoney.text = "￥100000"
        
        //添加到底部栏
        costBar.addSubview(costBarSepLine)
        costBar.addSubview(costBarTime)
        costBar.addSubview(costBarLeftIcon)
        costBar.addSubview(costBarTitle)
        costBar.addSubview(costBarMoney)
        //添加到self.view
        self.view.addSubview(costBar)
        
    }
    //创建计算栏
    func setupComputeBoard(){
        
    }

}

