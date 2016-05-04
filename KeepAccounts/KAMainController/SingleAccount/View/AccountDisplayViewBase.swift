//
//  AccountDisplayViewBase.swift
//  KeepAccounts
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let sepLineHeight:CGFloat = 0.5
private let rotateBtnWidth:CGFloat = 60
private let rotateBtnMarginBottom:CGFloat = 10
private let redIndicatorHeight:CGFloat = 30
private let midRoundBtnWidth:CGFloat = 50
private let titleLabelY:CGFloat = 50
private let titleLabelHeight:CGFloat = 50
private let moneyLabelHeight:CGFloat = 50
private let yearLabelHeight:CGFloat = 30
private let yearLabelWidth:CGFloat = 60




class AccountDisplayViewBase: UIView {
    
    //MARK: - properties (public)
    var lineWidth:CGFloat = 15
    var index:Int = 1
    
    weak var pickerDelegate:AKPickerViewDelegate?
    weak var pickerDataSource:AKPickerViewDataSource?
    
    
    var pieChartTotalCost:String{
        get{
            return costBtn.titleLabel?.text ?? ""
        }
        set(newValue){
            costBtn.setTitle("\(newValue)", forState: .Normal)
        }
    }
    
    var pieChartTotalIncome:String{
        get{
            return incomeBtn.titleLabel?.text ?? ""
        }
        set(newValue){
            incomeBtn.setTitle("\(newValue)", forState: .Normal)
        }
    }
    
    //MARK: - properties (private)
    private var incomeBtn:UIButton!
    private var costBtn:UIButton!
    private var yearLabel:UILabel!
    
    //    private var rotateBtn:UIButton!
    private var pickerView:AKPickerView!
    private var containerLayer:CAShapeLayer!
    
    private var radius:CGFloat {
        return self.frame.width / 4
    }
    private var layerWidth:CGFloat{
        return self.frame.width / 2
    }
    
    //MARK: - init
    init(frame:CGRect, delegate:AKPickerViewDelegate!, dataSource:AKPickerViewDataSource!){
        self.pickerDelegate = delegate
        self.pickerDataSource = dataSource
        
        super.init(frame: frame)
        setupViews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - operations (internal)
    
    func selectedIncome(sender:UIButton){
        sender.selected = !sender.selected
        costBtn.selected = !sender.selected
    }
    func selectedCost(sender:UIButton){
        sender.selected = !sender.selected
        incomeBtn.selected = !sender.selected
    }
    
    func setYear(year:String){
        self.yearLabel.text = year
        self.yearLabel.sizeToFit()
        self.yearLabel.center = CGPointMake(frame.width / 2, 80)
    }
    
    //MARK: - setupViews (private)
    private func setupViews(frame:CGRect){
        let incomeAndCostBtnHeight:CGFloat = 80
        
        setupIncomeAndCostBtn(CGRectMake(0, 0, frame.width, incomeAndCostBtnHeight))
        setupScrollMonthView(CGRectMake(0, incomeAndCostBtnHeight, frame.width, incomeAndCostBtnHeight))
    }
    
    private  func setupIncomeAndCostBtn(frame:CGRect){
        
        let btnWidth:CGFloat = 75
        let btnMargin:CGFloat = 15
        let bgView = UIView(frame: frame)
        
        let incomeBtn = createBtn(CGRectMake(btnMargin, btnMargin, btnWidth, btnWidth), title:"总收入\n0.00", action:"selectedIncome:")
        self.incomeBtn = incomeBtn
        let costBtn = createBtn(CGRectMake(frame.width - btnMargin - btnWidth, btnMargin, btnWidth, btnWidth), title:"总支出\n9384.00", action:"selectedCost:")
        costBtn.titleLabel?.textAlignment = .Right
        costBtn.selected = true
        self.costBtn = costBtn
        let sepline = UIView(frame: CGRectMake(0, frame.height, frame.width, sepLineHeight))
        sepline.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        bgView.addSubview(sepline)
        bgView.addSubview(incomeBtn)
        bgView.addSubview(costBtn)
        self.addSubview(bgView)
    }
    private func createBtn(frame:CGRect, title:String, action:Selector)->UIButton{
        let btn = UIButton(frame: frame)
        btn.setTitle(title, forState: .Normal)
        btn.titleLabel?.numberOfLines = 2
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: .Selected)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return btn
    }
    
    private  func setupScrollMonthView(frame:CGRect){
        
        let bgView = UIView(frame: frame)
        
        let pickerView = AKPickerView(frame: CGRectMake(0, 80, frame.width, frame.height))
        pickerView.delegate = pickerDelegate
        pickerView.dataSource = pickerDataSource
        pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        pickerView.pickerViewStyle = .Wheel
        pickerView.maskDisabled = false
        pickerView.highlightedTextColor = UIColor.orangeColor()
        pickerView.interitemSpacing = 20
        pickerView.reloadData()
        pickerView.selectItem(0)
        self.pickerView = pickerView
        
        let sepline = UIView(frame: CGRectMake(0, frame.height, frame.width, sepLineHeight))
        sepline.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        let yearLabel = UILabel(frame: CGRectMake(0, 0, yearLabelWidth, yearLabelHeight))
        yearLabel.center = CGPointMake(frame.width / 2, frame.height)
        yearLabel.backgroundColor = UIColor.whiteColor()
        yearLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        yearLabel.textAlignment = .Center
        yearLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        yearLabel.text = "1900年"
        self.yearLabel = yearLabel
        
        bgView.addSubview(sepline)
        bgView.addSubview(yearLabel)
        self.addSubview(bgView)
        self.addSubview(pickerView)
    }

}
