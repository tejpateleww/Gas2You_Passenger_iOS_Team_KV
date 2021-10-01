//
//  ChangePasswordViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 07/09/21.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {

    struct Values {
        let currentPass, newPass, confPass: String
        let currentPassPlaceholder, newPassPlaceholder, confPassPlaceholder: String
    }

    var changeHandler: ((AuthViewModelChange) -> Void)?

    func changePassword(_ values: Values) {
        guard isValid(values) else {
            return
        }
        webserviceChangePassword(values)
    }

    func emit(_ change: AuthViewModelChange) {
        changeHandler?(change)
    }

    private func webserviceChangePassword(_ values: Values){
        let reqModel = ChangePasswordReqModel(values)
        emit(.loaderStart)
        WebServiceSubClass.ChangePasswordApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.emit(.loaderEnd)
            if status {
                self.emit(.authSucceed(apiMessage))
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
                }
            }
        }
    }

    private func isValid(_ values: Values) -> Bool {

        var strTitle : String?

        let checkPassword = values.currentPass.validatedText(validationType: .password(field: values.currentPassPlaceholder.lowercased()))
        let checkNewPass = values.newPass.validatedText(validationType: .password(field: values.newPassPlaceholder))
        let checkConfPass = values.confPass.validatedText(validationType: .password(field: values.confPassPlaceholder))
        if !checkPassword.0{
            strTitle = checkPassword.1
        }else if !checkNewPass.0{
            strTitle = checkNewPass.1
        }else if !checkConfPass.0{
            strTitle = checkConfPass.1
        }else if values.newPass.lowercased() != values.confPass.lowercased(){
            Toast.show(title: UrlConstant.Required, message: "Password and confirm password must be same", state: .failure)
            return false
        }
        if let str = strTitle{
            Toast.show(title: UrlConstant.Required, message: str, state: .failure)
            return false
        }
        
        return true
    }
}
