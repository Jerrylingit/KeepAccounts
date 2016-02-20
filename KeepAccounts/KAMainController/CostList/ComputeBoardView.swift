//
//  ComputeBoardView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ComputeBoardView: UIView {
    
    let sepLineWidth: CGFloat = 1
    let lastBtnTitle = ["收/支", "+", "OK"]
    let btnTitle = [["1", "4", "7", "清零"], ["2", "5", "8", "0"], ["3", "6", "9", "."]]
    
    let CostBarHeight: CGFloat = 72.0
    
    
    var title = UILabel()
    var icon :UIImage? = UIImage()
    var money = UILabel()
    var okBtn = UIButton()
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){

    }
    
    override func layoutSubviews() {
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
    
    private func setupCostBar(frame:CGRect){
        let costBar = CostBarView(frame: frame)
        title = costBar.title
        icon = costBar.icon
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
        btn.titleLabel?.font = UIFont(name: "Courier New", size: 25)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: normalImage), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: highlightedImage), forState: .Highlighted)
        btn.addTarget(self, action: "clickComputedBtn:", forControlEvents: .TouchUpInside)
        return btn
    }
    
    func clickComputedBtn(btn:UIButton){
        
        let value = btn.titleLabel!.text!
        switch value {
        case "1","2", "3", "4", "5", "6", "7", "8", "9", "0" :
            print(value)
        case "收/支":
            print(value)
        case "清零" :
            print(value)
        case "OK" :
            print(value)
        case ".":
            print(value)
        case "+":
            print(value)
            okBtn.titleLabel?.text = "="
        case "=":
            print(value)
            okBtn.titleLabel?.text = "OK"
        default:
            print("Error")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
