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
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }



    @IBAction func submitTapped() {
        view.endEditing(true)
        if self.validation(){
            self.callForgotPasswordApi()
        }
    }

}

// MARK: - TextField delegate
extension ForgotPasswordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
extension ForgotPasswordVC{
    func validation() -> Bool{
        let txtTemp = UITextField()
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmailRequired = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtTemp.placeholder?.lowercased() ?? ""))
        let checkEmail = txtEmail.validatedText(validationType: .email)
        if(!checkEmailRequired.0){
            Utilities.ShowAlertOfValidation(OfMessage: "Please enter email")
            //Toast.show(title: AppInfo.appName, message: "Please enter email", state: .failure)
            return checkEmailRequired.0
        }else if(!checkEmail.0)
        {
            Utilities.ShowAlertOfValidation(OfMessage: checkEmail.1)
            return false
        }
        return true
    }
    func callForgotPasswordApi(){
        self.viewModel.forgotPasswordVC = self
        
        let reqModel = ForgotPasswordReqModel()
        reqModel.email = self.txtEmail.text ?? ""
        
        self.viewModel.webserviceForgotPassword(reqModel: reqModel)
    }
}
