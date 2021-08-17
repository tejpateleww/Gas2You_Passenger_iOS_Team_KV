//
//  SelectPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit

class MemberPlanVC: BaseVC {

    
    @IBOutlet weak var currentPlanIV: UIImageView!
    @IBOutlet weak var memberPlanDescriptionView: UIView!
    @IBOutlet var membershipPlanButtons: [ThemeButton]!
    @IBOutlet weak var btnPayNow: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Select Plan", controller: self)
        
        setUI()
    }
    
    @IBAction func membershipPlans(_ sender: ThemeButton) {
            
            for i in 0..<membershipPlanButtons.count {
                if sender.tag == i {
                    membershipPlanButtons[i].setImage(#imageLiteral(resourceName: "IC_selected"), for: .normal)
                } else {
                    membershipPlanButtons[i].setImage(#imageLiteral(resourceName: "IC_boxUnselected"), for: .normal)
                }
            }
    }
    
    
    @IBAction func btnPayNowTap(_ sender: ThemeButton) {
        
        
    }
    
    func setUI() {
        
        memberPlanDescriptionView.layer.cornerRadius = 5
        memberPlanDescriptionView.layer.borderWidth = 1
        memberPlanDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    

}
