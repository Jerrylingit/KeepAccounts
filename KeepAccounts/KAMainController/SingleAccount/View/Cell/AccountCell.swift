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
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var botmLine: UIView!
    @IBOutlet weak var dayIndicator: UIImageView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    var isHiddenSubview = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func clickIcon(sender: AnyObject) {
        isHiddenSubview = !isHiddenSubview
        let commonViewAlpha:CGFloat = isHiddenSubview ? 0.0 : 1.0
        let editAndDeleteAlpha:CGFloat = isHiddenSubview ? 1.0 : 0.0
        dealWithSubView(commonViewAlpha)
        dealWithBtns(editAndDeleteAlpha)
    }
    
    @IBAction func clickEditBtn(sender: AnyObject) {
        print("edit")
    }
    @IBAction func clickDeleteBtn(sender: AnyObject) {
        print("delete")
    }
    private func dealWithSubView(alpha:CGFloat){
        photoView.alpha = alpha
        iconTitle.alpha = alpha
        itemCost.alpha = alpha
        remark.alpha = alpha
    }
    private func dealWithBtns(alpha:CGFloat){
        deleteBtn.alpha = alpha
        editBtn.alpha = alpha
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        dayCost.text = ""
        date.text = ""
        photoView.image = nil
        itemCost.text = ""
        iconTitle.text = ""
        remark.text = ""
        botmLine.hidden = false
        topLine.hidden = false
        dayIndicator.hidden = true
        icon.setImage(nil, forState: .Normal)
    }
}

extension AccountCell{
    func configAccountCell(){
        
    }
}
