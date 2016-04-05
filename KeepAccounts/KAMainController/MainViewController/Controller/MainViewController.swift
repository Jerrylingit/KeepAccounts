//
//  MainViewController.swift
//  KeepAccounts
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let customAccountName = "DatabaseDoc/AccountModel"

class MainViewController: UIViewController {
    
    var mainVCModel:MainVCModel = MainVCModel()
    var mainView:MainView = MainView()
    var customAlertView:CustomAlertView?
    var operateAccountBook:OperateAccountBookView?
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //建立主页面
        setupMainView()
        setupCustomAlertView()
        setupOperateAccountBookView()
    }
    override func viewWillAppear(animated: Bool) {
        //更新数据
        mainVCModel.reloadModelData()
        //更新页面
        mainView.reloadCollectionView()
    }

    
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
                    let item = mainVCModel.getItemInfoAtIndex(indexPath.row)
                    let title = item?.btnTitle ?? ""
                    cell.highlightedViewAlpha = AccountCellPressState.LongPress.rawValue
                    //弹出修改的按钮
                    operateAccountBook?.hidden = false
                    operateAccountBook?.showBtnAnimation()
                    operateAccountBook?.cancelBlock = {() in
                        self.operateAccountBook?.hidden = true
                        self.operateAccountBook?.hideBtnAnimation()
                        cell.highlightedView.alpha = AccountCellPressState.Normal.rawValue
                    }
                    operateAccountBook?.deleteBlock = {() in
                        let alert = UIAlertController(title: "删除\(title)", message: "将会删除所有数据，不会恢复", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {(action) in
                            //删除数据源
                            self.mainVCModel.removeBookItemAtIndex(indexPath.row)
                            //执行删除操作
                            self.mainView.accountBookBtnView?.deleteItemsAtIndexPaths([indexPath])
                            self.operateAccountBook?.hidden = true
                            self.operateAccountBook?.hideBtnAnimation()
                            cell.highlightedView.alpha = AccountCellPressState.Normal.rawValue
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    operateAccountBook?.editBlock = {() in
                        self.editAccountBook(item, indexPath:indexPath)
                        cell.highlightedView.alpha = AccountCellPressState.Normal.rawValue
                    }
                }
            }
        }
    }
    func editAccountBook(item:AccountBookBtn?, indexPath:NSIndexPath){
        customAlertView?.title = item?.btnTitle ?? ""
        customAlertView?.initChooseImage = item?.backgrountImageName ?? "book_cover_0"
        customAlertView?.cancelBlock = {() in
            self.customAlertView?.removeFromSuperview()
        }
        customAlertView?.sureBlock = {(title, imageName) in
            //修改账本
            if let editItem = self.mainVCModel.getItemInfoAtIndex(indexPath.row){
                editItem.btnTitle = title
                editItem.backgrountImageName = imageName
                self.mainVCModel.updateBookItem(editItem, atIndex:indexPath.row)
                self.mainView.accountBookBtnView?.reloadItemsAtIndexPaths([indexPath])
                self.operateAccountBook?.hidden = true
                self.operateAccountBook?.hideBtnAnimation()
            }
            //退出alertview
            self.customAlertView?.removeFromSuperview()

        }
        UIApplication.sharedApplication().keyWindow?.addSubview(self.customAlertView!)
    }
    
    //MARK: - generate views by coding(private)
    //建立主页面
    private func setupMainView(){
        let mainViewFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let mainView = MainView(frame: mainViewFrame, delegate:self)
        self.mainView = mainView
        self.view.addSubview(mainView)
    }
    private func setupCustomAlertView(){
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let customAlertView = CustomAlertView(frame: frame)
        
        self.customAlertView = customAlertView
    }
    private func setupOperateAccountBookView(){
        let frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        let operateAccountBook = OperateAccountBookView(frame: frame)
        operateAccountBook.hidden = true
        self.operateAccountBook = operateAccountBook
        self.view.addSubview(operateAccountBook)
    }
    
    //MARK: - private method
    
    
}
//MARK: - UICollectionViewDelegate
extension MainViewController:UICollectionViewDelegate{
    //MARK: - selected cell
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        let cellCount = collectionView.numberOfItemsInSection(indexPath.section)
        if indexPath.row == cellCount - 1{
            return false
        }
        else{
            if cell.highlightedViewAlpha < 0.59{
                return true
            }
            else{
                return false
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        mainVCModel.showFlagWithIndex(indexPath.row)
        mainView.reloadCollectionView()
    }
    //MARK: - highlighted cell
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
            
            let cellCount = collectionView.numberOfItemsInSection(indexPath.section)
            if indexPath.row == cellCount - 1{
                customAlertView?.title = ""
                customAlertView?.initChooseImage = "book_cover_0"
                customAlertView?.cancelBlock = {() in
                    self.customAlertView?.removeFromSuperview()
                }
                customAlertView?.sureBlock = {(title, imageName) in
                    //建一个数据库
                    let currentTime = Int(NSDate().timeIntervalSince1970)
                    let dbName = customAccountName + "\(currentTime)" + ".db"
                    let item = AccountBookBtn(title: title, count: "0笔", image: imageName, flag: false, dbName: dbName)
                    //插入账本
                    self.mainVCModel.addBookItemByAppend(item)
                    self.mainView.accountBookBtnView?.insertItemsAtIndexPaths([indexPath])
                    //退出alertview
                    self.customAlertView?.removeFromSuperview()
                }
                UIApplication.sharedApplication().keyWindow?.addSubview(self.customAlertView!)
            }
            else{
                //切换到contentView
                if let item = mainVCModel.getItemInfoAtIndex(indexPath.row){
                    let tmpSingleAccountVC = SingleAccountVC(initDBName: item.dataBaseName, accountTitle: item.btnTitle)
                    self.sideMenuViewController.setContentViewController(tmpSingleAccountVC, animated: true)
                    self.sideMenuViewController.hideMenuViewController()
                }
            }
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
