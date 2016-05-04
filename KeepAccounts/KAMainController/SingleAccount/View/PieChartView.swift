//
//  PieChartView.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
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

class PieChartView: AccountDisplayViewBase {
    
    //MARK: - properties (public)
    var layerData:[RotateLayerData]
    
    //MARK: - properties (private)
    private var itemTitleLabel:UILabel!
    private var itemMoneyLabel:UILabel!
    private var itemIconBtn:UIButton!
    private var itemPercentage:UILabel!
    private var itemAccountCount:UILabel!
    
    
    private var layerBgView:UIView!
    private var dataItem:[CGFloat]!
    
    private var itemValueAmount:CGFloat{
        var amount:CGFloat = 0
        for value in dataItem{
            amount += value
        }
        if amount == 0 {
            amount = 1
        }
        return amount
    }
    private var containerLayer:CAShapeLayer!
    
    private var radius:CGFloat {
        return self.frame.width / 4
    }
    private var layerWidth:CGFloat{
        return self.frame.width / 2
    }
    
    //MARK: - init
    init(frame:CGRect, layerData:[RotateLayerData], delegate:AKPickerViewDelegate!, dataSource:AKPickerViewDataSource!){
        self.layerData = layerData
        super.init(frame: frame, delegate: delegate, dataSource: dataSource)
        self.setDataItems(layerData)
        setupViews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - operations (internal)
    func reloadPieChartViewData(data:[RotateLayerData]?, year:String, cost:String?, income:String?){
        self.setYear(year)
        if let data = data{
            self.updateByLayerData(data)
        }
        if let cost = cost{
            self.pieChartTotalCost = cost
        }
        if let income = income {
            self.pieChartTotalIncome = income
        }
    }
    
    func reDraw(index:Int){
        var curIndex = index - 1
        if index == 0{
            curIndex = dataItem.count - 1
        }
        
        var rotateRadian = dataItem[curIndex] / itemValueAmount + dataItem[index] / itemValueAmount
        rotateRadian = -rotateRadian * CGFloat(M_PI)
        rotateContainerLayerWithRadian(rotateRadian)
    }
    
    func rotateAction(sender:UIButton?){
        if dataItem.count > 1{
            reDraw(index % dataItem.count)
            reloadDataInPieChartView(layerData[index])
            index += 1
            if index >= dataItem.count{
                index = 0
            }
        }
    }
    
    func setDataItems(layerDatas:[RotateLayerData]){
        var moneyItems = [CGFloat]()
        for item in layerDatas{
            let money = Float(item.money) ?? 0
            moneyItems.append(CGFloat(money))
        }
        self.dataItem = moneyItems
    }
    func reloadDataInPieChartView(layerData: RotateLayerData){
        
        self.itemTitleLabel.text = layerData.title
        self.itemMoneyLabel.text = layerData.money
        self.itemIconBtn.setImage(UIImage(named: layerData.icon), forState: .Normal)
        self.itemPercentage.text = layerData.percent
        self.itemAccountCount.text = layerData.count
    }
    
    func updateByLayerData(data:[RotateLayerData]){
        layerData = data
        setDataItems(data)
        index = 1
        
        self.containerLayer.removeFromSuperlayer()
        self.containerLayer = setupContainerLayer(CGRectMake(0, 160, frame.width, frame.height - 160))
        self.layerBgView.layer.addSublayer(self.containerLayer)
        if layerData.count > 0{
            reloadDataInPieChartView(layerData[0])
        }
    }
    
    //MARK: - setupViews (private)
    private func setupViews(frame:CGRect){
        let incomeAndCostBtnHeight:CGFloat = 80
        let layersHeight = frame.height - 2 * incomeAndCostBtnHeight
        
        setupRotateLayers(CGRectMake(0, incomeAndCostBtnHeight * 2, frame.width, layersHeight))
        
        if layerData.count > 0{
            reloadDataInPieChartView(layerData[0])
        }
    }
    
    private  func setupRotateLayers(frame:CGRect){

        let bgView = UIView(frame: frame)
        self.layerBgView = bgView
        
        let titleLabel = setupTitleLabel(frame)
        let moneyLabel = setupMoneyLabel(frame)
        let redIndicator = setupIndicator(frame)
        let midRoundBtn = setupIconBtn(frame)
        let midPercentLabel = setupPercentageLabel(frame)
        let countLabel = setupCountLabel(frame)
        let rotateBtn = setupRotateBtn(frame)
        let containerLayer = setupContainerLayer(frame)
        
        bgView.layer.addSublayer(containerLayer)
        bgView.addSubview(countLabel)
        bgView.addSubview(midPercentLabel)
        bgView.addSubview(midRoundBtn)
        bgView.addSubview(moneyLabel)
        bgView.addSubview(titleLabel)
        bgView.addSubview(redIndicator)
        bgView.addSubview(rotateBtn)
        self.addSubview(bgView)
    }
    
    func setupContainerLayer(frame:CGRect)->CAShapeLayer {
        let containerLayer = CAShapeLayer()
        containerLayer.frame = CGRectMake(0, 0, frame.width, frame.height)
        containerLayer.addSublayer(generateLayers(frame, color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8), percentageStart: 0, percentageEnd: 1))
        var percentageStart:CGFloat = 0
        var percentageEnd:CGFloat = 0
        
        for (_, value) in dataItem.enumerate(){
            percentageEnd += value / itemValueAmount
            let pieLayer = generateLayers(frame, color: nil, percentageStart: percentageStart, percentageEnd: percentageEnd)
            containerLayer.addSublayer(pieLayer)
            percentageStart = percentageEnd
        }
        self.containerLayer = containerLayer
        
        if layerData.count > 0{
            let initRotateRadian = -CGFloat(M_PI) * dataItem[0] / itemValueAmount
            rotateContainerLayerWithRadian(initRotateRadian)
        }
        
        return containerLayer
    }
    
