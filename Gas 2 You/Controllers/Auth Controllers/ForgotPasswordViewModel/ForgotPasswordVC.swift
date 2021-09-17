//
//  ForgotPasswordVC.swift
//  Gas 2 You
//
//  Created by MacMini on 09/08/21.
//

import UIKit

class ForgotPasswordVC: BaseVC {

    class func getNewInstance() -> ForgotPasswordVC {
        UIStoryboard(storyboard: .auth).instantiate()
    }

    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var btnSubmit: ThemeButton!

    private let viewModel = ForgotPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Forgot Password", isTitlewhite: true, controller: self)
        bindViewModel()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func bindViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            switch change {
            case .loaderStart:
                self.btnSubmit.showLoading()
            case .loaderEnd:
                self.btnSubmit.hideLoading()
            case .authSucceed:
                break
            case .showToast(let title, let message, let state):
                Toast.show(title: title, message: message, state: state)
            }
        }
    }

    @IBAction func submitTapped() {
        view.endEditing(true)
        viewModel.submit(email: txtEmail.getText())
    }

}

// MARK: - TextField delegate
extension ForgotPasswordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
