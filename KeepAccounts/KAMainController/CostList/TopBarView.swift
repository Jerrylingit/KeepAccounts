//
//  TopBarView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class TopBarView: UIView {
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        let TopBarWidth = self.frame.width
        let TopBarHeight = self.frame.height
        
        //返回
        let topBarBack = UIButton(frame: CGRectMake(20, 10, 22, 22))
        topBarBack.setImage(UIImage(named: "back_light"), forState: UIControlState.Normal)
        //改时间
        let topBarChangeTime = createTopBarBtn(num: 1, title: "改时间", target: self, action: "ChangeTimePress:")
        
        //写备注
        let topBarAddRemark = createTopBarBtn(num: 2, title: "写备注", target: self, action: "AddRemarkPress:")
        
        //加照片
        let topBarTakePhoto = createTopBarBtn(num: 3, title: "加照片", target: self, action: "TakePhotoPress:")
        
        //分割线
        let topBarSepLine = UIView(frame: CGRectMake(0, TopBarHeight - 0.5, TopBarWidth, 0.5))
        topBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        
        //添加到topBar上
        self.addSubview(topBarBack)
        self.addSubview(topBarChangeTime)
        self.addSubview(topBarAddRemark)
        self.addSubview(topBarTakePhoto)
        self.addSubview(topBarSepLine)
    }
    
    override func layoutSubviews() {
        

    }
    
    private func createTopBarBtn(num number:CGFloat, title:String, target:AnyObject, action:Selector) -> UIButton{
        
        let btn = UIButton(frame: CGRectMake(self.frame.width/4 * number, 0, self.frame.width/4, self.frame.height))
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont(name: "Courier New", size: 14)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return btn
    }
    
    func ChangeTimePress(btn: UIButton?){
        
    }
    func AddRemarkPress(btn: UIButton?){
        
    }
    func TakePhotoPress(btn: UIButton?){
        
    }

}




