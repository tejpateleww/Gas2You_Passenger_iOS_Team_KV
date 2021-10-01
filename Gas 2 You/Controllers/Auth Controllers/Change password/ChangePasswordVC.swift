//
//  ChangePasswordVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class ChangePasswordVC: BaseVC {

    class func getNewInstance() -> ChangePasswordVC {
        UIStoryboard(storyboard: .auth).instantiate()
    }
    
    @IBOutlet weak var imgG2U: UIImageView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var txtCurrentPassword: ThemeTextfield!
    @IBOutlet weak var txtNewPassword: ThemeTextfield!
    @IBOutlet weak var txtReEnterPassword: ThemeTextfield!
    @IBOutlet weak var btnSave: ThemeButton!

    private var viewModel = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func setupUI() {
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Change Password", isTitlewhite: true, controller: self)
    }

    private func bindViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            switch change {
            case .loaderStart:
                self.btnSave.showLoading()
            case .loaderEnd:
                self.btnSave.hideLoading()
            case .authSucceed(let message):
                Utilities.showAlertAction(Constants.appName, message: message ?? "", vc: self) {
                    self.goBack()
                }
                break
            case .showToast(let title, let message, let state):
                Toast.show(title: title, message: message, state: state)
            }
        }
    }
    
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        view.endEditing(true)
        let values = ChangePasswordViewModel.Values(currentPass: txtCurrentPassword.getText(),
                                                    newPass: txtNewPassword.getText(),
                                                    confPass: txtReEnterPassword.getText(),
                                                    currentPassPlaceholder: txtCurrentPassword.placeholder ?? "",
                                                    newPassPlaceholder: txtNewPassword.placeholder ?? "",
                                                    confPassPlaceholder: txtReEnterPassword.placeholder ?? "")
        viewModel.changePassword(values)
    }
}

// MARK: - TextField delegate
extension ChangePasswordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtCurrentPassword:
            txtNewPassword.becomeFirstResponder()
        case txtNewPassword:
            txtReEnterPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newString.hasPrefix(" "){
            textField.text = ""
            return false
        }
        
        return true
    }
}