    private func setupTitleLabel(frame:CGRect)->UILabel{
        let titleLabel = UILabel(frame: CGRectMake(frame.width/2 - titleLabelHeight, titleLabelY, titleLabelHeight * 2, titleLabelHeight))
        titleLabel.textAlignment = .Center
        itemTitleLabel = titleLabel
        return titleLabel
    }
    private func setupMoneyLabel(frame:CGRect)->UILabel{
        let moneyLabel = UILabel(frame: CGRectMake(0, 0, moneyLabelHeight * 2, moneyLabelHeight))
        moneyLabel.textAlignment = .Center
        moneyLabel.center = CGPointMake(frame.width/2, titleLabelHeight + titleLabelY)
        itemMoneyLabel = moneyLabel
        return moneyLabel
    }
    private func setupIndicator(frame:CGRect)->UIView{
        let redIndicator = UIView(frame: CGRectMake(0, 0, 1, redIndicatorHeight))
        redIndicator.center = CGPointMake(frame.width/2, frame.height/2 - frame.width/4 - redIndicatorHeight )
        redIndicator.backgroundColor = UIColor.redColor()
        return redIndicator
    }
    
    private func setupIconBtn(frame:CGRect)->UIButton{
        let midRoundBtn = UIButton(frame: CGRectMake(0, 0, midRoundBtnWidth, midRoundBtnWidth))
        midRoundBtn.center = CGPointMake(frame.width/2, frame.height/2 - midRoundBtnWidth/2)
        itemIconBtn = midRoundBtn
        return midRoundBtn
    }
    private func setupPercentageLabel(frame:CGRect)->UILabel{
        let midPercentLabel = UILabel(frame: CGRectMake(0, 0, midRoundBtnWidth, midRoundBtnWidth))
        midPercentLabel.center = CGPointMake(frame.width/2, frame.height/2 + midRoundBtnWidth/2)
        midPercentLabel.textAlignment = .Center
        itemPercentage = midPercentLabel
        return midPercentLabel
    }
    
    
    
    private func setupCountLabel(frame:CGRect)->UILabel {
        let countLabel = UILabel(frame: CGRectMake(0, 0, midRoundBtnWidth, midRoundBtnWidth))
        countLabel.center = CGPointMake(frame.width/2, frame.height/2 + frame.width/4 + 40)
        countLabel.textAlignment = .Center
        itemAccountCount = countLabel
        return countLabel
    }
    
    private func setupRotateBtn(frame:CGRect)->UIButton {
        let rotateBtnX = (frame.width - rotateBtnWidth) / 2
        let rotateBtnY =  frame.height - rotateBtnMarginBottom - rotateBtnWidth
        let rotateBtn = UIButton(frame: CGRectMake(rotateBtnX, rotateBtnY, rotateBtnWidth, rotateBtnWidth))
        rotateBtn.setImage(UIImage(named: "btn_pieChart_rotation"), forState: .Normal)
        rotateBtn.addTarget(self, action: "rotateAction:", forControlEvents: .TouchUpInside)
        return rotateBtn
    }
    
    private func gradientMaskAnimation(frame:CGRect){
        
        containerLayer.mask = generateLayers(frame, color: nil, percentageStart: 0, percentageEnd: 1)
        let gradientAnimation = CABasicAnimation(keyPath: "strokeEnd")
        gradientAnimation.fromValue = 0
        gradientAnimation.toValue = 1
        gradientAnimation.duration = 0.5
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        containerLayer.mask?.addAnimation(gradientAnimation, forKey: "gradientAnimation")
    }
    
    private func generateLayers(frame: CGRect, color:UIColor?, percentageStart:CGFloat, percentageEnd:CGFloat) -> CAShapeLayer{
        
        let path = UIBezierPath(arcCenter: CGPointMake(frame.width/2, frame.height/2), radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(3 * M_PI_2) , clockwise: true)
        let pieLayer = CAShapeLayer()
        pieLayer.path = path.CGPath
        pieLayer.lineWidth = lineWidth
        if let col = color?.CGColor{
            pieLayer.strokeColor = col
        }
        else{
            pieLayer.strokeColor = UIColor(hue: percentageEnd, saturation: 0.5, brightness: 0.75, alpha: 1.0).CGColor
        }
        
        pieLayer.fillColor = nil
        pieLayer.strokeStart = percentageStart
        pieLayer.strokeEnd = percentageEnd
        return pieLayer
    }
    
    private func rotateContainerLayerWithRadian(radian:CGFloat){
        
        let myAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let myRotationTransform = CATransform3DRotate(containerLayer.transform, radian, 0, 0, 1)
        if let rotationAtStart = containerLayer.valueForKeyPath("transform.rotation") {
            
            myAnimation.fromValue = rotationAtStart.floatValue
            myAnimation.toValue = CGFloat(rotationAtStart.floatValue) + radian
        }
        containerLayer.transform = myRotationTransform
        myAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        containerLayer.addAnimation(myAnimation, forKey: "transform.rotation")
    }

}
