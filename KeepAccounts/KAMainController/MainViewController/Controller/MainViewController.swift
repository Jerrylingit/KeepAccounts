//
//  MainViewController.swift
//  KeepAccounts
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var mainVCModel:MainVCModel = MainVCModel()
    var mainView:MainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //建立主页面
        setupMainView()
//        setupInputDialog()
        
    }
    //建立主页面
    private func setupMainView(){
        let mainViewFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let mainView = MainView(frame: mainViewFrame, delegate:self)
        self.mainView = mainView
        self.view.addSubview(mainView)
    }
    
//    private func setupInputDialog(){
//        //背景视图，设置透明
//        let bgView = UIView(frame: self.view.bounds)
//        
//        //中间自定义视图，背景白色
//        let midBgView = UIView(frame: CGRectNull)
//        
//        //输入title框
//        let titleTextField = UITextField(frame: CGRectNull)
//        
//        //chooseImage
//        let chooseImage = generateImage(CGRectNull)
//        
//        //取消
//        let cancelBtn = UIButton(frame: CGRectNull)
//        
//        //确定
//        let sureBtn = UIButton(frame: CGRectNull)
//        
//        
//        
//    }
//    func generateImage(frame:CGRect)->UIView{
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func longPressAction(sender:UILongPressGestureRecognizer){
        let point = sender.locationInView(mainView.accountBookBtnView)
        let indexPath = mainView.accountBookBtnView?.indexPathForItemAtPoint(point)
        if let indexPath = indexPath{
            let cellCount = mainView.accountBookBtnView?.numberOfItemsInSection(indexPath.section) ?? 0
            let cell = mainView.accountBookBtnView?.cellForItemAtIndexPath(indexPath) as! AccountBookCell
            //最后一个cell是加号，不用做长按处理
            if indexPath.row < cellCount - 1{
                if sender.state == .Began{
                    cell.highlightedViewAlpha = AccountCellPressState.LongPress.rawValue
                    //弹出修改的按钮
                    let alert = UIAlertController(title: "asdfasdf", message: "", preferredStyle: .Alert)
                    let sureAction = UIAlertAction(title: "确定", style: .Default, handler: {(action) in print(action) })
                    let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: {(action) in print(action) })
                    alert.addAction(sureAction)
                    alert.addAction(cancelAction)
                    let custom = UIViewController()
                    custom.view.backgroundColor = UIColor.greenColor()
                    alert.setValue(custom, forKey: "contentViewController")
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
}
//MARK: - UICollectionViewDelegate
extension MainViewController:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

        let cellCount = collectionView.numberOfItemsInSection(indexPath.section)
        if indexPath.row == cellCount - 1{
            return false
        }
        else{
            return true
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        cell.selectedFlag.alpha = 1.0
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        cell.selectedFlag.alpha = 0.0
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        cell.highlightedViewAlpha = AccountCellPressState.Highlighted.rawValue
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        //浮点数没法精确，所以只能用小于
        if cell.highlightedViewAlpha <= AccountCellPressState.Highlighted.rawValue + 0.1{
            cell.highlightedViewAlpha = AccountCellPressState.Normal.rawValue
        }
    }
}
//MARK: - UICollectionViewDataSource
extension MainViewController:UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainVCModel.accountsBtns.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AccountBookBtnCell", forIndexPath: indexPath) as! AccountBookCell
        let cellData = mainVCModel.accountsBtns[indexPath.row]
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        longPress.cancelsTouchesInView = false
        cell.addGestureRecognizer(longPress)
        
        cell.accountTitle.text = cellData.btnTitle
        cell.accountCounts.text = cellData.accountCount
        cell.accountBackImage.image = UIImage(named: cellData.backgrountImageName)
        cell.selectedFlag.alpha = cellData.selectedFlag ? 1 : 0
        
        return cell
    }
    
}
