//
//  ComputeBoardView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let CostBarTimeHeight: CGFloat = 20.0

private let costBarLeftIconMargin: CGFloat = 12
private let costBarLeftIconWidth:CGFloat = 48

private let costBarTitleMarginLeft: CGFloat = 12+48+12
private let costBarTitleWidth:CGFloat = 60

private let sepLineWidth: CGFloat = 1

typealias computedResultResponder = (Float)->Void

class ComputeBoardView: UIView {
    
    private let lastBtnTitle = ["收/支", "+", "OK"]
    private let btnTitle = [["1", "4", "7", "C"], ["2", "5", "8", "0"], ["3", "6", "9", "."]]
    
    private let CostBarHeight: CGFloat = 72.0
    
    //存放上一次的累加值
    private var result:Float = 0
    private var summand: Float = 0
    private var addend: Float = 0
    private var decimal:Float = 0
    private var numOfDecimal:Int = 0
    private var numOfInt = 0
    private var pressAdd = false
    private var pressEqual = false
    private var pressDot = false
    
    var costBarTitle:UILabel?
    var title:String{
        get{
            return costBarTitle?.text ?? ""
        }
        set(newValue){
            costBarTitle?.text = newValue
        }
    }
    var costBarMoney:UILabel!
    var money:String{
        get{
            return costBarMoney.text ?? ""
        }
        set(newValue){
            costBarMoney.text = newValue
        }
    }
    var costBarLeftIcon:UIImageView?
    var icon:UIImage? {
        get{
            return costBarLeftIcon?.image
        }
        set(newValue){
            costBarLeftIcon?.image = newValue
        }
    }
    var costBarTime:UILabel?
    var time:String{
        get{
            return costBarTime?.text ?? ""
        }
        set(newValue){
            costBarTime?.text = newValue
        }
    }
    
    var computedResult:computedResultResponder?{
        get{
            return computeLogic.computedMoney
        }
        set(newValue){
            computeLogic.computedMoney = newValue
        }
    }
    
    var pressOK:(()->Void)?{
        get{
            return computeLogic.pressOKClosure
        }
        set(newValue){
            computeLogic.pressOKClosure = newValue
        }
    }
    
    var pressIncomeAndCost:(()->Void)?{
        get{
            return computeLogic.pressIncomeAndCostClosure
        }
        set(newValue){
            computeLogic.pressIncomeAndCostClosure = newValue
        }
    }
    
    weak var delegate:ChooseItemVC?
    let computeLogic:ComputedBoardLogic
    
    
    //自定义初始化方法
    override init(frame: CGRect) {
        computeLogic = ComputedBoardLogic()
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        
    }
    
    func clickComputedBtn(btn:UIButton){
        let value = btn.currentTitle ?? ""
        computeLogic.Compute(value)
    }
    
    func shakeCostBarMoney(){
        let shakeAnimation = CAKeyframeAnimation(keyPath: "position.x")
        shakeAnimation.values = [0, 10, -10, 10, 0]
        shakeAnimation.keyTimes = [0, 1/6.0, 3/6.0, 5/6.0, 1]
        shakeAnimation.duration = 0.4
        shakeAnimation.additive = true
        costBarMoney.layer.addAnimation(shakeAnimation, forKey: "CostBarMoneyShake")
    }
    
    func setup(){
        let width = self.frame.width
        let ComputedBoardHeight = self.frame.height - CostBarHeight
        
        //生成消费金额栏
        setupCostBar(CGRectMake(0, 0, width, CostBarHeight))
        //生成前三列button
        setUpThreeColunmBtn(CGRectMake(0, CostBarHeight, width, ComputedBoardHeight))
        //生成最后一列button
        setUpLastColunmBtn(CGRectMake(0, CostBarHeight, width, ComputedBoardHeight))
        //生成横竖分割线
        setUpSepLine(CGRectMake(0, CostBarHeight, width, ComputedBoardHeight))
    }

    //分割线时间标签
    private func setupCostBarTime(frame: CGRect)->UILabel{
        
        //时间标签
        let costBarTime = UILabel(frame: CGRectMake(frame.width/3, -CostBarTimeHeight/2, frame.width/3, CostBarTimeHeight))
        costBarTime.textAlignment = .Center
        costBarTime.backgroundColor = UIColor.whiteColor()
        costBarTime.layer.cornerRadius = 10
        costBarTime.layer.borderWidth = sepLineWidth
        costBarTime.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7).CGColor
        costBarTime.font = UIFont(name: costBarTime.font.fontName, size: 14)
        costBarTime.textColor = UIColor.blackColor()
        self.costBarTime = costBarTime
        
