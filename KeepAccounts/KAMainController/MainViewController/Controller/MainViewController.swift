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
    override func viewDidLoad() {
        super.viewDidLoad()
        //建立主页面
        setupMainView()
        
    }
    //建立主页面
    private func setupMainView(){
        let mainView = MainView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), delegate:self)
        self.view.addSubview(mainView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension MainViewController:UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        cell.showHighlightedView(true)
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AccountBookCell
        cell.showHighlightedView(false)
    }
}
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
        cell.accountTitle.text = cellData.btnTitle
        cell.accountCounts.text = cellData.accountCount
        cell.accountBackImage.image = UIImage(named: cellData.backgrountImageName)
        cell.selectedFlag.alpha = cellData.selectedFlag ? 1 : 0
        
        return cell
    }
    
}
