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

private let myContent = 0

class ChooseItemVC: UIViewController, ChooseItemProtocol {

    let ScreenWidth = UIScreen.mainScreen().bounds.width
    let ScreenHeight = UIScreen.mainScreen().bounds.height
    
    let ComputeBoardHeight =  UIScreen.mainScreen().bounds.height/2 - 20 + 72
    
    let TopBarHeight: CGFloat = 44.0
    weak var computedBar:ComputeBoardView?
    weak var topBar:TopBarView?
    weak var datePicker:UIView?
    
    var dissmissCallback:((AccountItem)->Void)?
    
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
    deinit{
        chooseItemModel.removeObserver(self, forKeyPath: "costBarTime")
        chooseItemModel.removeObserver(self, forKeyPath: "costBarIconName")
        chooseItemModel.removeObserver(self, forKeyPath: "costBarTitle")
        chooseItemModel.removeObserver(self, forKeyPath: "costBarMoney")
        chooseItemModel.removeObserver(self, forKeyPath: "topBarRemark")
        chooseItemModel.removeObserver(self, forKeyPath: "topBarPhotoName")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        chooseItemModel.addObserver(self, forKeyPath: "costBarTime", options: [.New, .Old], context: nil)
        chooseItemModel.addObserver(self, forKeyPath: "costBarIconName", options: [.New, .Old], context: nil)
        chooseItemModel.addObserver(self, forKeyPath: "costBarTitle", options: [.New, .Old], context: nil)
        chooseItemModel.addObserver(self, forKeyPath: "costBarMoney", options: [.New, .Old], context: nil)
        chooseItemModel.addObserver(self, forKeyPath: "topBarRemark", options: [.New, .Old], context: nil)
        chooseItemModel.addObserver(self, forKeyPath: "topBarPhotoName", options: [.New, .Old], context: nil)
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
        if chooseItemModel.topBarPhotoName != ""{
            topBar.topBarInitPhoto = UIImage.generateImageWithFileName(chooseItemModel.topBarPhotoName)
        }
        topBar.delegate = self
        self.topBar = topBar
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
        //修改model中的金额
        computeBoard.computedResult = {(float) in
            self.chooseItemModel.setCostBarMoneyWithFloat(float)
        }
        //点击OK时要执行一系列操作
        computeBoard.pressOK = {() in
            let item = AccountItem()
            item.ID = self.chooseItemModel.dataBaseId
            item.money = self.chooseItemModel.costBarMoney
            item.iconTitle = self.chooseItemModel.costBarTitle
            item.iconName = self.chooseItemModel.costBarIconName
            item.date = Int(self.chooseItemModel.costBarTime)
            item.remark = self.chooseItemModel.topBarRemark
            item.photo = self.chooseItemModel.topBarPhotoName
            if self.chooseItemModel.mode == "edit"{
                if let dissmissCallback = self.dissmissCallback{
                    dissmissCallback(item)
                }
            }
            else if self.chooseItemModel.mode == "init" {
                if let dissmissCallback = self.dissmissCallback{
                    dissmissCallback(item)
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeDataSource", object: self)
            self.onPressBack()
        }
        //点击收入或分支选项也要执行切换操作
        computeBoard.pressIncomeAndCost = {() in }
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
        switch keyPath ?? "" {
        case "costBarTime":
            computedBar?.time = chooseItemModel.getCostBarTimeInString()
            topBar?.topBarChangeTime?.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        case "costBarIconName":
            computedBar?.icon = UIImage(named:chooseItemModel.costBarIconName)
        case "costBarTitle":
            computedBar?.title = chooseItemModel.costBarTitle
        case "costBarMoney":
            computedBar?.money = chooseItemModel.costBarMoney
        case "topBarRemark":
            if let newValue = change?[NSKeyValueChangeNewKey]{
                if newValue as! String == ""{
                    topBar?.topBarAddRemark?.setTitleColor(UIColor.blackColor(), forState: .Normal)
                }
                else{
                    topBar?.topBarAddRemark?.setTitleColor(UIColor.orangeColor(), forState: .Normal)
                }
            }
        case "topBarPhotoName":
            if let newValue = change?[NSKeyValueChangeNewKey]{
                let value = newValue as! String
                if value == ""{
                    topBar?.topBarTakePhoto?.hidden = false
                    topBar?.topBarTakePhotoImage?.hidden = true
                }
                else{
                    if let image = UIImage.generateImageWithFileName(value){
                        topBar?.topBarTakePhotoImage?.setImage(image, forState: .Normal)
                        topBar?.topBarTakePhoto?.hidden = true
                        topBar?.topBarTakePhotoImage?.hidden = false
                    }
                }
            }
        default:
            print("error keypath")
            
        }
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
        limitInputVC.text = chooseItemModel.topBarRemark
        limitInputVC.completeInput = {(text) in self.chooseItemModel.topBarRemark = text}
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
            chooseItemModel.topBarPhotoName = imageName
        }
        else{
            print("write AccountImage failed!")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
