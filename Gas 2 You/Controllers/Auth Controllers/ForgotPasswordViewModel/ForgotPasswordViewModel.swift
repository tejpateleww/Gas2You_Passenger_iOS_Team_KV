//
//  ForgotPasswordViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

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
        let checkEmail = email.validatedText(validationType: .email)
        if(!checkEmail.0)
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
                self.emit(.showToast(title: UrlConstant.Success, message: apiMessage, state: .success))
            }else{
                self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
            }
        })
    }
}
