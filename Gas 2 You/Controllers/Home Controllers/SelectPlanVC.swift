//
//  SelectPlanVC.swift
//  Gas 2 You
//
//  Created by MacMini on 11/08/21.
//

import UIKit

class SelectPlanVC: BaseVC {

    
    @IBOutlet weak var currentPlanIV: UIImageView!
    @IBOutlet weak var memberPlanOptionStack: UIStackView!
    @IBOutlet weak var memberPlanDescriptionView: UIView!
    @IBOutlet weak var nonMemberAvailServiceStack: UIStackView!
    @IBOutlet var membershipPlanButtons: [ThemeButton]!
    @IBOutlet var nonMemberPlanServiceIV: [UIImageView]! {
        didSet {
            for i in 0..<nonMemberPlanServiceIV.count {
                nonMemberPlanServiceIV[i].tag = i
            }
        }
    }
    @IBOutlet var nonMemberPlanServiceBtn: [UIButton]! {
        didSet {
            for i in 0..<nonMemberPlanServiceBtn.count {
                nonMemberPlanServiceBtn[i].tag = i
            }
        }
    }
    
    var isMember: Bool = true
    
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
    
    @IBAction func nonMemberServices(_ sender: UIButton) {
        
        if sender.tag == 0 {
            nonMemberPlanServiceBtn[sender.tag].isSelected.toggle()
            selectService(tag: sender.tag)
        } else if sender.tag == 1 {
            nonMemberPlanServiceBtn[sender.tag].isSelected.toggle()
            selectService(tag: sender.tag)
        }
        
    }
    
    func selectService(tag: Int) {
        if nonMemberPlanServiceBtn[tag].isSelected {
            nonMemberPlanServiceIV[tag].image = #imageLiteral(resourceName: "IC_selected")
        } else {
            nonMemberPlanServiceIV[tag].image = #imageLiteral(resourceName: "IC_boxUnselected")
        }
    }
    
    func setUI() {
        
        memberPlanDescriptionView.layer.cornerRadius = 5
        memberPlanDescriptionView.layer.borderWidth = 1
        memberPlanDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        
        if isMember {
            currentPlanIV.image = #imageLiteral(resourceName: "IC_member")
            memberPlanOptionStack.isHidden = false
            memberPlanDescriptionView.isHidden = false
            nonMemberAvailServiceStack.isHidden = true
        } else {
            currentPlanIV.image = #imageLiteral(resourceName: "IC_nonMember")
            memberPlanOptionStack.isHidden = true
            memberPlanDescriptionView.isHidden = true
            nonMemberAvailServiceStack.isHidden = false
        }
        
    }

    

}
