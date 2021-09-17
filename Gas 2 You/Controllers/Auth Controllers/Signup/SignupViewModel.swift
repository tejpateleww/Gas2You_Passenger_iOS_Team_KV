//
//  SignupViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

class SignupViewModel {

    struct SignupValues {
        let firstName, lastName, email, mobile, password, confPassword: String
        let passPlaceholder, confPassPlaceholder, firstNamePlaceholder, lastNamePlaceholder: String
    }

    var locationManager : LocationService?

    var changeHandler: ((SignUpViewModelChange) -> Void)?

    func doRegister(_ values: SignupValues) {
        guard isValidCredFormate(values) else {
            return
        }
        guard getLocation() else {
            return
        }
        let requestModel = RegisterRequestModel(values: values)
        emit(.credsValidated(requestModel))
    }

    func emit(_ change: SignUpViewModelChange) {
        changeHandler?(change)
    }

    private func handleSingleValidaton(array: inout [String], values: (Bool,String)) {
        if !values.0 {
            array.append(values.1)
        }
    }

    private func isValidCredFormate(_ values: SignupValues) -> Bool {

        var validationArray: [(Bool,String)] = []

        // First Name
        let checkFirstName = values.firstName.validatedText(validationType: .username(field: values.firstNamePlaceholder))
        validationArray.append(checkFirstName)

        // Last Name
        let checkLastName = values.lastName.validatedText(validationType: .username(field: values.lastNamePlaceholder))
        validationArray.append(checkLastName)

        // Email
        let checkEmail = values.email.validatedText(validationType: .email)
        validationArray.append(checkEmail)

        // Mobile Number
        if !values.mobile.isEmpty {
            let checkMobile = values.mobile.validatedText(validationType: .phoneNo)
            validationArray.append(checkMobile)
        }

        // Password
        let checkPassword = values.password.validatedText(validationType: .password(field: values.passPlaceholder.lowercased()))
        validationArray.append(checkPassword)

        // Confirm Password
        let checkConfPass = values.confPassword.validatedText(validationType: .password(field: values.confPassPlaceholder))
        validationArray.append(checkConfPass)

        // Password + Confirm Password
        if (checkPassword.0 && checkConfPass.0), values.password != values.confPassword {
            validationArray.append((false, MessageString.passwordConfirmMustBeSame))
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

    private func getLocation() -> Bool {
        if Singleton.sharedInstance.userCurrentLocation == nil{
            self.locationManager = LocationService()
            self.locationManager?.startUpdatingLocation()
            return false
        }else{
            return true
        }
    }

    private func webserviceOtp(reqModel: OTPRequestModel){
        Utilities.showHud()
        WebServiceSubClass.otpRequestApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                
            }else{
                self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
            }
        }
    }
}
