//
//  AddAddressVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class AddAddressVC: BaseVC {
    
    @IBOutlet var locationButtons: [ThemeButton]! {
        didSet {
            for i in 0..<locationButtons.count {
                locationButtons[i].tag = i
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add Address", controller: self)
    }
    
    @IBAction func locationButtonPressed(_ sender: ThemeButton) {

        switch sender.tag {
        case 0:
            deSelectOtherButtons(tag: sender.tag)
            break
        case 1:
            deSelectOtherButtons(tag: sender.tag)
            break
        default:
            break
        }
        
    }
    
    
    func deSelectOtherButtons(tag: Int) {
        
        for i in 0..<locationButtons.count {
            if tag == i {
                locationButtons[i].setImage(#imageLiteral(resourceName: "IC_selected"), for: .normal)
            } else {
                locationButtons[i].setImage(#imageLiteral(resourceName: "IC_boxUnselected"), for: .normal)
            }
        }
    }
    
}
