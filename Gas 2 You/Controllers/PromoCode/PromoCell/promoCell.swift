//
//  promoCell.swift
//  Gas 2 You
//
//  Created by Tej P on 27/04/22.
//

import UIKit

class promoCell: UITableViewCell {
    
    @IBOutlet weak var vWContainer: UIView!
    @IBOutlet weak var vWPromoCode: UIView!
    @IBOutlet weak var lblPromoCode: ThemeLabel!
    @IBOutlet weak var lblShortDesc: ThemeLabel!
    @IBOutlet weak var lblFullDesc: ThemeLabel!
    @IBOutlet weak var vWBootm: UIView!
    @IBOutlet weak var btnTC: ThemeButton!
    @IBOutlet weak var btnApply: ThemeButton!
    @IBOutlet weak var lblErrorMessage: ThemeLabel!
    
    var btnTCClosure : (()->())?
    var btnApplyClosure : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vWContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWContainer.layer.masksToBounds = false
        self.vWContainer.layer.shadowRadius = 4
        self.vWContainer.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWContainer.layer.cornerRadius = 10
        self.vWContainer.layer.shadowOpacity = 0.15
        
        self.vWPromoCode.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1).withAlphaComponent(0.3)
        self.vWBootm.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1).withAlphaComponent(0.3)
        self.vWPromoCode.layer.cornerRadius = 5
        
        self.vWBootm.clipsToBounds = true
        self.vWBootm.layer.cornerRadius = 10
        self.vWBootm.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.lblErrorMessage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnTCAction(_ sender: Any) {
        if let click = self.btnTCClosure{
            click()
        }
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        if let click = self.btnApplyClosure{
            click()
        }
    }
    
}