        return costBarTime
    }
    //最左边图标
    private func setupCostBarLeftIcon(frame:CGRect)->UIImageView {
        let costBarLeftIcon = UIImageView(frame: CGRectMake(costBarLeftIconMargin, costBarLeftIconMargin, costBarLeftIconWidth, costBarLeftIconWidth))
        self.costBarLeftIcon = costBarLeftIcon
        return costBarLeftIcon
    }
    //标题
    private func setupCostBarTitle(frame: CGRect)->UILabel{
        let costBarTitle = UILabel(frame: CGRectMake(costBarTitleMarginLeft, 0, costBarTitleWidth, frame.height))
        costBarTitle.font = UIFont(name: "Arial", size: 20)
        self.costBarTitle = costBarTitle
        return costBarTitle
    }
    //右边金额显示
    private func setupCostBarMoney(frame: CGRect)->UILabel{
        let costBarMoney = UILabel(frame: CGRectMake(costBarTitleMarginLeft + costBarTitleWidth + 10, 0,
            frame.width - costBarTitleMarginLeft - costBarTitleWidth - 20 , frame.height))
        costBarMoney.textAlignment = .Right
        costBarMoney.font = UIFont(name: "Arial", size: 35)
        self.costBarMoney = costBarMoney
        return costBarMoney
    }
    
    private func setupCostBar(frame:CGRect){
        
        let costBarBackground = UIView(frame: frame)
        //CostBar分割线
        let costBarSepLine = UIView(frame: CGRectMake(0, 0, frame.width, sepLineWidth))
        costBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        //分割线时间标签
        costBarTime = setupCostBarTime(frame)
        //最左边图标
        costBarLeftIcon = setupCostBarLeftIcon(frame)
        //标题
        costBarTitle = setupCostBarTitle(frame)
        //右边金额显示
        costBarMoney = setupCostBarMoney(frame)
        
        costBarBackground.addSubview(costBarSepLine)
        costBarBackground.addSubview(costBarTime!)
        costBarBackground.addSubview(costBarLeftIcon!)
        costBarBackground.addSubview(costBarTitle!)
        costBarBackground.addSubview(costBarMoney!)
        self.addSubview(costBarBackground)
    }
    //生成前三列button
    private func setUpThreeColunmBtn(frame: CGRect){
        let btnWidth = frame.width/4
        let btnHeight = frame.height/4
        let btnY = frame.origin.y
        for var col = 0; col < btnTitle.count; ++col{
            for var row = 0; row < btnTitle[col].count; ++row{
                let btnFrame = CGRectMake(CGFloat(col) * btnWidth, CGFloat(row) * btnHeight + btnY, btnWidth, btnHeight)
                let btn = createBtn(btnFrame, title: btnTitle[col][row],normalImage: "btn_num_pressed",highlightedImage:"btn_num")
                self.addSubview(btn)
            }
        }
    }
    //生成最后一列button
    private func setUpLastColunmBtn(frame:CGRect){
        
        let btnWidth = frame.width/4
        let btnHeight = frame.height/4
        let btnY = frame.origin.y
        for var row = 0; row < lastBtnTitle.count; ++row{
            let btnFrame = CGRectMake(CGFloat(3) * btnWidth, CGFloat(row) * btnHeight + btnY , btnWidth, row == 2 ? btnHeight * 2: btnHeight)
            let btn = createBtn(btnFrame,title: lastBtnTitle[row],normalImage: "btn_num_pressed",highlightedImage: "btn_num")
            if row == 2 {
                computeLogic.okBtn = btn
//                okBtn = btn
            }
            self.addSubview(btn)
        }
    }
    //生成横竖分割线
    private func setUpSepLine(frame: CGRect){
        let boardWidth = frame.width
        let boardHeight = frame.height
        
        let btnWidth = boardWidth/4
        let btnHeight = boardHeight/4
        let btnY = frame.origin.y
        
        //行分割线
        for var row = 0; row < 3; ++row{
            let rowLine = UIView(frame: CGRectMake(0, CGFloat(row + 1) * btnHeight + btnY, row == 2 ? boardWidth - btnWidth : boardWidth, sepLineWidth))
            rowLine.backgroundColor = UIColor.whiteColor()
            self.addSubview(rowLine)
        }
        //竖分割线
        for var col = 0; col < 3; ++col{
            let colLine = UIView(frame: CGRectMake(CGFloat(col + 1) * btnWidth, btnY, sepLineWidth, boardHeight))
            colLine.backgroundColor = UIColor.whiteColor()
            self.addSubview(colLine)
        }
    }
    
    private func createBtn(frame: CGRect, title:String, normalImage:String, highlightedImage: String) -> UIButton{
        let btn = UIButton(frame: frame)
        btn.setTitle(title, forState: .Normal)
        btn.titleLabel?.textAlignment = .Center
        btn.titleLabel?.font = UIFont(name: "Arial", size: 25)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: normalImage), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: highlightedImage), forState: .Highlighted)
        btn.addTarget(self, action: "clickComputedBtn:", forControlEvents: .TouchUpInside)
        return btn
    }
    
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
