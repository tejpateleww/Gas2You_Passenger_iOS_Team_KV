//
//  shimmerCell.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 12/11/21.
//

import UIKit
import UIView_Shimmer

class shimmerCell: UITableViewCell,ShimmeringViewProtocol {
    @IBOutlet weak var lblService: ThemeLabel!
    @IBOutlet weak var lblVehicleDetail: ThemeLabel!
    @IBOutlet weak var lblLocation: ThemeLabel!
    @IBOutlet weak var lblDateandTime: ThemeLabel!
    @IBOutlet weak var btnCancel: ThemeButton!
    @IBOutlet weak var imgCar : UIImageView!
    @IBOutlet weak var imgPetrol: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    var shimmeringAnimatedItems: [UIView]{
        [
            lblService,
            lblVehicleDetail,
            lblLocation,
            lblDateandTime,
            btnCancel,
            imgCar,
            imgPetrol,
            imgLocation,
            imgCalender
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
