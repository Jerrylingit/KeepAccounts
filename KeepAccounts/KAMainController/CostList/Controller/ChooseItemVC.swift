//
//  ChooseItemVC.swift
//  KeepAccounts
//
//  Created by admin on 16/2/16.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let AccountPhoto = "AccountPhoto"

protocol ComputeBoardProtocol{
    func onPressBack()
    func clickTime()
    func clickRemark()
    func clickPhoto()
}
protocol ChooseItemProtocol{
    func setCostBarIconAndTitle(icon:String, title:String)
}

protocol TopBarProtocol{
    func clickBack(sender:AnyObject!)
}

class ChooseItemVC: UIViewController, ChooseItemProtocol {

    let ScreenWidth = UIScreen.mainScreen().bounds.width
    let ScreenHeight = UIScreen.mainScreen().bounds.height
    
    let ComputeBoardHeight =  UIScreen.mainScreen().bounds.height/2 - 20 + 72
    
    let TopBarHeight: CGFloat = 44.0
    var ComputedBar:ComputeBoardView?
    var datePicker:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //创建顶部栏
        setupTopBar()
        //创建图标项
        setupItem()
        //消费金额和计算面板栏
        setupComputeBoard()
        //时间选择器
        setupDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //创建顶部栏
    func setupTopBar(){
        
        //底部栏
        let topBar = TopBarView(frame: CGRectMake(0, 20, ScreenWidth, TopBarHeight))
        topBar.delegate = self
        //添加到主view上
        self.view.addSubview(topBar)
    }
    
    //创建图标项
    func setupItem(){
        let ItemBarHeight = ScreenHeight - 20 - TopBarHeight - ComputeBoardHeight
        let itemBar = ItemBarView(frame: CGRectMake(0, 20 + TopBarHeight , ScreenWidth, ItemBarHeight))
        itemBar.delegate = self
        self.view.addSubview(itemBar)
    }
    
    //创建计算面板
    func setupComputeBoard(){
        //创建计算面板
        let computeBoard = ComputeBoardView(frame: CGRectMake(0, ScreenHeight - ComputeBoardHeight, ScreenWidth, ComputeBoardHeight))
        computeBoard.delegate = self
        ComputedBar = computeBoard
        //添加到self.view
        self.view.addSubview(computeBoard)
    }
    //时间选择器
    func setupDatePicker(){
        let datePickerView = CustomDatePicker(frame: self.view.frame, date: NSDate(), cancel: nil, sure: nil)
        datePickerView.hidden = true

        
        datePickerView.cancelCallback = {()->() in datePickerView.hidden = !datePickerView.hidden}
        datePickerView.sureCallback = {(date)-> () in
            let dateTmp = date as NSDate
            let interval = dateTmp.timeIntervalSince1970
            self.ComputedBar?.accountTime = interval
        }
        datePicker = datePickerView
        self.view.addSubview(datePickerView)
    }
    
    func setCostBarIconAndTitle(icon: String, title: String) {
        ComputedBar?.title.text = title
        ComputedBar?.iconName = icon
        ComputedBar?.icon = UIImage(named: icon)
    }
}

extension ChooseItemVC: TopBarProtocol{
    func clickBack(sender:AnyObject!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func clickTime(){
        self.datePicker?.hidden = !self.datePicker!.hidden
    }
    func clickRemark() {
        let limitInputVC = LimitInputVC()
        limitInputVC.initDate = ComputedBar?.accountTime
        limitInputVC.completeInput = {(text) in ComputedBar?.remark = text}
        self.presentViewController(limitInputVC, animated: true, completion: nil)
    }
    func clickPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}
extension ChooseItemVC: ComputeBoardProtocol{
    func onPressBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ChooseItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //转为二进制，压缩
        let imageData = UIImage.cropAndCompressImage(image, scale: 0.5, compressionQualiy: 0.7)
        //生成文件名
        let imageName = "AccountPhoto/image-" + String(NSDate().timeIntervalSince1970)
        //生成路径
        let imagePath = String.createFilePathInDocumentWith(imageName) ?? ""
        //写入文件
        if imageData?.writeToFile(imagePath, atomically: false) == true {
            print("write AccountImage success!")
            ComputedBar?.photoName = imageName
        }
        else{
            print("write AccountImage failed!")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


