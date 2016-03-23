//
//  ComputedBoardLogic.swift
//  KeepAccounts
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

class ComputedBoardLogic:NSObject{
    
    //存放上一次的累加值
    private var result:Float = 0
    private var summand: Float = 0
    private var addend: Float = 0
    private var decimal:Float = 0
    private var numOfDecimal:Int = 0
    private var numOfInt = 0
    private var pressAdd = false
    private var pressEqual = false
    private var pressDot = false
    
    var okBtn = UIButton()
    
    var computedMoney:computedResultResponder?
    var pressOKClosure:(()->Void)?
    var pressIncomeAndCostClosure:(()->Void)?
    
    private func outOfDocMode(){
        pressDot = false
        numOfDecimal = 0
    }
    var date = 0
    var remark:String?
    var photoName:String?
    private func pressOK(){
        if let pressOKClosure = pressOKClosure{
            pressOKClosure()
        }
        
//        let item = AccountItem()
//        item.money = money.text ?? ""
//        item.iconTitle = title.text ?? ""
//        item.iconName = iconName
//        item.date = Int(accountTime!)
//        item.remark = remark ?? ""
//        item.photo = photoName ?? ""
//        AccoutDB.insertData(item);
//        NSNotificationCenter.defaultCenter().postNotificationName("ChangeDataSource", object: self)
//        if delegate?.respondsToSelector("onPressBack") != nil{
//            delegate?.onPressBack()
//        }
//        prepareForNextAssign()
    }
    private func pressIncomeAndCost(){
        if let pressIncomeAndCostClosure = pressIncomeAndCostClosure{
            pressIncomeAndCostClosure()
        }
    }
    
    func Compute(value:String){
        switch value {
        case "1","2", "3", "4", "5", "6", "7", "8", "9", "0" :
            //点击了+号
            if pressAdd {
                pressAdd = false
                addend = 0
            }
            //计算完一次
            if pressEqual {
                pressEqual = false
                addend = 0
            }
            
            if pressDot {
                numOfDecimal++
                
                if numOfDecimal <= 2 {
                    decimal = Float(value)! / Float(pow(10.0, Double(numOfDecimal)))
                    result = addend + decimal
                    if let computedMoney = computedMoney{
                        computedMoney(result)
                    }
                }
                else{
                    //超过两位小数
                }
            }
            else{
                numOfInt++
                if numOfInt <= 7 {
                    result = addend * 10.0 + Float(value)!
                    if let computedMoney = computedMoney{
                        computedMoney(result)
                    }
                }
                else{
                    //超过7位
                }
                
            }
            
            addend = result
            
        case "收/支":
            pressIncomeAndCost()
        case "C" :
            summand = 0
            addend = 0
            numOfInt = 0
            outOfDocMode()
            result = 0
            if let computedMoney = computedMoney{
                computedMoney(result)
            }
            okBtn.setTitle("OK", forState: .Normal)
        case "OK" :
            pressOK()
        case ".":
            pressDot = true
        case "+":
            pressAdd = true
            numOfInt = 0
            outOfDocMode()
            if addend != 0 {
                summand += addend
                addend = 0
            }
            result = summand
            if let computedMoney = computedMoney{
                computedMoney(result)
            }
            okBtn.setTitle("=", forState: .Normal)
            
        case "=":
            numOfInt = 0
            outOfDocMode()
            pressEqual = true
            okBtn.setTitle("OK", forState: .Normal)
            if addend != 0 {
                summand += addend
                addend = 0
            }
            result = summand
            if let computedMoney = computedMoney{
                computedMoney(result)
            }
            
        default:
            print("Error")
        }
        
    }
}