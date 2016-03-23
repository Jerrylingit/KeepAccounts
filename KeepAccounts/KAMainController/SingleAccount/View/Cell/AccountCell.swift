//
//  AccountCell.swift
//  KeepAccounts
//
//  Created by admin on 16/3/10.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit
typealias presentVCResponder = (UIViewController, Bool, (()->Void)?)->Void
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
    var cellID:Int?
    var isHiddenSubview = false
    var presentVCBlock:presentVCResponder?
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
        let model = ChooseItemModel()
        model.dataBaseId = cellID ?? 0
        model.mode = "edit"
        let editChooseItemVC = ChooseItemVC(model: model)
        if let block = presentVCBlock{
            block(editChooseItemVC, true, nil)
        }
        print("edit")
    }
    @IBAction func clickDeleteBtn(sender: AnyObject) {
        let alertView = UIAlertController(title: "删除账目", message: "您确定要删除吗？", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "确定", style: .Default){(action) in
            if let ID = self.cellID{
                AccoutDB.deleteDataWith(ID)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeDataSource", object: self)
        })
        if let block = presentVCBlock{
            block(alertView, true, nil)
        }
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
        dealWithSubView(1.0)
        dealWithBtns(0.0)
    }
}

extension AccountCell{
    func configAccountCell(){
        
    }
}
