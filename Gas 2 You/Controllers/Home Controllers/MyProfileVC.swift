//
//  MyProfileVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class MyProfileVC: BaseVC {

    @IBOutlet weak var changePassButton: ThemeButton!
    @IBOutlet weak var lblFullName: ThemeLabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblEmail: ThemeLabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblMobile: ThemeLabel!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var lblMyGarage: ThemeLabel!
    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var btnSave: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Profile", controller: self)
        
        changePassButton.layer.cornerRadius = 10
        changePassButton.layer.borderWidth = 2
        changePassButton.layer.borderColor = UIColor.appColor(.themeBlue).cgColor
        changePassButton.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(14)
        changePassButton.setTitleColor(UIColor.appColor(.themeBlue), for: .normal)
    }
    
    @IBAction func btnMyGarageTap(_ sender: UIButton) {
        let myGarageVC: MyGarageVC = MyGarageVC.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(myGarageVC, animated: true)
    }
    
    @IBAction func btnChangePasswordTap(_ sender: ThemeButton) {
        self.push(ChangePasswordVC.getNewInstance())
    }
    
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        dismiss(animated: true, completion: nil)
    }
}
