//
//  MainView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

//组件高度
let StatusBarHeight:CGFloat = 20
let TopBarHeight:CGFloat = 72
let IncomeAndExpendBarHeight:CGFloat = 50
let BottomBarHeight:CGFloat = 60

class MainView: UIView {
    //供修改总收入和总支出的接口, 1: 总收入， 2: 总支出， 3: 总结余
    var incomeAndExpendLabels: NSArray = NSArray()
    
    override init(frame: CGRect) {
        
        let IncomeAndExpendBarY = StatusBarHeight + TopBarHeight
        let AccountsViewHeight = frame.height - IncomeAndExpendBarY - IncomeAndExpendBarHeight - BottomBarHeight
        let AccountsViewY = IncomeAndExpendBarY + IncomeAndExpendBarHeight
        let BottomBarY = AccountsViewY + AccountsViewHeight
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        //顶部栏
        setupTopBar(CGRectMake(0, StatusBarHeight, frame.width, TopBarHeight))
        //收入和支出
        setupIncomeAndExpendBar(CGRectMake(0, IncomeAndExpendBarY, frame.width, IncomeAndExpendBarHeight))
        //账本
        setupAccountsView(CGRectMake(0, AccountsViewY, frame.width, AccountsViewHeight))
        //底部
        setupBottomBar(CGRectMake(0, BottomBarY, frame.width, BottomBarHeight))
    }
    
    
    //顶部栏
    private func setupTopBar(frame:CGRect){
        let IconMarginVertical:CGFloat = 15
        let IconMarginLeft:CGFloat = 20
        let IconMarginRight:CGFloat = 10
        let IconWidth:CGFloat = 40
        
        let TitleX = IconWidth + IconMarginLeft + IconMarginRight
        let TitleWidth:CGFloat = 60
        
        let SettingWidth:CGFloat = 26
        let SettingX = frame.width - SettingWidth - 40
        let SettingY:CGFloat = 20
        
        let topBar = UIView(frame: frame)
        
        let icon = UIButton(frame: CGRectMake(IconMarginLeft, IconMarginVertical, IconWidth, IconWidth))
        icon.setImage(UIImage(named: "head_icon"), forState: .Normal)
        
        let title = UILabel(frame: CGRectMake(TitleX, 0, TitleWidth, frame.height))
        title.textAlignment = .Center
        title.text = "未登录"
        
        let setting = UIButton(frame: CGRectMake(SettingX, SettingY, SettingWidth, SettingWidth))
        setting.setImage(UIImage(named: "menu_setting"), forState: .Normal)
        
        
        let sepLine = UIView(frame: CGRectMake(0, frame.height - 1 , frame.width, 1))
        sepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        //添加到底部栏
        topBar.addSubview(icon)
        topBar.addSubview(title)
        topBar.addSubview(setting)
        topBar.addSubview(sepLine)
        //添加到主界面
        self.addSubview(topBar)
        
    }
    //收入和支出
    private func setupIncomeAndExpendBar(frame:CGRect){
        let TriWidth = frame.width / 3
        let LabelMarginLeft:CGFloat = 25
        let LabelMarginTop:CGFloat = 20
        
        let LabelWidth:CGFloat = 60
        let LabelHeight:CGFloat = 15
        
        let staticLabelText = ["总收入", "总支出", "总结余"]
        
        let incomeAndExpend = UIView(frame: frame)
        //生成三个标题
        for(var i = 0; i < 3; ++i){
            let LabelX = LabelMarginLeft + CGFloat(i) * TriWidth
            let label = UILabel(frame: CGRectMake(LabelX, LabelMarginTop, LabelWidth, LabelHeight))
            label.text = staticLabelText[i]
            label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            incomeAndExpend.addSubview(label)
        }
        
        //生成三个数值显示label
        for(var i = 0; i < 3; ++i){
            let LabelX = LabelMarginLeft + CGFloat(i) * TriWidth
            let label = UILabel(frame: CGRectMake(LabelX, LabelMarginTop + LabelHeight , LabelWidth, LabelHeight))
            label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            label.text = "0.00"
            incomeAndExpendLabels.arrayByAddingObject(label)
            incomeAndExpend.addSubview(label)
        }
        
        self.addSubview(incomeAndExpend)
    }
    //账本
    private func setupAccountsView(frame:CGRect){
        
        let AccountsWidth:CGFloat = 80
        let AccountsHeight:CGFloat = 108
        let AccountsMarginLeft = (frame.width - 3 * AccountsWidth) / 4
        
        let AccountsScrollView = UIScrollView(frame: frame)
        
        let Accounts = UIButton(frame: CGRectMake(AccountsMarginLeft, 20, AccountsWidth, AccountsHeight))
        Accounts.setImage(UIImage(named: "book_cover_0"), forState: .Normal)
        
        AccountsScrollView.addSubview(Accounts)
        self.addSubview(AccountsScrollView)
        
    }
    //底部
    private func setupBottomBar(frame:CGRect){
        let bottomBar = UIView(frame: frame)
        let sepLine = UIView(frame: CGRectMake(0, 0 , frame.width, 1))
        sepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        let explore = UIButton(frame: CGRectMake(0, 0, 40, 40))
        explore.backgroundColor = UIColor.blueColor()
        explore.center = bottomBar.center
        explore.imageView?.image = UIImage(named: "button_add")
        
        bottomBar.addSubview(sepLine)
        bottomBar.addSubview(explore)
        self.addSubview(bottomBar)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
