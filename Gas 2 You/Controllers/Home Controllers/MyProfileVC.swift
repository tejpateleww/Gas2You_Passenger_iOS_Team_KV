//
//  MyProfileVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class MyProfileVC: BaseVC {

    @IBOutlet weak var changePassButton: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Profile", controller: self)
        
        changePassButton.layer.cornerRadius = 10
        changePassButton.layer.borderWidth = 2
        changePassButton.layer.borderColor = UIColor.appColor(.themeBlue).cgColor
        changePassButton.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(14)
        changePassButton.setTitleColor(UIColor.appColor(.themeBlue), for: .normal)
    }
    

    

}
