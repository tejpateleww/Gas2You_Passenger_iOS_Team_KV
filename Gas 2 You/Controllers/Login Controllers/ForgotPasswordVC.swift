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

        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Forgot Password", controller: self)
    }
    @IBAction func btnSubmitTap(_ sender: ThemeButton) {
        let changePassVC: ChangePasswordVC = ChangePasswordVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(changePassVC, animated: true)
    }
    
}
