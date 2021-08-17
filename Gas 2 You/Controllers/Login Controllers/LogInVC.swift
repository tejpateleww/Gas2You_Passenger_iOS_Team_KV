//
//  LogInVC.swift
//  Gas 2 You
//
//  Created by MacMini on 29/07/21.
//

import UIKit

class LogInVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtEmail: themeTextfield!
    @IBOutlet weak var txtPassword: themeTextfield!
    @IBOutlet weak var btnSignUp: themeButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.setunderline(title: btnSignUp.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        setupTextfields(textfield: txtPassword)
    }
    
    
    @IBAction func logInButtonPreesed(_ sender: ThemeButton) {
        AppDel.navigateToHome()
    }
    
    func setupTextfields(textfield : UITextField) {
        
        textfield.rightViewMode = .always
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 40))
        button.setTitle("Forgot?", for: .normal)
        button.setColorFont(color: .gray , font: CustomFont.PoppinsMedium.returnFont(14))
        button.addTarget(self, action: #selector(navigateToForgotPassword), for: .touchUpInside)
        let view = UIView(frame : CGRect(x: 0, y: 0, width: 80, height: 40))
        view.addSubview(button)
        textfield.rightView = view
        
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: themeButton) {
        let loginStory = UIStoryboard(name: "Login", bundle: nil)
        let signUpVC = loginStory.instantiateViewController(identifier: SignUpVC.className) as! SignUpVC
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func navigateToForgotPassword(){
        let loginStory = UIStoryboard(name: "Login", bundle: nil)
        let forgotpassVC = loginStory.instantiateViewController(identifier: ForgotPasswordVC.className) as! ForgotPasswordVC
        navigationController?.pushViewController(forgotpassVC, animated: true)
    }
    
    
}
