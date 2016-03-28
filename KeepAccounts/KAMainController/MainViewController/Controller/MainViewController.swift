//
//  MainViewController.swift
//  KeepAccounts
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit



class MainViewController: UIViewController {

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
    
}
extension MainViewController:UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AccountBookBtnCell", forIndexPath: indexPath)
        return cell
    }
    
}
