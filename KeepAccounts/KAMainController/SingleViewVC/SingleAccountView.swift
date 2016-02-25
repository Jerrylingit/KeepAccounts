//
//  SingleAccountView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit


let HeadBarHeight:CGFloat = 135

let BtnWidth:CGFloat = 35
let BtnMargin:CGFloat = 10

let MidBtnWidth:CGFloat = 60
let MidBtnHeight:CGFloat = 20
let MidBtnMarginTop:CGFloat = 30

class SingleAccountView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame)
    }
    
    private func setup(frame:CGRect){
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated:true)
        //头部view
        setupHeadBar(CGRectMake(0, 0, frame.width, HeadBarHeight))
        //中间add按钮
        setupMidAddBtn(frame)
        //收入支出栏
        setupIncomeCostBar(frame)
        //流水账
        setupDayAccounts(frame)
    }
    
    //头部view
    private func setupHeadBar(frame:CGRect){
        
        let HeadBarWidth:CGFloat = frame.width
        
        let headBar = UIImageView(frame: frame)
        headBar.image = UIImage(named: "background1")
        
        let manageBtn = UIButton(frame: CGRectMake(BtnMargin, BtnMargin, BtnWidth, BtnWidth))
        manageBtn.setImage(UIImage(named: "btn_menu"), forState: .Normal)
        
        let midBtn = UIButton(frame: CGRectMake(0, 0, MidBtnWidth, MidBtnHeight))
        midBtn.center = CGPointMake(HeadBarWidth/2, MidBtnMarginTop)
        midBtn.setTitle("日常账本", forState: .Normal)
        midBtn.titleLabel?.font = UIFont(name: "Courier", size: 12)
        midBtn.layer.cornerRadius = 10
        midBtn.layer.borderColor = UIColor.whiteColor().CGColor
        midBtn.layer.borderWidth = 1
        
        let takePhotoBtn = UIButton(frame: CGRectMake(HeadBarWidth - BtnMargin - BtnWidth, BtnMargin, BtnWidth, BtnWidth))
        takePhotoBtn.setImage(UIImage(named: "btn_camera"), forState: .Normal)
        
        headBar.addSubview(manageBtn)
        headBar.addSubview(midBtn)
        headBar.addSubview(takePhotoBtn)
        
        
        self.addSubview(headBar)
    }
    //中间add按钮
    private func setupMidAddBtn(frame:CGRect){
        
    }
    //收入支出栏
    private func setupIncomeCostBar(frame:CGRect){
        
    }
    //流水账
    private func setupDayAccounts(frame:CGRect){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
