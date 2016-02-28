//
//  SingleAccountVC.swift
//  KeepAccounts
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

protocol SubViewProtocol{
    func clickManageBtn(sender:AnyObject!)
    func clickMidAddBtn(sender:AnyObject!)
}

class SingleAccountVC: UIViewController, SubViewProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupMainView()
        
    }
    private func setupMainView(){
        let singleAccountView = SingleAccountView(frame: self.view.frame)
        singleAccountView.delegate = self
        self.view.addSubview(singleAccountView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

extension SingleAccountVC{
    func clickManageBtn(sender:AnyObject!){
        self.presentLeftMenuViewController(sender)
    }
    func clickMidAddBtn(sender:AnyObject!){
        self.presentViewController(ChooseItemVC(), animated: true, completion: nil)
    }
}