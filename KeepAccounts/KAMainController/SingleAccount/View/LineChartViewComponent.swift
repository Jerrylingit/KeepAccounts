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

private let backColumnLineCount = 31

class LineChartViewComponent: UIView {
    
    //properties (private)
    
    //init
    override init(frame:CGRect){
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
        
        let path = UIBezierPath()
        for i in 1...backColumnLineCount{
            let columnX = backColumnAverWidth * CGFloat(i)
            path.moveToPoint(CGPoint(x: columnX, y: 0))
            path.addLineToPoint(CGPoint(x: columnX, y: backColumnAverHeight))
        }
        UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7).setStroke()
        path.stroke()
        
    }
}
