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
private let AllBtnMarginLeft = 40 * ScreenWidthRatio
private let BtnMarginRight = 25 * ScreenWidthRatio


class OperateAccountBookView: UIView {
    
    
    var cancelBlock:(()->Void)?
    var deleteBlock:(()->Void)?
    var editBlock:(()->Void)?
    
    var cancelBtn:UIView!
    var editBtn:UIView!
    var deleteBtn:UIView!
    
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
    
    func showBtnAnimation(){
        UIView.animateWithDuration(0.2){
            self.cancelBtn.centerY = self.cancelBtn.centerY - BgViewHeight
        }
        UIView.animateWithDuration(0.25){
            self.deleteBtn.centerY = self.deleteBtn.centerY - BgViewHeight
        }
        UIView.animateWithDuration(0.3){
            self.editBtn.centerY = self.editBtn.centerY - BgViewHeight
        }
        
    }
    func hideBtnAnimation(){
        self.cancelBtn.centerY = self.cancelBtn.centerY + BgViewHeight
        self.deleteBtn.centerY = self.deleteBtn.centerY + BgViewHeight
        self.editBtn.centerY = self.editBtn.centerY + BgViewHeight
    }
    
    //MARK: - setup
    private func setup(frame:CGRect){
        
        //背景图
        let bgViewY = frame.height - BgViewHeight
        let bgView = UIView(frame: CGRectMake(0, bgViewY, frame.width, BgViewHeight))
        bgView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        //按钮
        let cancelBtn = generateBtn(0, title: "取消", imageName: "menu_operation_cancel", action: "cancelPress:")
        self.cancelBtn = cancelBtn
        let deleteBtn = generateBtn(1, title: "删除", imageName: "menu_operation_delete", action: "deletePress:")
        self.deleteBtn = deleteBtn
        let editBtn = generateBtn(2, title: "修改", imageName: "menu_operation_edit", action: "editPress:")
        self.editBtn = editBtn
        
        bgView.addSubview(editBtn)
        bgView.addSubview(deleteBtn)
        bgView.addSubview(cancelBtn)
        self.addSubview(bgView)
    }
    private func generateBtn(index:Int , title:String, imageName:String, action:Selector)->UIView {
        let btnY = 12 * ScreenWidthRatio + BgViewHeight
        let bgWidth = (frame.width - 25.6 * ScreenWidthRatio - 2 * AllBtnMarginLeft - 2 * BtnMarginRight) / 3
        let offsetX = AllBtnMarginLeft + (bgWidth + BtnMarginRight) * CGFloat(index)
        let bgHeight = (bgWidth / 2) * 3 + 10 * ScreenWidthRatio
        
        let bgView = UIView(frame: CGRectMake(offsetX, btnY, bgWidth, bgHeight))
        //按钮
        let btn = UIButton(frame: CGRectMake(0, 0, bgWidth, bgWidth))
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        
        let labelHeight = bgWidth / 2
        let labelY = bgWidth + 10 * ScreenWidthRatio
        //标题
        let label = UILabel(frame: CGRectMake(0, labelY, bgWidth, labelHeight))
        label.text = title
        label.textAlignment = .Center
        label.font = UIFont(name: "Arial", size: 18)
        label.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        bgView.addSubview(btn)
        bgView.addSubview(label)
        return bgView
    }
    
    //MARK: - click action
    func tapBgView(sender:UITapGestureRecognizer){
        if let cancelBlock = cancelBlock{
            cancelBlock()
        }
    }
    func cancelPress(sender:UIButton){
        if let cancelBlock = cancelBlock{
            cancelBlock()
        }
    }
    func deletePress(sender:UIButton){
        if let deleteBlock = deleteBlock{
            deleteBlock()
        }
    }
    func editPress(sender:UIButton){
        if let editBlock = editBlock{
            editBlock()
        }
    }
}
