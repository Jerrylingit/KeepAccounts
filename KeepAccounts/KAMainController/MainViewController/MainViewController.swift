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
        let mainView = MainView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.view.addSubview(mainView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
