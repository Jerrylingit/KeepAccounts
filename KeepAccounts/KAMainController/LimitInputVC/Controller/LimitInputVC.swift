//
//  LimitInputVC.swift
//  KeepAccounts
//
//  Created by admin on 16/3/15.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

protocol LimitInputViewProtocol{
    func clickBack()
}

class LimitInputVC: UIViewController {
    var limitInput:LimitInputView?
    var initVCDate:String?
    var text:String {
        get{
            return self.limitInput?.textInput?.text ?? ""
        }
        set(newValue){
            self.limitInput?.textInput?.text = newValue
        }
    }
    var placehoder:String = "记录花销"
    var keyboardIsShow:Bool = false
    var completeInput:completeRespond?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object:self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: self.view.window)
        setup()
    }
    func keyboardWillShow(notification:NSNotification){
        if keyboardIsShow == true {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            var frame = limitInput?.characterNum?.frame
            frame?.origin.y = (frame?.origin.y)! - keyboardSize.height
            limitInput?.characterNum?.frame = frame!
        }
        keyboardIsShow = true
    }
    func keyboardWillHide(notification:NSNotification){
        if keyboardIsShow == false{
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            var frame = limitInput?.characterNum?.frame
            frame?.origin.y = (frame?.origin.y)! + keyboardSize.height
            limitInput?.characterNum?.frame = frame!
        }
        keyboardIsShow = false
    }
    
    private func setup(){
        let limitInput = LimitInputView(frame: self.view.frame)
        limitInput.delegate = self
        limitInput.initViewDate = initVCDate
        limitInput.placehoder = placehoder
        limitInput.completeInput = self.completeInput
        self.limitInput = limitInput
        self.view.addSubview(limitInput)
    }
}

extension LimitInputVC: LimitInputViewProtocol{
    func clickBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
