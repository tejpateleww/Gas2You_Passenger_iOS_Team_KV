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

        var validationArray: [(Bool,String)] = []

        // Password
        let checkPassword = values.currentPass.validatedText(validationType: .password(field: values.currentPassPlaceholder.lowercased()))
        validationArray.append(checkPassword)

        // New Password
        let checkNewPass = values.newPass.validatedText(validationType: .password(field: values.newPassPlaceholder))
        validationArray.append(checkNewPass)

        // Confirm Password
        let checkConfPass = values.confPass.validatedText(validationType: .password(field: values.confPassPlaceholder))
        validationArray.append(checkConfPass)

        // New Password + Confirm Password
        if (checkNewPass.0 && checkConfPass.0), values.newPass != values.confPass {
            validationArray.append((false, MessageString.newPasswordConfirmMustBeSame))
        }

        let messageArray = validationArray.filter({$0.0 == false}).map({$0.1})
        if messageArray.isEmpty {
            return true
        } else {
            let message = messageArray.joined(separator: "\n")
            self.emit(.showToast(title: UrlConstant.Required, message: message, state: .failure))
            return false
        }
    }
}
