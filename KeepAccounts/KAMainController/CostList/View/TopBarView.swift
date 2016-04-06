//
//  TopBarView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class TopBarView: UIView {
    
    weak var delegate:ChooseItemVC?
    var topBarChangeTime:UIButton?
    var topBarAddRemark:UIButton?
    var topBarTakePhoto:UIButton?
    var topBarTakePhotoImage:UIButton?
    var topBarInitPhoto:UIImage?{
        get{
            return topBarTakePhotoImage?.imageView?.image
        }
        set(newValue){
            topBarTakePhotoImage?.setImage(newValue, forState: .Normal)
            topBarTakePhotoImage?.hidden = false
            topBarTakePhoto?.hidden = true
        }
    }
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
        topBarBack.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        //改时间
        let topBarChangeTime = createTopBarBtn(num: 1, title: "改时间", target: self, action: "ChangeTimePress:")
        self.topBarChangeTime = topBarChangeTime
        
        //写备注
        let topBarAddRemark = createTopBarBtn(num: 2, title: "写备注", target: self, action: "AddRemarkPress:")
        self.topBarAddRemark = topBarAddRemark
        
        //加照片
        let topBarTakePhoto = createTopBarBtn(num: 3, title: "加照片", target: self, action: "TakePhotoPress:")
        self.topBarTakePhoto = topBarTakePhoto
        
        let topBarTakePhotoImage = UIButton(frame: CGRectMake(self.frame.width/4 * 3 + 25 , 5, self.frame.height - 10, self.frame.height - 10 ))
        topBarTakePhotoImage.layer.cornerRadius = (self.frame.height - 10) / 2
        topBarTakePhotoImage.clipsToBounds = true
        topBarTakePhotoImage.hidden = true
        topBarTakePhotoImage.addTarget(self, action: "TakePhotoPress:", forControlEvents: .TouchUpInside)
        self.topBarTakePhotoImage = topBarTakePhotoImage
        
        //分割线
        let topBarSepLine = UIView(frame: CGRectMake(0, TopBarHeight - 0.5, TopBarWidth, 0.5))
        topBarSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        
        //添加到topBar上
        self.addSubview(topBarBack)
        self.addSubview(topBarChangeTime)
        self.addSubview(topBarAddRemark)
        self.addSubview(topBarTakePhoto)
        self.addSubview(topBarTakePhotoImage)
        self.addSubview(topBarSepLine)
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
    
    func back(sender:AnyObject!){
        if delegate?.respondsToSelector("clickBack:") != nil{
            delegate?.clickBack(sender)
        }
    }
    
    func ChangeTimePress(btn: UIButton?){
        if delegate?.respondsToSelector("clickTime") != nil{
            delegate?.clickTime()
        }
    }
    func AddRemarkPress(btn: UIButton?){
        if delegate?.respondsToSelector("clickRemark") != nil{
            delegate?.clickRemark()
        }
    }
    func TakePhotoPress(btn: UIButton?){
        if delegate?.respondsToSelector("clickRemark") != nil{
            delegate?.clickPhoto()
        }
    }

}