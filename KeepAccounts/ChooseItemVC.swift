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
    
    let ComputeBoardHeight =  UIScreen.mainScreen().bounds.height/2 - 20
    
    let TopBarHeight: CGFloat = 44.0
    let CostBarHeight: CGFloat = 72.0
    
    
    
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
        let topBar = TopBarView(frame: CGRectMake(0, 20, ScreenWidth, TopBarHeight))
        //添加到主view上
        self.view.addSubview(topBar)
    }
    
    //创建图标项
    func setupItem(){
        let ItemBarHeight = ScreenHeight - 20 - TopBarHeight - CostBarHeight - ComputeBoardHeight
        
        let itemBar = ItemBarView(frame: CGRectMake(0, 20 + TopBarHeight , ScreenWidth, ItemBarHeight))
        self.view.addSubview(itemBar)
    }
    
    //创建消费金额栏
    func setupCostBar(){
        
        //消费金额栏
        let costBar = CostBarView(frame: CGRectMake(0, ScreenHeight - CostBarHeight - ComputeBoardHeight , ScreenWidth, CostBarHeight))
        //添加到self.view
        self.view.addSubview(costBar)
    }
    //创建计算面板
    func setupComputeBoard(){
        //创建计算面板
        let computeBoard = ComputeBoardView(frame: CGRectMake(0, ScreenHeight - ComputeBoardHeight, ScreenWidth, ComputeBoardHeight))
        //添加到self.view
        self.view.addSubview(computeBoard)
    }

}

