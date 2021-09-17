//
//  LogInVC.swift
//  Gas 2 You
//
//  Created by MacMini on 29/07/21.
//

import UIKit

class LogInVC: UIViewController {

    class func getNewInstance() -> LogInVC {
        UIStoryboard(storyboard: .auth).instantiate()
    }

    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var txtPassword: ThemeTextfield!
    @IBOutlet weak var btnSignUp: ThemeButton!
    @IBOutlet weak var btnLogin: ThemeButton!

    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        fillDummy()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func fillDummy() {
        txtEmail.text = "kaushik.dangar@excellentwebworld.inn"
        txtPassword.text = "12345678"
    }

    func setupUI() {
        btnSignUp.setunderline(title: btnSignUp.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        setupTextfields(textfield: txtPassword)
    }

    private func setupTextfields(textfield: UITextField) {

        textfield.rightViewMode = .always
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 40))
        button.setTitle("Forgot?", for: .normal)
        button.setColorFont(color:.lightGreyBtn , font: CustomFont.PoppinsMedium.returnFont(14))
        button.addTarget(self, action: #selector(navigateToForgotPassword), for: .touchUpInside)
        let view = UIView(frame : CGRect(x: 0, y: 0, width: 80, height: 40))
        view.addSubview(button)
        textfield.rightView = view
    }

    private func bindViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            switch change {
            case .loaderStart:
                self.btnLogin.showLoading()
            case .loaderEnd:
                self.btnLogin.hideLoading()
            case .authSucceed:
                Constants.appDel.navigateToHome()
            case .showToast(let title, let message, let state):
                Toast.show(title: title, message: message, state: state)
            }
        }
    }

    @IBAction func logInButtonPreesed(_ sender: ThemeButton) {
        view.endEditing(true)
        viewModel.doLogin(email: txtEmail.getText(),
                          password: txtPassword.getText(),
                          passwordPlaceholder: txtPassword.placeholder)
    }
    
    @IBAction func signUpButtonPressed(_ sender: ThemeButton) {
        self.push(SignUpVC.getNewInstance())
    }
    
    @objc func navigateToForgotPassword(){
        self.push(ForgotPasswordVC.getNewInstance())
    }
}

// MARK: - TextField delegate
extension LogInVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}
