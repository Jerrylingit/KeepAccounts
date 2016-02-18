//
//  ComputeBoardView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ComputeBoardView: UIView {
    
    
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){

    }
    
    override func layoutSubviews() {
        let boardWidth = self.frame.size.width
        let boardHeight = self.frame.size.height
        
        let btnWidth = boardWidth/4
        let btnHeight = boardHeight/4
        
        let sepLineWidth: CGFloat = 1
        
        let btnTitle = [["1", "4", "7", "清零"], ["2", "5", "8", "0"], ["3", "6", "9", "."]]
        let lastBtnTitle = ["收/支", "+", "OK"]
        //生成前三列button
        for var col = 0; col < btnTitle.count; ++col{
            for var row = 0; row < btnTitle[col].count; ++row{
                let btn = UIButton(frame: CGRectMake(CGFloat(col) * btnWidth, CGFloat(row) * btnHeight, btnWidth, btnHeight))
                btn.setTitle(btnTitle[col][row], forState: .Normal)
                btn.titleLabel?.font = UIFont(name: "Courier New", size: 20)
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn.setBackgroundImage(UIImage(named: "btn_num_pressed"), forState: .Normal)
                btn.setBackgroundImage(UIImage(named: "btn_num"), forState: .Highlighted)
                self.addSubview(btn)
            }
        }
        //生成最后一列button
        for var row = 0; row < lastBtnTitle.count; ++row{
            let btn = UIButton(frame: CGRectMake(CGFloat(3) * btnWidth, CGFloat(row) * btnHeight, btnWidth, row == 2 ? btnHeight * 2: btnHeight))
            btn.setTitle(lastBtnTitle[row], forState: .Normal)
            btn.titleLabel?.font = UIFont(name: "Courier New", size: 20)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btn.setBackgroundImage(UIImage(named: "btn_num_pressed"), forState: .Normal)
            btn.setBackgroundImage(UIImage(named: "btn_num"), forState: .Highlighted)
            self.addSubview(btn)
        }
        
        //行分割线
        for var row = 0; row < 3; ++row{
            let rowLine = UIView(frame: CGRectMake(0, CGFloat(row + 1) * btnHeight, row == 2 ? boardWidth - btnWidth : boardWidth, sepLineWidth))
            rowLine.backgroundColor = UIColor.whiteColor()
            self.addSubview(rowLine)
        }
        //竖分割线
        for var col = 0; col < 3; ++col{
            let colLine = UIView(frame: CGRectMake(CGFloat(col + 1) * btnWidth, 0, sepLineWidth, boardHeight))
            colLine.backgroundColor = UIColor.whiteColor()
            self.addSubview(colLine)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
