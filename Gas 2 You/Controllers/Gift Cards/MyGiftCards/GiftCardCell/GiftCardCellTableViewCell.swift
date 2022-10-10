//
//  GiftCardCellTableViewCell.swift
//  Gas 2 You
//
//  Created by Tej P on 03/05/22.
//

import UIKit

class GiftCardCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var vWFront: UIView!
    @IBOutlet weak var vWBack: UIView!
    @IBOutlet weak var lblAmount: ThemeLabel!
    @IBOutlet weak var lblValidTill: ThemeLabel!
    @IBOutlet weak var lblSenderName: ThemeLabel!
    @IBOutlet weak var lblSenderEmail: ThemeLabel!
    @IBOutlet weak var lblSenderMessage: ThemeLabel!
    @IBOutlet weak var btnViewDetails: ThemeButton!
    @IBOutlet weak var btnBack: ThemeButton!
    @IBOutlet weak var btnCopy: ThemeButton!
    @IBOutlet weak var lblCode: ThemeLabel!
    
    var btnDetailClosure : (()->())?
    var btnBackClosure : (()->())?
    var btnCopyClosure : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI(){
        self.vWBack.isHidden = true  
    }
    
    @IBAction func btnViewDetailsAction(_ sender: Any) {
        if let click = self.btnDetailClosure{
            click()
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if let click = self.btnBackClosure{
            click()
        }
    }
    
    @IBAction func btnCopyAction(_ sender: Any) {
        if let click = self.btnCopyClosure{
            click()
        }
    }
}
