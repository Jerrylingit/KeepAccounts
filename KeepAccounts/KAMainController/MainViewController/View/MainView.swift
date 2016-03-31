//
//  MainView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

//组件高度

private let ScreenWidthRatio = UIScreen.mainScreen().bounds.width / 375
private let ScreenHeightRatio = UIScreen.mainScreen().bounds.height / 667

class MainView: UIView {
    let StatusBarHeight:CGFloat = 20
    let TopBarHeight:CGFloat = 72
    let IncomeAndExpendBarHeight:CGFloat = 50
    let BottomBarHeight:CGFloat = 60
    
    //供修改总收入和总支出的接口, 1: 总收入， 2: 总支出， 3: 总结余
    var incomeAndExpendLabels: NSArray = NSArray()
    var accountBookBtnView:UICollectionView?
    var delegate:MainViewController?
    
    convenience init(frame:CGRect, delegate:MainViewController){
        self.init(frame:frame)
        let IncomeAndExpendBarY = StatusBarHeight + TopBarHeight
        let AccountsViewHeight = frame.height - IncomeAndExpendBarY - IncomeAndExpendBarHeight - BottomBarHeight
        let AccountsViewY = IncomeAndExpendBarY + IncomeAndExpendBarHeight
        let BottomBarY = AccountsViewY + AccountsViewHeight
        
        self.backgroundColor = UIColor.whiteColor()
        self.delegate = delegate
        let contentWidth = frame.width - 30 * ScreenWidthRatio
        //顶部栏
        setupTopBar(CGRectMake(0, StatusBarHeight, contentWidth, TopBarHeight))
        //收入和支出
        setupIncomeAndExpendBar(CGRectMake(0, IncomeAndExpendBarY, contentWidth, IncomeAndExpendBarHeight))
        //账本
        setupAccountsView(CGRectMake(0, AccountsViewY, contentWidth, AccountsViewHeight))
        //底部
        setupBottomBar(CGRectMake(0, BottomBarY, contentWidth, BottomBarHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        let AccountsWidth:CGFloat = 80 * ScreenWidthRatio
        let AccountsHeight:CGFloat = 110 * ScreenHeightRatio
  
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(AccountsWidth, AccountsHeight)
        flowLayout.scrollDirection = .Vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.registerNib(UINib(nibName: "AccountBookCell", bundle: nil), forCellWithReuseIdentifier: "AccountBookBtnCell")
        self.accountBookBtnView = collectionView
        
        self.addSubview(collectionView)
    }
    //底部
    private func setupBottomBar(frame:CGRect){
        let bottomBar = UIView(frame: frame)
        let sepLine = UIView(frame: CGRectMake(0, 0 , frame.width, 1))
        sepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        let explore = UIButton(frame: CGRectMake(0, 0, 40, 40))
        explore.center = CGPointMake(frame.width/2, frame.height/2)
        explore.setImage(UIImage(named: "button_add"), forState: .Normal)
        
        bottomBar.addSubview(sepLine)
        bottomBar.addSubview(explore)
        self.addSubview(bottomBar)
    }
    func reloadCollectionView(){
        self.accountBookBtnView?.reloadData()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
