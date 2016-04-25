//
//  LineChartView.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit


class LineChartView: AccountDisplayViewBase {
    
    
    weak var tableViewDelegate:UITableViewDelegate!
    
    private var monthDataTableView:UITableView!
    private var lineChartHeight:CGFloat{
        return (bounds.height - 160.0) / 2
    }
    //init (internal)
    override init(frame:CGRect, delegate:AKPickerViewDelegate!, dataSource:AKPickerViewDataSource){
        super.init(frame: frame, delegate: delegate, dataSource: dataSource)
        setupViews(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - setup views(private)
    private func setupViews(frame:CGRect){
        
        setupTableView(CGRect(x: 0, y: lineChartHeight, width: frame.width, height: lineChartHeight))
    }
    
    private func setupTableView(frame:CGRect){
        let tableView = UITableView(frame: frame)
        tableView.registerNib(UINib(nibName: "LineChartTableViewCell", bundle: nil), forCellReuseIdentifier: "LineChartTableViewCell")
        monthDataTableView = tableView
        self.addSubview(tableView)
    }
}
