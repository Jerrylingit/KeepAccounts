//
//  LineChartView.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit


class LineChartView: AccountDisplayViewBase {
    
    weak var tableViewDelegate:SingleAccountVC!
    
    private var monthDataTableView:UITableView!
    private var lineChartHeight:CGFloat{
        return (bounds.height - 160.0) / 2
    }
    private var lineChart:LineChartViewComponent!
    private var pointDataItem:[Float]!
    private var infoDataItem:[LineChartInfoData]!
    
    //init (internal)
    init(frame:CGRect, infoDataItem:[LineChartInfoData]!, pointDataItem:[Float]!, delegate:AKPickerViewDelegate!, dataSource:AKPickerViewDataSource,tableViewDelegate:SingleAccountVC!){
        self.infoDataItem = infoDataItem
        self.pointDataItem = pointDataItem
        self.tableViewDelegate = tableViewDelegate
        super.init(frame: frame, delegate: delegate, dataSource: dataSource)
        setupViews(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(infoDataItem:[LineChartInfoData], pointDataItem:[Float]){
        lineChart.pointDataItem = pointDataItem
        lineChart.infoDataItem = infoDataItem
        lineChart.setNeedsDisplay()
        monthDataTableView.reloadData()
    }
    
    //MARK: - setup views(private)
    private func setupViews(frame:CGRect){
        setupLineChartView(CGRect(x: 0, y: 180, width: frame.width, height: lineChartHeight - 20))
        setupTableView(CGRect(x: 0, y: lineChartHeight + 160, width: frame.width, height: lineChartHeight))
    }
    
    private func setupLineChartView(frame:CGRect){
        lineChart = LineChartViewComponent(frame: frame, pointDataItem: pointDataItem, infoDataItem: infoDataItem)
        
        let sepLine = UIView(frame: CGRect(x: 0, y: frame.height - 1 + frame.origin.y, width: frame.width, height: 0.5))
        sepLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        self.addSubview(lineChart)
        self.addSubview(sepLine)
    }
    
    private func setupTableView(frame:CGRect){
        
        let tableView = UITableView(frame: frame)
        tableView.registerNib(UINib(nibName: "LineChartTableViewCell", bundle: nil), forCellReuseIdentifier: "LineChartTableViewCell")
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        tableView.separatorStyle = .None
        monthDataTableView = tableView
        self.addSubview(tableView)
    }
}
