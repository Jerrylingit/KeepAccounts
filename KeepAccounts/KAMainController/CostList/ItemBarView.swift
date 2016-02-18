//
//  ItemBarView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ItemBarView: UIView {

    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
    }
    
    override func layoutSubviews() {
        
        let ItemBarWidth = self.frame.width
        let ItemBarHeight = self.frame.height
        //创建一个ScrollView
        let itemBar = setupScrollView(CGRectMake(0, 0, ItemBarWidth, ItemBarHeight))
        
        
        
        //添加到ItemBar
        self.addSubview(itemBar)
    }
    
    private func setupScrollView(frame: CGRect) -> UIScrollView{
        //创建一个ScrollView
        let itemBar = UIScrollView(frame: frame)
        itemBar.contentSize = CGSizeMake(frame.width * CGFloat(3), frame.height)
        itemBar.pagingEnabled = true
        
        return itemBar
    }
}
