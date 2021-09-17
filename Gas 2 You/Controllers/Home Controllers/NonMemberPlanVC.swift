//
//  NonMemberPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 17/08/21.
//

import UIKit

class NonMemberPlanVC: BaseVC {

    @IBOutlet weak var planIV: UIImageView!
    @IBOutlet weak var lblServiceChargeEvery: ThemeLabel!
    @IBOutlet weak var lblServiceChargePriceTag: ThemeLabel!
    @IBOutlet weak var lblTyrePressureCheck: ThemeLabel!
    @IBOutlet weak var lblTyrePressurePriceTag: ThemeLabel!
    @IBOutlet weak var lblWindShield: ThemeLabel!
    @IBOutlet weak var lblWindShieldPriceTag: ThemeLabel!
    @IBOutlet weak var btnPayNow: ThemeButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Select Plan", isTitlewhite: false, controller: self)
    }

    @IBAction func btnPayNowTap(_ sender: ThemeButton) {
        let memberPlanVC: MemberPlanVC = MemberPlanVC.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(memberPlanVC, animated: true)
    }
    
    
}
