//
//  KACommonLabel.swift
//  KeepAccounts
//
//  Created by 林若琳 on 16/4/30.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit
import SnapKit

class KACommonLabel: UIView {
    
    private var upLabel:UILabel!
    private var downLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    convenience init(){
        self.init(frame: CGRect(x: 0,y: 0,width: 60, height: 60))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel(text:String) {
        upLabel.text = text
        upLabel.sizeToFit()
    }
    func setDownLabel(text:String) {
        downLabel.text = text
        downLabel.sizeToFit()
    }
    
    private func setupViews(){
        
        let downLabel = UILabel()
        downLabel.textAlignment = .Center
        downLabel.sizeToFit()
        self.downLabel = downLabel
        self.addSubview(downLabel)
        downLabel.snp_makeConstraints {[weak self] (make) in
            if let weakSelf = self{
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.bottom.equalTo(weakSelf.snp_bottom)
            }
        }
        let upperLabel = UILabel()
        upperLabel.textAlignment = .Center
        upperLabel.sizeToFit()
        self.upLabel = upperLabel
        self.addSubview(upperLabel)
        upperLabel.snp_makeConstraints {[weak self] (make) in
            if let weakSelf = self{
                make.centerX.equalTo(weakSelf.snp_centerX)
                make.top.equalTo(weakSelf.snp_top)
            }
        }
    }
}
