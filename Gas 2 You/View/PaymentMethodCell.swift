//
//  PaymentMethodCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 25/11/21.
//

import UIKit

class PaymentMethodCell: UITableViewCell {
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var btnSelected: UIButton!
    @IBOutlet weak var vwRadius: ThemeView!
    
    @IBOutlet weak var btnPayClick: ThemeButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var payClick : (()->())?
    @IBAction func btnPayClick(_ sender: Any) {
        if let click = self.payClick{
            click()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
