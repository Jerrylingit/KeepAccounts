//
//  customDatePickerView.swift
//  KeepAccounts
//
//  Created by admin on 16/3/14.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

typealias cancelResponder = () -> ()
typealias sureResponder = (NSDate)->()

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
        self.pickedValue = date
        setupView(frame)
    }

    func setupView(frame:CGRect){
        let bgWidth = frame.width
        let bgHeight = frame.height * 0.5
        let datePickerHeight = bgHeight - 60
        let btnWidth = bgWidth / 2
        //新建datepicker
        let bgView = UIView(frame: CGRectMake(0, 0, bgWidth, bgHeight))
        bgView.backgroundColor = UIColor.whiteColor()
        bgView.center = self.center
        //选择器
        let datePicker = UIDatePicker(frame: CGRectMake(0, 0, bgWidth, datePickerHeight))
        datePicker.setDate(initDate ?? NSDate(), animated: false)
        datePicker.addTarget(self, action: "chooseValue:", forControlEvents:.ValueChanged)
        //分割线
        let sepLine = UIView(frame: CGRectMake(0, datePickerHeight, bgWidth, 1))
        sepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        let btnSepLine = UIView(frame: CGRectMake(btnWidth, datePickerHeight, 1, 60))
        btnSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        //底部按钮
        let cancelBtn = createBtnsWith(CGRectMake(0, datePickerHeight, btnWidth, 60), title: "取消", action: "clickCancel:")
        let OKBtn = createBtnsWith(CGRectMake(btnWidth, datePickerHeight, btnWidth, 60), title: "确定", action: "clickOK:")
        
        //加到self上
        bgView.addSubview(cancelBtn)
        bgView.addSubview(btnSepLine)
        bgView.addSubview(sepLine)
        bgView.addSubview(OKBtn)
        bgView.addSubview(datePicker)
        self.addSubview(bgView)
    }
    func chooseValue(datePicker:UIDatePicker){
        pickedValue = datePicker.date
    }
    
    func tapBgView(sender:AnyObject){
        if let cancel = self.cancelCallback {
            cancel()
        }
    }
    func clickCancel(sender:AnyObject){
        if let cancel = self.cancelCallback {
            cancel()
        }
    }
    func clickOK(sender:AnyObject){
        if let sure = self.sureCallback {
            sure(self.pickedValue ?? NSDate())
            if let cancel = self.cancelCallback {
                cancel()
            }
        }
    }
    private func createBtnsWith(frame:CGRect, title:String, action:Selector ) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}