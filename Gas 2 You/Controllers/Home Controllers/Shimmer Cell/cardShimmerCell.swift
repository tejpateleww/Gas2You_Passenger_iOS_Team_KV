//
//  cardShimmerCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 08/12/21.
//

import UIKit
import UIView_Shimmer

class cardShimmerCell: UITableViewCell,ShimmeringViewProtocol {

    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblCardNumber: ThemeLabel!
    @IBOutlet weak var lblExpirydate: ThemeLabel!
    @IBOutlet weak var lblDate: ThemeLabel!
    @IBOutlet weak var btnPay: ThemeButton!
    
    var shimmeringAnimatedItems: [UIView]{
        [
            self.imgCard,
            self.lblCardNumber,
            self.lblExpirydate,
            self.lblDate,
            self.btnPay
        ]
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
