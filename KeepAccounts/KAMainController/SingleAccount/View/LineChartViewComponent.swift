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
private let backColumnLineWidth:CGFloat = 0.5
private let dotWidth:CGFloat = 6
private let labelWidth:CGFloat = 20
private let labelHeight:CGFloat = 20

private let backColumnLineCount = 31

class LineChartViewComponent: UIView {
    
    //properties (private)
    var pointDataItem:[Float]!
    var infoDataItem:[LineChartInfoData]!
    
    //init
    init(frame:CGRect, pointDataItem:[Float], infoDataItem:[LineChartInfoData]){
        self.pointDataItem = pointDataItem
        self.infoDataItem = infoDataItem
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        //draw back column line
        let backColumnAverWidth = bounds.width / CGFloat(backColumnLineCount + 1)
        let backColumnAverHeight = bounds.height - chartTop - chartBottom
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
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 16)!,
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
            dotPath.lineWidth = 0.5
            dotPath.stroke()
            dotPath.fill()
        }
        
        
    }
}
