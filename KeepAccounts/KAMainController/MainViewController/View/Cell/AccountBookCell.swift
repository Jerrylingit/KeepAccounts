//
//  AccountBookCell.swift
//  KeepAccounts
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class AccountBookCell: UICollectionViewCell {

    @IBOutlet weak var selectedFlag: UIImageView!
    @IBOutlet weak var accountCounts: UILabel!
    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var accountBackImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //重用前做一些必要的初始化
    override func prepareForReuse() {
        
    }

}
