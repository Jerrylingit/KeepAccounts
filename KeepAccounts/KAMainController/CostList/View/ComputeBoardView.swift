//
//  ComputeBoardView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ComputeBoardView: UIView {
    
    private let sepLineWidth: CGFloat = 1
    private let lastBtnTitle = ["收/支", "+", "OK"]
    private let btnTitle = [["1", "4", "7", "C"], ["2", "5", "8", "0"], ["3", "6", "9", "."]]
    
    private let CostBarHeight: CGFloat = 72.0
    
    //存放上一次的累加值
    private var summand: Float = 0
    private var addend: Float = 0
    private var decimal:Float = 0
    private var numOfDecimal:Int = 0
    private var numOfInt = 0
    private var pressAdd = false
    private var pressEqual = false
    private var pressDot = false
    
    var title = UILabel()
    var iconView :UIImageView?
    var money = UILabel()
    var okBtn = UIButton()
    var iconName = String()
    var icon : UIImage?{
        get{
            return iconView?.image
        }
        set(newIcon){
            iconView?.image = newIcon
        }
    }
    
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
    
    override func layoutSubviews() {

    }
    
    private func setupCostBar(frame:CGRect){
        let costBar = CostBarView(frame: frame)
        title = costBar.title
        iconView = costBar.iconView
        money = costBar.money
        self.addSubview(costBar)
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
                okBtn = btn
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
    
    

    private func outOfDocMode(){
        pressDot = false
        numOfDecimal = 0
    }
    private func pressOK(){
        let item = AccountItem()
        item.money = money.text ?? ""
        item.iconTitle = title.text ?? ""
        item.iconName = iconName
        AccoutDB.insertData(item);
        
    }
    private func pressIncomeAndCost(){
        let db = AccoutDB.getDB()
        db.open()
        let count =  Int(db.intForQuery("SELECT COUNT(ID) FROM ACCOUNTMODEL"))
        db.close()
        if count != 0{
            for i in 1...count{
                let item = AccoutDB.selectData(i)
                print(item.money)
            }
        }

    }
    
    func clickComputedBtn(btn:UIButton){
        
        let value = btn.currentTitle ?? ""
        switch value {
        case "1","2", "3", "4", "5", "6", "7", "8", "9", "0" :
            //点击了+号
            if pressAdd {
                pressAdd = false
                addend = 0
            }
            //计算完一次
            if pressEqual {
                pressEqual = false
                addend = 0
            }
            
            if pressDot {
                numOfDecimal++
                
                if numOfDecimal <= 2 {
                    decimal = Float(value)! / Float(pow(10.0, Double(numOfDecimal)))
                    money.text = NSString(format: "%.2f", (addend + decimal) ) as String
                }
                else{
                    //超过两位小数
                }
            }
            else{
                numOfInt++
                if numOfInt <= 7 {
                    money.text = NSString(format: "%.2f", (addend * 10.0 + Float(value)!) ) as String
                }
                else{
                    //超过7位
                }
                
            }
            
            addend = Float(money.text!)!
            
        case "收/支":
            pressIncomeAndCost()
        case "C" :
            summand = 0
            addend = 0
            numOfInt = 0
            outOfDocMode()
            money.text = "0.00"
            okBtn.setTitle("OK", forState: .Normal)
        case "OK" :
            pressOK()
        case ".":
            pressDot = true
        case "+":
            pressAdd = true
            numOfInt = 0
            outOfDocMode()
            if addend != 0 {
                summand += addend
                addend = 0
            }
            money.text = NSString(format: "%.2f", summand) as String
            okBtn.setTitle("=", forState: .Normal)
            
        case "=":
            numOfInt = 0
            outOfDocMode()
            pressEqual = true
            okBtn.setTitle("OK", forState: .Normal)
            if addend != 0 {
                summand += addend
                addend = 0
            }
            money.text = NSString(format: "%.2f", summand) as String
        default:
            print("Error")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
