//
//  ForgotPasswordViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation
import UIKit

class ForgotPasswordViewModel {

    var changeHandler: ((AuthViewModelChange) -> Void)?

    func emit(_ change: AuthViewModelChange) {
        changeHandler?(change)
    }

    func submit(email: String) {
        let forgotdata = ForgotPasswordReqModel()
        forgotdata.email = email
        guard isValidInput(email: email) else {
            return
        }
        webserviceForgotPassword(reqModel: forgotdata)
    }

    func isValidInput(email: String) -> Bool {
        let txtTemp = UITextField()
        txtTemp.text = email.replacingOccurrences(of: " ", with: "")
        let checkEmailRequired = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtTemp.placeholder?.lowercased() ?? ""))
        let checkEmail = email.validatedText(validationType: .email)
        if(!checkEmailRequired.0){
            Toast.show(title: AppInfo.appName, message: "Please enter email", state: .failure)
            return checkEmailRequired.0
        }else if(!checkEmail.0)
        {
            self.emit(.showToast(title: UrlConstant.Required, message: checkEmail.1, state: .failure))
            return false
        }
        return true
    }
    func webserviceForgotPassword(reqModel:ForgotPasswordReqModel){
        Utilities.showHud()
        WebServiceSubClass.ForgotPasswordApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.emit(.showToast(title: UrlConstant.Success, message: "Reset password link sent to your email address", state: .success))
            }else{
                self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
            }
        })
    }
}
