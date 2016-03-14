//
//  customDatePickerView.swift
//  KeepAccounts
//
//  Created by admin on 16/3/14.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

typealias cancelResponder = () -> ()
typealias sureResponder = ()->()

class CustomDatePicker:UIView {
    
    var initDate:NSDate?
    var pickedValue:NSDate?
    var cancelCallback: cancelResponder?
    var sureCallback :sureResponder?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(frame:CGRect, date:NSDate, cancel:cancelResponder?, sure:sureResponder?){
        self.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        let tap = UITapGestureRecognizer(target: self, action: "tapBgView:")
        self.addGestureRecognizer(tap)
        self.initDate = date
//        self.cancelCallback = cancel
//        self.sureCallback = sure
        setupView(frame)
    }

    func setupView(frame:CGRect){
        let bgWidth = frame.width * 0.8
        let bgHeight = frame.height * 0.5
        let datePickerHeight = bgHeight - 60
        let btnWidth = bgWidth / 2
        //新建datepicker
        let bgView = UIView(frame: CGRectMake(0, 0, bgWidth, bgHeight))
        bgView.backgroundColor = UIColor.whiteColor()
        
        let datePicker = UIDatePicker(frame: CGRectMake(0, 0, bgWidth, datePickerHeight))
        datePicker.setDate(initDate ?? NSDate(), animated: false)
        datePicker.addTarget(self, action: "chooseValue:", forControlEvents: UIControlEvents.ValueChanged)
        
        let cancelBtn = createBtnsWith(CGRectMake(0, datePickerHeight, btnWidth, 60), title: "取消", action: "clickCancel:")
        
        let OKBtn = createBtnsWith(CGRectMake(btnWidth, datePickerHeight, btnWidth, 60), title: "确定", action: "clickOK:")
        
        //加到self上
        bgView.addSubview(cancelBtn)
        bgView.addSubview(OKBtn)
        bgView.addSubview(datePicker)
        self.addSubview(bgView)
    }
    private func chooseValue(value:NSDate){
        pickedValue = value
    }
    
    private func tapBgView(sender:AnyObject){
        
    }
    private func clickCancel(sender:AnyObject){
        
    }
    private func clickOK(sender:AnyObject){
        
    }
    private func createBtnsWith(frame:CGRect, title:String, action:Selector ) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: "clickCancel:", forControlEvents: .TouchUpInside)
        return btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}