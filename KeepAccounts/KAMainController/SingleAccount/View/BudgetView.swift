//
//  BudgetView.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit
import SnapKit

protocol BudgetViewDelegate {
    func pressSettingBtnWithBudgetView(budgetView:BudgetView)
}

class BudgetView: UIView {

    var budgetNum:String!
    var costNum:String!
    var surpluNum:String!
    var settleDay:String!
    var percentNum:String!
    
    var delegate:BudgetViewDelegate?
    
    private var budgetLabel:KACommonLabel!
    private var dayLabel:KACommonLabel!
    private var costLabel:KACommonLabel!
    private var bottleBg:UIView!
    private var waterView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        setupViews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(frame:CGRect){
        
        let mbLabelMargin:CGFloat = 50
        let mbLabelWidth:CGFloat = 40
        let costLabelMargin:CGFloat = 40
        let costLabelWidth:CGFloat = 50
        let dayLabelMargin:CGFloat = 40
        let dayLabelWidth:CGFloat = 50
        let setBtnMargin:CGFloat = 100
        let setBtnWidth:CGFloat = 50
        let budgetBottleMargin:CGFloat = 30
        let budgetBottleWidth:CGFloat = 80
        
        
        let mbLabel = KACommonLabel()
        mbLabel.setUpLabel("月预算")
        mbLabel.setDownLabel("0.00")
        budgetLabel = mbLabel
        self.addSubview(mbLabel)
        mbLabel.snp_makeConstraints {[weak self] (make) in
            if let weakSelf = self{
                make.top.equalTo(weakSelf).offset(mbLabelMargin)
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.height.width.equalTo(mbLabelWidth)
            }
        }
        
        let costLabel = KACommonLabel()
        costLabel.setUpLabel("支出")
        costLabel.setDownLabel("0.00")
        self.costLabel = costLabel
        self.addSubview(costLabel)
        costLabel.snp_makeConstraints {[weak self](make) in
            if let weakSelf = self{
                make.leading.equalTo(weakSelf).offset(costLabelMargin)
                make.bottom.equalTo(weakSelf).offset(-costLabelMargin)
                make.height.width.equalTo(costLabelWidth)
            }
        }
        
        let dayLabel = KACommonLabel()
        dayLabel.setUpLabel("距结算日")
        dayLabel.setDownLabel("1")
        self.dayLabel = dayLabel
        self.addSubview(dayLabel)
        dayLabel.snp_makeConstraints {[weak self](make) in
            if let weakSelf = self{
                make.trailing.equalTo(weakSelf).offset(-dayLabelMargin)
                make.bottom.equalTo(weakSelf).offset(-dayLabelMargin)
                make.height.width.equalTo(dayLabelWidth)
            }
        }
        
        let setBtn = UIButton()
        setBtn.setBackgroundImage(UIImage(named: "button_edge"), forState: .Normal)
        setBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        setBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        setBtn.addTarget(self, action: "pressSetBtn:", forControlEvents: .TouchUpInside)
        setBtn.setTitle("设置", forState: .Normal)
        self.addSubview(setBtn)
        setBtn.snp_makeConstraints{[weak self](make) in
            if let weakSelf = self{
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.bottom.equalTo(weakSelf).offset(-setBtnMargin)
                make.width.height.equalTo(setBtnWidth)
            }
        }
        
        let bottleBg = UIView()
        bottleBg.backgroundColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
        bottleBg.clipsToBounds = true
        self.bottleBg = bottleBg
        self.addSubview(bottleBg)
        bottleBg.snp_makeConstraints{[weak self](make) in
            if let weakSelf = self{
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.bottom.equalTo(setBtn.snp_top).offset(-budgetBottleMargin)
                make.top.equalTo(mbLabel.snp_bottom).offset(budgetBottleMargin)
                make.leading.equalTo(budgetBottleWidth)
            }
        }
        let waterView = UIImageView()
        self.waterView = waterView
        bottleBg.addSubview(waterView)
        waterView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(bottleBg)
            make.height.equalTo(1)
            make.width.equalTo(1000)
        }
        
        let bottleImage = UIImageView()
        bottleImage.image = UIImage(named: "bottle")
        bottleBg.addSubview(bottleImage)
        bottleImage.snp_makeConstraints { (make) -> Void in
            make.top.leading.bottom.trailing.equalTo(bottleBg)
        }
        
        let bottleLabel = KACommonLabel()
        bottleLabel.setUpLabel("结余")
        bottleLabel.setDownLabel("50000.00")
        bottleBg.addSubview(bottleLabel)
        bottleLabel.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(40)
            make.center.equalTo(bottleBg.center)
        }
        
        let indicatorView = KAHorizIndicatorView()
        indicatorView.setPercentWithText("100%")
        self.addSubview(indicatorView)
        indicatorView.snp_makeConstraints {(make) -> Void in
            make.width.height.equalTo(40)
            make.leading.equalTo(bottleImage.snp_trailing)
            make.centerY.equalTo(bottleImage.snp_bottom)
        }
        
    }
    func waterAnimatedWithImage(image:UIImage, height:CGFloat){
        waterView.image = image
        waterView.frame.origin.x = -(self.waterView.width - self.bottleBg.width)
        UIView.animateWithDuration(1) {() -> Void in
            self.waterView.frame.origin.x = 0
            self.waterView.height = height
        }
    }
    
    func pressSetBtn(btn:UIButton) {
        if let delegate = delegate{
            delegate.pressSettingBtnWithBudgetView(self)
        }
    }
}
