//
//  ChangePasswordVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class ChangePasswordVC: BaseVC {
    
    
    @IBOutlet weak var imgG2U: UIImageView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var txtCurrentPassword: themeTextfield!
    @IBOutlet weak var txtNewPassword: themeTextfield!
    @IBOutlet weak var txtReEnterPassword: themeTextfield!
    @IBOutlet weak var btnSave: ThemeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Change Password", isTitlewhite: true, controller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
