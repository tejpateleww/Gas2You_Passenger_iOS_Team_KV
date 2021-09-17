//
//  SignUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit

class SignUpVC: BaseVC {

    class func getNewInstance() -> SignUpVC {
        UIStoryboard(storyboard: .auth).instantiate()
    }

    @IBOutlet weak var btnLoginNow: ThemeButton!
    @IBOutlet weak var txtFirstName: ThemeTextfield!
    @IBOutlet weak var txtLastName: ThemeTextfield!
    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var txtPhoneNo: ThemeTextfield!
    @IBOutlet weak var txtPassword: ThemeTextfield!
    @IBOutlet weak var txtConfirmPassword: ThemeTextfield!

    private let viewModel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        fillDummy()
    }

    private func fillDummy() {
        txtFirstName.text = "Gaurang"
        txtLastName.text = "Vyas"
        txtEmail.text = "vsgaurang@gmail.com"
        txtPhoneNo.text = "9712345678"
        txtPassword.text = "12345678"
        txtConfirmPassword.text = "12345678"
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func setupUI() {
        btnLoginNow.setunderline(title: btnLoginNow.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        setupPhoneTextField()
    }

    private func setupPhoneTextField() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        txtPhoneNo.font = FontBook.regular.of(size : 16)
        txtPhoneNo.leftView = paddingView
        txtPhoneNo.leftViewMode = .always
        txtPhoneNo.layer.borderWidth = 1
        txtPhoneNo.layer.borderColor = UIColor.white.cgColor
        txtPhoneNo.layer.cornerRadius = 8
    }

    private func bindViewModel() {
        viewModel.changeHandler = { change in
            switch change {
            case .loaderStart:
                Utilities.showHud()
            case .loaderEnd:
                Utilities.hideHud()
            case .credsValidated(let model):
                self.push(OtpVC.getNewInstance(model))
            case .showToast(let title, let message, let state):
                Toast.show(title: title, message: message, state: state)
            }
        }
    }
    
    @IBAction func btnSignupTap(_ sender: ThemeButton) {
        view.endEditing(true)
        let values = SignupViewModel.SignupValues(firstName: txtFirstName.getText(),
                                                  lastName: txtLastName.getText(),
                                                  email: txtEmail.getText(),
                                                  mobile: txtPhoneNo.getText(),
                                                  password: txtPassword.getText(),
                                                  confPassword: txtConfirmPassword.getText(),
                                                  passPlaceholder: txtPassword.placeholder ?? "",
                                                  confPassPlaceholder: txtConfirmPassword.placeholder ?? "",
                                                  firstNamePlaceholder: txtFirstName.placeholder ?? "",
                                                  lastNamePlaceholder: txtLastName.placeholder ?? "")
        viewModel.doRegister(values)
    }

}

// MARK: - TextField delegate
extension SignUpVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFirstName:
            txtLastName.becomeFirstResponder()
        case txtLastName:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            txtPhoneNo.becomeFirstResponder()
        case txtPhoneNo:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtConfirmPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == txtPhoneNo {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && range.location < 10
        }
        return true
    }

}

