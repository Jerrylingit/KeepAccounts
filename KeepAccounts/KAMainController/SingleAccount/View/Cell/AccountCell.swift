//
//  AccountCell.swift
//  KeepAccounts
//
//  Created by admin on 16/3/10.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var dayCost: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var itemCost: UILabel!
    @IBOutlet weak var iconTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var botmLine: UIView!
    @IBOutlet weak var dayIndicator: UIImageView!
    @IBOutlet weak var topLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        dayCost.text = ""
        date.text = ""
        photoView.image = nil
        itemCost.text = ""
        iconTitle.text = ""
        icon.image = nil
        remark.text = ""
        botmLine.hidden = false
        topLine.hidden = false
        dayIndicator.hidden = true
        
    }
}

extension AccountCell{
    func configAccountCell(){
        
    }
}
