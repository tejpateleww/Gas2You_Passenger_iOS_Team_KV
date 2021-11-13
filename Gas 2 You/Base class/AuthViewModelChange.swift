//
//  AuthViewModelChange.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

enum AuthViewModelChange {
    case loaderStart
    case loaderEnd
    case authSucceed(_ apiMessage: String? = nil)
    case showToast(title: String, message: String, state: MessageAlertState)
}

enum SignUpViewModelChange {
    case loaderStart
    case loaderEnd
    case credsValidated(_ model: RegisterRequestModel)
    case showToast(title: String, message: String, state: MessageAlertState)
}

enum OtpViewModelChange {
    case loaderStart
    case loaderEnd
    case showToast(title: String, message: String, state: MessageAlertState)
    case fatalError(message: String)
    case otpSent
    case userRegstered
}
