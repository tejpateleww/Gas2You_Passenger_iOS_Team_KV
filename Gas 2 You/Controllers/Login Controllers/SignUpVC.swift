//
//  SignUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit

class SignUpVC: BaseVC {

    @IBOutlet weak var btnLoginNow: themeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLoginNow.setunderline(title: btnLoginNow.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        
    }
    
    @IBAction func btnSignupTap(_ sender: ThemeButton) {
        AppDel.navigateToHome()
    }
    
    @IBAction func logInNowButtonPressed(_ sender: themeButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
