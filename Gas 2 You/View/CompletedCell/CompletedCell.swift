//
//  CompletedCell.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit
import UIView_Shimmer

class CompletedCell: UITableViewCell, ShimmeringViewProtocol{

    @IBOutlet weak var lblTopHalf: ThemeLabel!
    @IBOutlet weak var viewTopHalf: UIView!
    @IBOutlet weak var lblServices: ThemeLabel!
    @IBOutlet weak var lblVehicleDetails: ThemeLabel!
    @IBOutlet weak var lblLocation: ThemeLabel!
    @IBOutlet weak var imgPetrol: UIImageView!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblTimeandDate: ThemeLabel!
    var shimmeringAnimatedItems: [UIView] {
           [
            lblServices,
            lblVehicleDetails,
            lblLocation,
            lblTimeandDate,
            lblTopHalf,
            viewTopHalf,
            imgCar,
            imgPetrol,
            imgLocation,
            imgCalender
           ]
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTopHalf?.layer.masksToBounds = true
        viewTopHalf?.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
