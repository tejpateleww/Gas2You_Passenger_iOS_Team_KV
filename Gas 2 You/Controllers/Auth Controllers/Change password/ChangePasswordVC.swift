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

    var viewModel = ChangePasswordViewModel()
    var isApiCalling : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNewPassword.delegate = self
        txtCurrentPassword.delegate = self
        txtReEnterPassword.delegate = self
        
        setupUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func setupUI() {
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Change Password", isTitlewhite: true, controller: self)
    }
    
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        view.endEditing(true)
        if isApiCalling{
            return
        }
        if self.validation(){
//            let trimmed = txtNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            if trimmed!.isEmpty == true{
//                Utilities.ShowAlert(OfMessage: "Your password can’t start or end with a blank space")
//            }
            callChangePasswordApi()
        }
    }
    func popBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
extension ChangePasswordVC{
    
    func validation()->Bool{
        var strTitle : String?
        let oldPassword = self.txtCurrentPassword.validatedText(validationType: .password(field: self.txtCurrentPassword.placeholder?.lowercased() ?? ""))
        let newPassword = self.txtNewPassword.validatedText(validationType: .password(field: self.txtNewPassword.placeholder?.lowercased() ?? ""))
        let confirmPassword = self.txtReEnterPassword.validatedText(validationType: .requiredField(field: self.txtReEnterPassword.placeholder?.lowercased() ?? ""))
        
        if !oldPassword.0{
            strTitle = oldPassword.1
        }else if !newPassword.0{
            strTitle = newPassword.1
        }else if !confirmPassword.0{
            strTitle = confirmPassword.1
        }else if self.txtNewPassword.text != self.txtReEnterPassword.text{
            strTitle = "New password & confirm password should be same."
        }
        
        if let str = strTitle{
            Utilities.ShowAlertOfValidation(OfMessage: str)
            //Toast.show(title: UrlConstant.Required, message: str, state: .failure)
            return false
        }
        
        return true
    }
    
    func callChangePasswordApi(){
        self.viewModel.changePasswordVC = self
        
        let reqModel = ChangePasswordReqModel()
        reqModel.oldPassword = self.txtCurrentPassword.text ?? ""
        reqModel.newPassword = self.txtNewPassword.text ?? ""
        
        self.viewModel.webserviceChangePassword(reqModel: reqModel)
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
        }else if textField == txtCurrentPassword{
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in current password", vc: self)
                   return false
               }
        // If consecutive spaces entered by user
         return true
            
        }else if textField == txtNewPassword{
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in new password", vc: self)
                   return false
               }
        // If consecutive spaces entered by user
         return true
            
        }else if textField == txtReEnterPassword{
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in reenter password", vc: self)
                   return false
               }
        // If consecutive spaces entered by user
         return true
        }
        
        return true
    }
}
