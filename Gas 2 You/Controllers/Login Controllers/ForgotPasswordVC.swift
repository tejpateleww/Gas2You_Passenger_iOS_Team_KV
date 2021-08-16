//
//  ForgotPasswordVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class ForgotPasswordVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Forgot Password", isTitlewhite: true, controller: self)
    }
    @IBAction func btnSubmitTap(_ sender: ThemeButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
