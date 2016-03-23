//
//  LimitInputView.swift
//  KeepAccounts
//
//  Created by admin on 16/3/15.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let StatusBarHeight:CGFloat = 20
private let TopBarHeight:CGFloat = 44
private let DateBarHeight:CGFloat = 30
private let TextFieldHeight:CGFloat = 180
private let MaxLengthOfRemark = 40

typealias completeRespond = (String)->()

class LimitInputView: UIView {
    
    var delegate:LimitInputVC?
    var initViewDate:String?
    var dateLabel:UILabel?
    var characterNum:UILabel?
    var currentLengthOfRemark:Int?
    var completeInput:completeRespond?
    
    var placehoder:String = "记录花销"
    var textInput:UITextView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let DateBarY = TopBarHeight + StatusBarHeight
        let TextFieldY = DateBarY + DateBarHeight
        //顶部栏
        setupTopBar(CGRectMake(0, StatusBarHeight, frame.width, TopBarHeight))
        //日期
        setupDateBar(CGRectMake(20, DateBarY, frame.width, DateBarHeight))
        //输入区域
        setupTextField(CGRectMake(20, TextFieldY, frame.width - 40, TextFieldHeight))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dateLabel?.text = initViewDate
    }
    private func setupTopBar(frame:CGRect){
        //topbar
        let topBar = UIView(frame: frame)
        //返回按钮
        let topBarBack = UIButton(frame: CGRectMake(20, 10, 22, 22))
        topBarBack.setImage(UIImage(named: "back_light"), forState: UIControlState.Normal)
        topBarBack.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        //中间标题
        let title = UILabel(frame: CGRectMake(0, 0, 50, 40))
        title.text = "备注"
        title.center = CGPointMake(frame.width / 2, 20)
        
        //分割线
        let topBarSepLine = UIView(frame: CGRectMake(0, frame.height - 0.5, frame.width, 0.5))
        topBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        
        //添加子view
        topBar.addSubview(title)
        topBar.addSubview(topBarBack)
        topBar.addSubview(topBarSepLine)
        self.addSubview(topBar)
    }
    private func setupDateBar(frame:CGRect){
        let dateLabel = UILabel(frame: frame)
        dateLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        dateLabel.font = UIFont(name: "Courier", size: 14)
        self.dateLabel = dateLabel
        self.addSubview(dateLabel)
    }
    private func setupTextField(frame:CGRect){
        let textInput = UITextView(frame: frame)
        textInput.font = UIFont(name: "Arial", size: 20)
        textInput.keyboardType = .Default
        textInput.returnKeyType = .Done
        textInput.text = placehoder
        textInput.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        textInput.delegate = self;
        self.textInput = textInput
        let characterNum = UILabel(frame: CGRectMake(10, self.frame.height - 60, 80, 40))
        characterNum.text = "0/40"
        self.characterNum = characterNum
        self.addSubview(characterNum)
        self.addSubview(textInput)
    }
    
    //MARK: - action
    func back(sender:AnyObject){
        if delegate?.respondsToSelector("clickBack") != nil{
            delegate?.clickBack()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension LimitInputView:UITextViewDelegate{
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placehoder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placehoder
            textView.textColor = UIColor.grayColor()
        }
        textView.resignFirstResponder()
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            if textView.text.length > MaxLengthOfRemark{
                let alertView = UIAlertView(title: "提示", message: "请不要超过40字", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles:
                    "确定")
                alertView.show()
            }
            else{
                self.back(self)
                if let complete = completeInput{
                    complete(textView.text)
                }
                textView.resignFirstResponder()
            }
            return false
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        if textView.text.length <= MaxLengthOfRemark{
            characterNum?.textColor = UIColor.blackColor()
        }
        else{
            characterNum?.textColor = UIColor.redColor()
        }
        currentLengthOfRemark = textView.text.length
        characterNum?.text = "\(currentLengthOfRemark!)/40"

    }
}

