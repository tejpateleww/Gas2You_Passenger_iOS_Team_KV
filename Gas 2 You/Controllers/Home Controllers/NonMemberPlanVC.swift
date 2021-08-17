//
//  NonMemberPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 17/08/21.
//

import UIKit

class NonMemberPlanVC: BaseVC {

    @IBOutlet weak var planIV: UIImageView!
    @IBOutlet weak var lblServiceChargeEvery: themeLabel!
    @IBOutlet weak var lblServiceChargePriceTag: themeLabel!
    @IBOutlet weak var lblTyrePressureCheck: themeLabel!
    @IBOutlet weak var lblTyrePressurePriceTag: themeLabel!
    @IBOutlet weak var lblWindShield: themeLabel!
    @IBOutlet weak var lblWindShieldPriceTag: themeLabel!
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
