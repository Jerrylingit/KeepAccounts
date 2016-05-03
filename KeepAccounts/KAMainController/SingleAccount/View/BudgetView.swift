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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        setupViews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(frame:CGRect){
        let mbLabel = KACommonLabel()
        mbLabel.setUpLabel("月预算")
        mbLabel.setDownLabel("0.00")
        budgetLabel = mbLabel
        self.addSubview(mbLabel)
        mbLabel.snp_makeConstraints {[weak self] (make) in
            if let weakSelf = self{
                make.top.equalTo(weakSelf).offset(50)
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.height.width.equalTo(40)
            }
        }
        
        let costLabel = KACommonLabel()
        costLabel.setUpLabel("支出")
        costLabel.setDownLabel("0.00")
        self.costLabel = costLabel
        self.addSubview(costLabel)
        costLabel.snp_makeConstraints {[weak self](make) in
            if let weakSelf = self{
                make.leading.equalTo(weakSelf).offset(50)
                make.bottom.equalTo(weakSelf).offset(-50)
                make.height.width.equalTo(50)
            }
        }
        
        let dayLabel = KACommonLabel()
        dayLabel.setUpLabel("距结算日")
        dayLabel.setDownLabel("1")
        self.dayLabel = dayLabel
        self.addSubview(dayLabel)
        dayLabel.snp_makeConstraints {[weak self](make) in
            if let weakSelf = self{
                make.trailing.equalTo(weakSelf).offset(-50)
                make.bottom.equalTo(weakSelf).offset(-50)
                make.height.width.equalTo(50)
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
                make.bottom.equalTo(weakSelf).offset(-120)
                make.width.height.equalTo(60)
            }
        }
        
        let budgetBottle = UIImageView()
        budgetBottle.image = UIImage(named: "bottle")
        self.addSubview(budgetBottle)
        budgetBottle.snp_makeConstraints{[weak self](make) in
            if let weakSelf = self{
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.bottom.equalTo(setBtn.snp_top).offset(10)
                make.top.equalTo(mbLabel.snp_bottom).offset(10)
                make.leading.right.equalTo(80)
            }
        }
    }
    
    func pressSetBtn(btn:UIButton) {
        if let delegate = delegate{
            delegate.pressSettingBtnWithBudgetView(self)
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
    }
    

}
