//
//  AccountBookCell.swift
//  KeepAccounts
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class AccountBookCell: UICollectionViewCell {

    @IBOutlet weak var highlightedView: UIView!
    @IBOutlet weak var selectedFlag: UIImageView!
    @IBOutlet weak var accountCounts: UILabel!
    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var accountBackImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
//        self.addGestureRecognizer(longPress)
    }
    //重用前做一些必要的初始化
    override func prepareForReuse() {
        showHighlightedView(false)
        selectedFlag.alpha = 0
        accountCounts.text = ""
        accountTitle.text = ""
        accountBackImage.image = nil
    }
    func longPressAction(sender:UILongPressGestureRecognizer){
        
    }
    func showDeepHighlightedView(bool:Bool){
        highlightedView.alpha = bool ? 0.7 : 0
    }
    func showHighlightedView(bool:Bool){
        highlightedView.alpha = bool ? 0.3 : 0
    }

}
