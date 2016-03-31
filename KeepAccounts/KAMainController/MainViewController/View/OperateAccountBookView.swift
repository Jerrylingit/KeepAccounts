//
//  OperateAccountBookView.swift
//  KeepAccounts
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let ScreenWidthRatio = UIScreen.mainScreen().bounds.width / 320
private let ScreenHeightRatio = UIScreen.mainScreen().bounds.height / 480

private let BgViewHeight = 100 * ScreenHeightRatio
private let AllBtnMargin = 40 * ScreenWidthRatio


class OperateAccountBookView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.0)
        let tap = UITapGestureRecognizer(target: self, action: "tapBgView:")
        self.addGestureRecognizer(tap)
        setup(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(frame:CGRect){
        
        //背景图
        let bgViewY = frame.height - BgViewHeight
        let bgView = UIView(frame: CGRectMake(0, bgViewY, frame.width, BgViewHeight))
        bgView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        //按钮
        let btnY = bgViewY + 15 * ScreenWidthRatio
        let btnWidth = (frame.width - 25.6 * ScreenWidthRatio - 2 * AllBtnMargin) / 3
        let cancelBtn = UIButton(frame: CGRectMake(AllBtnMargin, btnY, btnWidth, btnWidth))
        cancelBtn.backgroundColor = UIColor.blackColor()
        //标题
        
        bgView.addSubview(cancelBtn)
        self.addSubview(bgView)
    }
    
    //MARK: - click action
    func tapBgView(sender:UITapGestureRecognizer){
        
    }
}
