//
//  InProgressCell.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit
import UIView_Shimmer

class InProgressCell: UITableViewCell,ShimmeringViewProtocol {

    
    @IBOutlet weak var lblServices: ThemeLabel!
    @IBOutlet weak var lblVehicleDetails: ThemeLabel!
    @IBOutlet weak var lblLocation: ThemeLabel!
    @IBOutlet weak var lblTimeandDate: ThemeLabel!
    @IBOutlet weak var btnCall: ThemeButton!
    @IBOutlet weak var btnChat: ThemeButton!
    @IBOutlet weak var imgTruck: UIImageView!
    @IBOutlet weak var lblOnTheWay: ThemeLabel!
    @IBOutlet weak var imgPetrol: UIImageView!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblBookingID: UILabel!
    var chatClick : (()->())?
    var shimmeringAnimatedItems: [UIView] {
           [
            lblServices,
            lblVehicleDetails,
            lblLocation,
            lblTimeandDate,
            imgCar,
            imgPetrol,
            imgLocation,
            imgCalender,
            imgTruck,
            lblOnTheWay,
            btnCall,
            btnChat,
            lblBookingID
           ]
       }
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnActionchat(_ sender: UIButton) {
        if let btnclicked = chatClick {
            btnclicked()
        }
    }
}
