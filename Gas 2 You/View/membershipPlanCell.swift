//
//  membershipPlanCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 28/09/21.
//

import UIKit

class membershipPlanCell: UITableViewCell {

    @IBOutlet weak var lblPrice: ThemeLabel!
    @IBOutlet weak var icCheck: UIImageView!
    @IBOutlet weak var lblDetails: ThemeLabel!
    @IBOutlet weak var lblDescription: ThemeLabel!
    @IBOutlet weak var memberPlanDescriptionView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
