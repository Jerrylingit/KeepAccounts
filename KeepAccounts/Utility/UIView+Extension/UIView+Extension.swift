//
//  UIView+Extension.swift
//  KeepAccounts
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 jerry. All rights reserved.
//

import Foundation

extension UIView{
    var height:CGFloat{
        get{
            return self.frame.height
        }
        set(newValue){
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    var width:CGFloat{
        get{
            return self.frame.width
        }
        set(newValue){
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    var centerX:CGFloat{
        get{
            return self.center.x
        }
        set(newValue){
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    var centerY:CGFloat{
        get{
            return self.center.y
        }
        set(newValue){
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
}