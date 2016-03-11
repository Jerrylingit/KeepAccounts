//
//  ItemBarView.swift
//  KeepAccounts
//
//  Created by admin on 16/2/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ItemBarView: UIView {
    
    var items : [btnModel] = []
    
    let IconMarginLeft:CGFloat = 12
    let IconMarginTop:CGFloat = 10
    
    let TitleMarginLeft:CGFloat = 16
    let TitleMarginTop:CGFloat = 10
    
    var delegate:ChooseItemVC?
    
    //自定义初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        getItemsFromDB()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        let incomeItem : NSDictionary = [
            "type_add":"自定义",
            "type_big_1":"一般",
            "type_big_2":"用餐",
            "type_big_3":"零食",
            "type_big_4":"交通",
            "type_big_5":"充值",
            "type_big_6":"购物",
            "type_big_7":"娱乐",
            "type_big_8":"住房",
            "type_big_9":"约会",
            "type_big_10":"网购",
            "type_big_11":"鞋帽",
            "type_big_12":"护肤",
            "type_big_13":"丽人",
            "type_big_14":"剧场",
            "type_big_15":"转账",
            "type_big_16":"腐败",
            "type_big_17":"运动",
            "type_big_18":"医疗",
            "type_big_19":"旅游",
            "type_big_20":"学习",
            "type_big_21":"香烟",
            "type_big_22":"酒水",
            "type_big_23":"数码",
            "type_big_24":"爱人",
            "type_big_25":"家庭",
            "type_big_26":"宠物",
            "type_big_27":"服装",
            "type_big_28":"日用品",
            "type_big_29":"果蔬",
            "type_big_30":"宝宝",
            "type_big_31":"信用卡",
            "type_big_32":"理财",
            "type_big_33":"工作", ]
        
        let btnKeys = incomeItem.allKeys
        
        for(var i = 0; i < incomeItem.count; ++i){
            let imageName = btnKeys[i] as! NSString
            let iconTitle = incomeItem[imageName] as! NSString
            let item = btnModel(ID: i, imageName: imageName, iconTitle: iconTitle)
            TypeBtnDB.insertData(item)
        }
    }
    
    override func layoutSubviews() {
        
        let ItemBarWidth = self.frame.width
        let ItemBarHeight = self.frame.height
        
        let ItemWidth = ItemBarWidth / 5.0
        let ItemHeight = ItemBarHeight / 2.0
        //创建一个ScrollView
        let itemBar = setupScrollView(CGRectMake(0, 0, ItemBarWidth, ItemBarHeight))
        
        //根据数据库ID的数目创建对应的btn
        var index = 0
        var page = self.items.count / 10 + 1
        var tmpCount = self.items.count
        var pageX = 0
        var itemX:CGFloat = 0
        var itemY:CGFloat = 0
        while(page >= 1 && tmpCount > 0){
            
            for(var row = 0; row < (page > 1 ? 2 : tmpCount/5 + 1); ++row){
                //修改Y偏移量
                itemY = CGFloat(row) * ItemHeight
                //计算一行有多少个View
                var tmpRowCount = tmpCount
                //第一行
                if (row == 0){
                    tmpRowCount = tmpCount > 5 ? 5 : tmpCount
                }
                //第二行
                else{
                    tmpRowCount = tmpCount - 5
                }
                //渲染每行的view
                for(var column = 0; column < (page > 1 ? 5 : tmpRowCount); ++column){
                    //修改X偏移量
                    itemX = CGFloat(column) * ItemWidth + CGFloat(pageX) * ItemBarWidth
                    let itemView = createItemView(index, item: self.items[index], frame: CGRectMake(itemX, itemY, ItemWidth, ItemHeight))
                    itemBar.addSubview(itemView)
                    index++
                }
            }
            //page减1
            page--
            pageX++
            tmpCount -= 10
        }
        
        //添加到ItemBar
        self.addSubview(itemBar)
    }
    
    private func setupScrollView(frame: CGRect) -> UIScrollView{
        //创建一个ScrollView
        let itemBar = UIScrollView(frame: frame)
        itemBar.contentSize = CGSizeMake(frame.width * CGFloat(4), frame.height)
        itemBar.pagingEnabled = true
        
        return itemBar
    }
    
    func getItemsFromDB(){
        let db = TypeBtnDB.getDB()
        db.open()
        let DBItemCount = db.intForQuery("SELECT COUNT(ID) FROM btnDB")
        db.close()
        for(var i = 0; i < Int(DBItemCount);++i){
            let item = TypeBtnDB.selectData(i)
            self.items.append(item)
        }
    }
    
    private func createItemView(index:Int ,item:btnModel,frame:CGRect)->UIView{
        
        let itemView = UIView(frame: frame)
        
        //添加icon
        let iconWidth = frame.width - CGFloat(2) * IconMarginLeft
        let icon = UIButton(frame: CGRectMake(IconMarginLeft, IconMarginTop, iconWidth, iconWidth))
        icon.setImage(UIImage(named: item.imageName as String), forState: .Normal)
        icon.tag = index
        icon.addTarget(self, action: "itemPress:", forControlEvents: .TouchUpInside)
        //添加title
        let titleHeight = frame.height - iconWidth - CGFloat(2) * IconMarginTop - TitleMarginTop
        let titleY = frame.height - TitleMarginTop - titleHeight
        let title = UILabel(frame: CGRectMake(TitleMarginLeft, titleY, iconWidth, titleHeight))
        title.text = item.iconTitle as String
        title.textAlignment = .Center
        //添加到itemView中
        itemView.addSubview(icon)
        itemView.addSubview(title)
        return itemView
    }
    func itemPress(sender:UIButton){
        let item = self.items[sender.tag]
        delegate?.setCostBarIconAndTitle(item.imageName as String, title: item.iconTitle as String)
    }
    
}
