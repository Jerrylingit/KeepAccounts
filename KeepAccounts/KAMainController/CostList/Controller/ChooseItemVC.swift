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
    var computedBar:ComputeBoardView?
    var datePicker:UIView?
    //dataModel
    var chooseItemModel:ChooseItemModel
    
    init(model:ChooseItemModel){
        chooseItemModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(){
        self.init(model: ChooseItemModel())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        computeBoard.time = chooseItemModel.getCostBarTimeInString()
        computeBoard.icon = UIImage(named: chooseItemModel.costBarIconName)
        computeBoard.title = chooseItemModel.costBarTitle
        computeBoard.money = chooseItemModel.costBarMoney
        computedBar = computeBoard
        //添加到self.view
        self.view.addSubview(computeBoard)
    }
    //时间选择器
    func setupDatePicker(){
        let datePickerView = CustomDatePicker(frame: self.view.frame, date: chooseItemModel.getCostBarTimeInDate(), cancel: nil, sure: nil)
        datePickerView.hidden = true
        datePickerView.cancelCallback = {()->() in datePickerView.hidden = !datePickerView.hidden}
        datePickerView.sureCallback = {(date)-> () in
            //new change
            self.chooseItemModel.setCostBarTimeWithDate(date)
        }
        datePicker = datePickerView
        self.view.addSubview(datePickerView)
    }

    func setCostBarIconAndTitle(icon: String, title: String) {
        chooseItemModel.costBarIconName = icon
        chooseItemModel.costBarTitle = title
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
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
        limitInputVC.initVCDate = chooseItemModel.getCostBarTimeInString()
        limitInputVC.completeInput = {(text) in computedBar?.remark = text}
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
            computedBar?.photoName = imageName
        }
        else{
            print("write AccountImage failed!")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


