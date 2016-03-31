//
//  CustomAlertView.swift
//  KeepAccounts
//
//  Created by admin on 16/3/31.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let ScreenHeightRatio = UIScreen.mainScreen().bounds.height / 480

private let BgMarginLeft:CGFloat = 30
private let BgMarginRight:CGFloat = 30
private let BgMarginTop:CGFloat = 100
private let BgHeight:CGFloat = 170 * ScreenHeightRatio

private let TitleTextHeight:CGFloat = 50 * ScreenHeightRatio
private let ImageViewHeight:CGFloat = 70 * ScreenHeightRatio
private let ImageHeight:CGFloat = 50 * ScreenHeightRatio
private let BtnHeight:CGFloat = 50 * ScreenHeightRatio

private let ImageMarginTop:CGFloat = 10
private let ImageMarginLeft:CGFloat = 10

class CustomAlertView: UIView {
    
    var cancelBlock:(()->Void)?
    var sureBlock:((String, String)->Void)?
    
    //初始化
    private var titleText:UITextField?
    //标题
    var title:String{
        get{
            if let title = titleText?.text{
                return title != "" ? title : "新建账本"
            }
            else{
                return "新建账本"
            }
        }
        set(newValue){
            titleText?.text = newValue
        }
    }
    var imageArray:[FlagBtn] = []
    //初始化选中背景图,传入图片名
    var initChooseImage:String{
        get{
            for i in 0...imageArray.count - 1{
                if imageArray[i].showFlag == true{
                    return "book_cover_\(i)"
                }
            }
            return "book_cover_0"
        }
        set(newValue){
            for i in 0...imageArray.count - 1{
                if (newValue.rangeOfString("\(i)") != nil){
                    imageArray[i].showFlag = true
                }
                else{
                    imageArray[i].showFlag = false
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.6)
        let tap = UITapGestureRecognizer(target: self, action: "tapBgView:")
        self.addGestureRecognizer(tap)
        setup(frame)
    }
    
    private func setup(frame: CGRect){
        
        let bgWidth = frame.width - BgMarginLeft - BgMarginRight
        let bgView = UIView(frame: CGRectMake(BgMarginLeft, BgMarginTop, bgWidth, BgHeight))
        bgView.backgroundColor = UIColor.whiteColor()
        bgView.layer.cornerRadius = 10
        
        //账本标题
        let titleText = UITextField(frame: CGRectMake(0, 0, bgWidth, TitleTextHeight))
        titleText.font = UIFont(name: "Courier", size: 20)
        titleText.placeholder = "新建账本"
        titleText.textAlignment = .Center
        self.titleText = titleText
        
        //分割线
        let topSepLine = UIView(frame: CGRectMake(0, TitleTextHeight, bgWidth, 1))
        topSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        //背景图
        let ImageWidth = (bgWidth - ImageMarginLeft * 6)/5
        var imageArray:[FlagBtn] = []
        for i in 1...5 {
            let imageX = ImageMarginLeft * CGFloat(i)  + ImageWidth * CGFloat(i - 1)
            let frame = CGRectMake(imageX, ImageMarginTop + TitleTextHeight, ImageWidth, ImageHeight)
            let image = FlagBtn(frame: frame)
            image.layer.cornerRadius = 5
            image.tag = i - 1
            image.setImage(UIImage(named: "book_cover_\(i - 1)"), forState: .Normal)
            image.addTarget(self, action: "chooseImage:", forControlEvents: .TouchUpInside)
            
            imageArray.append(image)
            bgView.addSubview(image)
        }
        self.imageArray = imageArray
        
        //分割线
        let botmSepLine = UIView(frame: CGRectMake(0, TitleTextHeight + ImageViewHeight , bgWidth, 1))
        botmSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        //按钮
        let cancelBtn = UIButton(frame: CGRectMake(0, TitleTextHeight + ImageViewHeight, bgWidth / 2 - 1, BtnHeight))
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.titleLabel?.font = UIFont(name: "Courier", size: 20)
        cancelBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelBtn.addTarget(self, action: "cancelPress:", forControlEvents: .TouchUpInside)
        let btnSepLine = UIView(frame: CGRectMake(bgWidth / 2 - 1, TitleTextHeight + ImageViewHeight, 1, BtnHeight))
        btnSepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        let sureBtn = UIButton(frame: CGRectMake(bgWidth / 2, TitleTextHeight + ImageViewHeight, bgWidth / 2, BtnHeight))
        sureBtn.setTitle("确定", forState: .Normal)
        sureBtn.titleLabel?.font = UIFont(name: "Courier", size: 20)
        sureBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        sureBtn.addTarget(self, action: "surePress:", forControlEvents: .TouchUpInside)
        
        bgView.addSubview(cancelBtn)
        bgView.addSubview(sureBtn)
        bgView.addSubview(btnSepLine)
        bgView.addSubview(topSepLine)
        bgView.addSubview(titleText)
        bgView.addSubview(botmSepLine)
        self.addSubview(bgView)
        
    }
    
    func cancelPress(sender:UIButton){
        if let cancelBlock = cancelBlock{
            cancelBlock()
        }
    }
    func surePress(sender:UIButton){
        if let sureBlock = sureBlock{
            sureBlock(title, initChooseImage)
        }
    }
    func chooseImage(sender: FlagBtn){
        let index = sender.tag
        
        for i in 0...imageArray.count - 1{
            if i == index{
                imageArray[i].showFlag = true
            }
            else{
                imageArray[i].showFlag = false
            }
            
        }
    }
    
    //MARK: - click action
    func tapBgView(sender:UITapGestureRecognizer){
        titleText?.resignFirstResponder()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
