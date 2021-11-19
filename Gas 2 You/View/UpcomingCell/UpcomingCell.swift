//
//  UpcomingCell.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit
import UIView_Shimmer

class UpcomingCell: UITableViewCell,ShimmeringViewProtocol {

    @IBOutlet weak var lblService: ThemeLabel!
    @IBOutlet weak var lblVehicleDetail: ThemeLabel!
    @IBOutlet weak var lblLocation: ThemeLabel!
    @IBOutlet weak var lblDateandTime: ThemeLabel!
    @IBOutlet weak var btnCancel: ThemeButton!
    @IBOutlet weak var imgCar : UIImageView!
    @IBOutlet weak var imgPetrol: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblBookingid: UILabel!
    var shimmeringAnimatedItems: [UIView] {
           [
            lblService,
            lblVehicleDetail,
            lblLocation,
            lblDateandTime,
            btnCancel,
            imgCar,
            imgPetrol,
            imgLocation,
            imgCalender,
            lblBookingid
           ]
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var buttonCancel : (()->())?
    @IBAction func btnCancelClick(_ sender: Any) {
        if let click = self.buttonCancel{
            click()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
