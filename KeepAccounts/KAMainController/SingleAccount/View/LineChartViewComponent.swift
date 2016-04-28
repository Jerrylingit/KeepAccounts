//
//  LineChartViewComponent.swift
//  KeepAccounts
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let chartTop:CGFloat = 20
private let chartBottom:CGFloat = 25
private let backColumnLineWidth:CGFloat = 1
private let dotWidth:CGFloat = 6
private let labelWidth:CGFloat = 20
private let labelHeight:CGFloat = 20

private let backColumnLineCount = 31

class LineChartViewComponent: UIView, UIGestureRecognizerDelegate {
    
    //properties (private)
    var pointDataItem:[Float]!
    var infoDataItem:[LineChartInfoData]!
    
    private var backColumnAverWidth:CGFloat{
        return bounds.width / CGFloat(backColumnLineCount + 1)
    }
    private var backColumnAverHeight:CGFloat{
        return bounds.height - chartTop - chartBottom
    }
    
    private var weekLabel:UILabel!
    private var dateLabel:UILabel!
    private var moneyLabel:UILabel!
    private var curPosLabel:UILabel!
    private var infoView:UIView!
    
    
    //init
    init(frame:CGRect, pointDataItem:[Float], infoDataItem:[LineChartInfoData]){
        self.pointDataItem = pointDataItem
        self.infoDataItem = infoDataItem
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        setupInfoView(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touched = touches.first
        if let location = touched?.locationInView(self){
            showInfoView(location)
        }
        
        infoView.hidden = false
        curPosLabel.hidden = false
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        infoView.hidden = true
        curPosLabel.hidden = true
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touched = touches.first
        
        if let location = touched?.locationInView(self){
            showInfoView(location)
        }
        
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        infoView.hidden = true
        curPosLabel.hidden = true
    }
    
    func showInfoView(point:CGPoint){
        let backColumnAverWidth = self.backColumnAverWidth
        
        var num = round((point.x)/backColumnAverWidth)
        if num == 0 {
            num = 1
        }
        else if num >= CGFloat(pointDataItem.count){
            num = CGFloat(pointDataItem.count)
        }
        let offsetX = num * backColumnAverWidth
        if offsetX < infoView.width/2{
            infoView.centerX = infoView.width/2
        }
        else if offsetX > self.width - infoView.width/2{
            infoView.centerX = self.width - infoView.width/2
        }
        else{
            infoView.centerX = offsetX
        }
        curPosLabel.x = offsetX
        let item = infoDataItem[Int(num - 1)]
        moneyLabel.text = String(item.money)
        dateLabel.text = item.date
        weekLabel.text = item.week
    }
    
    override func drawRect(rect: CGRect) {
        //draw back column line
        let backColumnAverWidth = self.backColumnAverWidth
        let backColumnAverHeight = self.backColumnAverHeight
        let pointCount = pointDataItem.count
        
        let context = UIGraphicsGetCurrentContext()
        
        //backPath
        let backPath = UIBezierPath()
        for i in 1...backColumnLineCount{
            let columnX = backColumnAverWidth * CGFloat(i)
            backPath.moveToPoint(CGPoint(x: columnX, y: 0))
            backPath.addLineToPoint(CGPoint(x: columnX, y: backColumnAverHeight))
        }
        UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7).setStroke()
        backPath.stroke()
        
        //linePath
        CGContextSaveGState(context)
        
        let linePath = UIBezierPath()
        let columnXPoint = {(i:Int)-> CGFloat in
            return  backColumnAverWidth * CGFloat(i + 1)
        }
        let maxElement = pointDataItem.maxElement() ?? 0
        let columnYPoint = {(i:Int)-> CGFloat in
            var y = CGFloat(self.pointDataItem[i]) / CGFloat(maxElement) * (backColumnAverHeight - 5)
            y = backColumnAverHeight - y
            return y
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)]
        for i in 0..<pointCount{
            linePath.moveToPoint(CGPoint(x: columnXPoint(i), y: columnYPoint(i)))
            if i + 1 < pointCount{
                linePath.addLineToPoint(CGPoint(x: columnXPoint(i + 1), y: columnYPoint(i + 1)))
            }
            
            var labelOrigin = CGPoint(x: columnXPoint(i), y: backColumnAverHeight + 10)
            labelOrigin.x -= labelWidth/2
            if pointCount == 29{
                if i % 3 == 0 && i < 27{
                    //draw num label
                    let label = NSString(format: "%d", i + 1)
                    label.drawInRect(CGRect(origin: labelOrigin, size: CGSize(width: labelWidth, height: labelHeight)), withAttributes: attrs)
                }
                if i == pointCount - 1{
                    //draw num label
                    let label = NSString(format: "%d", i + 1)
                    label.drawInRect(CGRect(origin: labelOrigin, size: CGSize(width: labelWidth, height: labelHeight)), withAttributes: attrs)
                }
            }
            else{
                if i % 3 == 0 || i == pointCount - 1{
                    let label = NSString(format: "%d", i + 1)
                    label.drawInRect(CGRect(origin: labelOrigin, size: CGSize(width: labelWidth, height: labelHeight)), withAttributes: attrs)
                }
            }
        }
        UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.7).setStroke()
        linePath.stroke()
        
        CGContextRestoreGState(context)
        
        //dotPath
        UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.7).setStroke()
        
        for i in 0..<pointCount {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(i))
            point.x -= dotWidth/2.0
            point.y -= dotWidth/2.0
            let dotPath = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: dotWidth, height: dotWidth)))
            if pointDataItem[i] > 0.001{
                UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).setFill()
            }
            else{
                UIColor.whiteColor().setFill()
            }
            dotPath.lineWidth = 1
            dotPath.stroke()
            dotPath.fill()
        }
    }
    func setupInfoView(frame:CGRect){
        
        let infoViewWidth:CGFloat = bounds.width/4
        let infoViewlHeight:CGFloat = 40
        
        
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: infoViewWidth, height: infoViewlHeight))
        infoView.backgroundColor = UIColor.orangeColor()
        infoView.layer.cornerRadius = 5
        
        let moneyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: infoViewWidth, height: infoViewlHeight/2))
        moneyLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
        moneyLabel.text = "1000000.00"
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: infoViewlHeight/2, width: infoViewWidth/2 , height: infoViewlHeight/2))
        dateLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11)
        dateLabel.textAlignment = .Left
        dateLabel.text = "04月12日"
        
        let weekLabel = UILabel(frame: CGRect(x: infoViewWidth/2, y: infoViewlHeight/2, width: infoViewWidth/2, height: infoViewlHeight/2))
        weekLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11)
        weekLabel.textAlignment = .Right
        weekLabel.text = "星期六"
        
        let curPosLabel = UILabel(frame: CGRect(x: 10, y: infoViewlHeight, width: 1, height: self.backColumnAverHeight - infoViewlHeight))
        curPosLabel.backgroundColor = UIColor.orangeColor()
        
        
        infoView.addSubview(moneyLabel)
        infoView.addSubview(dateLabel)
        infoView.addSubview(weekLabel)
        
        self.weekLabel = weekLabel
        self.dateLabel = dateLabel
        self.moneyLabel = moneyLabel
        self.curPosLabel = curPosLabel
        self.infoView = infoView
        infoView.hidden = true
        curPosLabel.hidden = true
        self.addSubview(infoView)
        self.addSubview(curPosLabel)
    }
}
