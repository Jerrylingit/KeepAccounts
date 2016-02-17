//
//  CostBarView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class CostBarView: UIView {

    let CostBarTimeHeight: CGFloat = 20.0
    
    let costBarLeftIconMargin: CGFloat = 12
    let costBarLeftIconWidth:CGFloat = 48
    
    let costBarTitleMarginLeft: CGFloat = 12+48+12
    let costBarTitleWidth:CGFloat = 60
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
    }
    
    override func layoutSubviews() {
        
        
        let CoseBarWidth = self.frame.width
        let CostBarHeight = self.frame.height
        
        //分割线
        let costBarSepLine = UIView(frame: CGRectMake(0, 0, CoseBarWidth, 0.5))
        costBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        
        //分割线时间
        let cal = NSCalendar.currentCalendar()
        let calCom = cal.components([.Year, .Month, .Day], fromDate: NSDate())
        var currentDate = String(calCom.year) + "年"
        currentDate += String(calCom.month) + "月"
        currentDate += String(calCom.day) + "日"
        
        //时间标签
        let costBarTime = UILabel(frame: CGRectMake(CoseBarWidth/3, -CostBarTimeHeight/2, CoseBarWidth/3, CostBarTimeHeight))
        costBarTime.textAlignment = .Center
        costBarTime.backgroundColor = UIColor.whiteColor()
        costBarTime.layer.cornerRadius = 10
        costBarTime.layer.borderWidth = 0.5
        costBarTime.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7).CGColor
        costBarTime.font = UIFont(name: costBarTime.font.fontName, size: 14)
        costBarTime.textColor = UIColor.blackColor()
        costBarTime.text = currentDate
        
        
        //最左边图标
        let costBarLeftIcon = UIImageView(frame: CGRectMake(costBarLeftIconMargin, costBarLeftIconMargin, costBarLeftIconWidth, costBarLeftIconWidth))
        costBarLeftIcon.image = UIImage(named: "type_big_1")
        
        //标题
        let costBarTitle = UILabel(frame: CGRectMake(costBarTitleMarginLeft, 0, costBarTitleWidth, CostBarHeight))
        costBarTitle.text = "一般"
        costBarTitle.font = UIFont(name: costBarTitle.font.fontName, size: 16)
        //右边金额显示
        let costBarMoney = UILabel(frame: CGRectMake(costBarTitleMarginLeft + costBarTitleWidth + 10, 0,
            CoseBarWidth - costBarTitleMarginLeft - costBarTitleWidth - 20 , CostBarHeight))
        costBarMoney.textAlignment = .Right
        costBarMoney.font = UIFont(name: costBarMoney.font.fontName, size: 20)
        costBarMoney.text = "￥100000"
        
        //添加到底部栏
        self.addSubview(costBarSepLine)
        self.addSubview(costBarTime)
        self.addSubview(costBarLeftIcon)
        self.addSubview(costBarTitle)
        self.addSubview(costBarMoney)
    }

}
