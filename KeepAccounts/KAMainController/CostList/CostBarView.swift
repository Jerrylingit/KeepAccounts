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
    
    let sepLineWidth: CGFloat = 1
    
    var title = UILabel()
    var money = UILabel()
    var iconView = UIImageView()
    var icon:UIImage? {
        get{
            return self.iconView.image
        }
        set(newValue){
            self.iconView.image = newValue
        }
    }
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        //CostBar分割线
        setupCostBarSepLine(self.frame)
        //分割线时间标签
        setupCostBarTime(self.frame)
        //最左边图标
        setupCostBarLeftIcon(self.frame)
        //标题
        setupCostBarTitle(self.frame)
        //右边金额显示
        setupCostBarMoney(self.frame)
    }
    
    override func layoutSubviews() {
        

    }
    //CostBar分割线
    private func setupCostBarSepLine(frame:CGRect){
        let costBarSepLine = UIView(frame: CGRectMake(0, 0, frame.width, sepLineWidth))
        costBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        self.addSubview(costBarSepLine)
    }
    //分割线时间标签
    private func setupCostBarTime(frame: CGRect){
        //分割线时间
        let cal = NSCalendar.currentCalendar()
        let calCom = cal.components([.Year, .Month, .Day], fromDate: NSDate())
        let currentDate = "\(calCom.year)年\(calCom.month)月\(calCom.day)日"
        
        
        //时间标签
        let costBarTime = UILabel(frame: CGRectMake(frame.width/3, -CostBarTimeHeight/2, frame.width/3, CostBarTimeHeight))
        costBarTime.textAlignment = .Center
        costBarTime.backgroundColor = UIColor.whiteColor()
        costBarTime.layer.cornerRadius = 10
        costBarTime.layer.borderWidth = sepLineWidth
        costBarTime.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7).CGColor
        costBarTime.font = UIFont(name: costBarTime.font.fontName, size: 14)
        costBarTime.textColor = UIColor.blackColor()
        costBarTime.text = currentDate
        
        self.addSubview(costBarTime)
    }
    //最左边图标
    private func setupCostBarLeftIcon(frame:CGRect){
        let costBarLeftIcon = UIImageView(frame: CGRectMake(costBarLeftIconMargin, costBarLeftIconMargin, costBarLeftIconWidth, costBarLeftIconWidth))
        costBarLeftIcon.image = UIImage(named: "type_big_1")
        iconView = costBarLeftIcon
        self.addSubview(costBarLeftIcon)
    }
    //标题
    private func setupCostBarTitle(frame: CGRect){
        let costBarTitle = UILabel(frame: CGRectMake(costBarTitleMarginLeft, 0, costBarTitleWidth, frame.height))
        costBarTitle.text = "一般"
        costBarTitle.font = UIFont(name: "Arial", size: 20)
        title = costBarTitle
        self.addSubview(costBarTitle)
    }
    //右边金额显示
    private func setupCostBarMoney(frame: CGRect){
        let costBarMoney = UILabel(frame: CGRectMake(costBarTitleMarginLeft + costBarTitleWidth + 10, 0,
            frame.width - costBarTitleMarginLeft - costBarTitleWidth - 20 , frame.height))
        costBarMoney.textAlignment = .Right
        costBarMoney.font = UIFont(name: "Arial", size: 40)
        costBarMoney.text = "0.0"
        money = costBarMoney
        self.addSubview(costBarMoney)
    }
    
}
