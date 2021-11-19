//
//  ChatListShimmerCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 15/11/21.
//

import UIKit
import UIView_Shimmer

class ChatListShimmerCell: UITableViewCell,ShimmeringViewProtocol {

    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    var shimmeringAnimatedItems: [UIView]{
        [
            vwProfile,
            lblName,
            lblMessage
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwProfile.layer.cornerRadius = 30
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
