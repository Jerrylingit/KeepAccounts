//
//  KAHorizIndicatorView.swift
//  KeepAccounts
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit
import SnapKit

class KAHorizIndicatorView: UIView {
    
    private var percent:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPercentWithText(text:String){
        percent.text = text
        percent.sizeToFit()
    }
    
    private func setupViews(){
        let indicator = UIImageView(image: UIImage(named: "horizontal_red_line"))
        self.addSubview(indicator)
        indicator.snp_makeConstraints {[weak self](make) -> Void in
            if let weakSelf = self{
                make.centerY.equalTo(weakSelf)
                make.leading.equalTo(weakSelf)
                make.width.equalTo(10)
            }
        }
        
        let percent = UILabel()
        self.percent = percent
        self.addSubview(percent)
        percent.snp_makeConstraints {[weak self](make) -> Void in
            if let weakSelf = self{
                make.centerY.equalTo(weakSelf)
                make.leading.equalTo(indicator.snp_trailing)
            }
        }
    }
}
