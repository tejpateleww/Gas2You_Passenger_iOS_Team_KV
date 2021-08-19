//
//  SignUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit

class SignUpVC: BaseVC {

    @IBOutlet weak var btnLoginNow: themeButton!
    @IBOutlet weak var txtPhoneNo: themeTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLoginNow.setunderline(title: btnLoginNow.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        txtPhoneNo.leftView = paddingView
        txtPhoneNo.leftViewMode = .always
        txtPhoneNo.layer.borderWidth = 1
        txtPhoneNo.layer.borderColor = UIColor.white.cgColor
        txtPhoneNo.layer.cornerRadius = 8
    }
    
    @IBAction func btnSignupTap(_ sender: ThemeButton) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        AppDel.navigateToHome()
    }
    
    @IBAction func logInNowButtonPressed(_ sender: themeButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTextfields(textfield : UITextField) {
        
        textfield.leftViewMode = .always
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 40))
        button.setTitle("Forgot?", for: .normal)
        button.setColorFont(color: .gray , font: CustomFont.PoppinsMedium.returnFont(14))
//        button.addTarget(self, action: #selector(navigateToForgotPassword), for: .touchUpInside)
        let view = UIView(frame : CGRect(x: 0, y: 0, width: 80, height: 40))
        view.addSubview(button)
        textfield.leftView = view
        
        
        
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
