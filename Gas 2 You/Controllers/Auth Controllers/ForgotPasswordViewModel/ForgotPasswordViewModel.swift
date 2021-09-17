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
        guard isValidInput(email: email) else {
            return
        }
    }

    func isValidInput(email: String) -> Bool {
        let checkEmail = email.validatedText(validationType: .email)
        if checkEmail.0 {
            return true
        } else {
            self.emit(.showToast(title: UrlConstant.Required, message: checkEmail.1, state: .failure))
            return false
        }
    }

}
