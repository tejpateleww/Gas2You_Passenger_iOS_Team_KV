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
        let passPlaceholder, confPassPlaceholder, firstNamePlaceholder, lastNamePlaceholder,mobileNoPlaceholder: String
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

        // First Name
        var strTitle : String?
        let firstName = values.firstName.validatedText(validationType: .username(field: values.firstNamePlaceholder.lowercased()))
        let lastName = values.lastName.validatedText(validationType: .username(field: values.lastNamePlaceholder.lowercased()))
        let checkEmail = values.email.validatedText(validationType: .email)
        let mobileNo = values.mobile.validatedText(validationType: .requiredField(field: values.mobileNoPlaceholder.lowercased()))
        let password = values.password.validatedText(validationType: .password(field: values.passPlaceholder.lowercased()))
        let Confpassword = values.confPassword.validatedText(validationType: .password(field: values.confPassPlaceholder.lowercased()))
        
        
        if !firstName.0{
            strTitle = firstName.1
        }else if !lastName.0{
            strTitle = lastName.1
        }else if !checkEmail.0{
            strTitle = checkEmail.1
        }else if !mobileNo.0{
            strTitle = mobileNo.1
        }else if values.mobile.count != 10 {
            strTitle = UrlConstant.ValidPhoneNo
        }else if !password.0{
            strTitle = password.1
        }else if !Confpassword.0{
            strTitle = Confpassword.1
        }else if values.password.lowercased() != values.confPassword.lowercased(){
            Toast.show(title: UrlConstant.Required, message: "Password and confirm password must be same", state: .failure)
            return false
        }
        
        
        if let str = strTitle{
            Toast.show(title: UrlConstant.Required, message: str, state: .failure)
            return false
        }
        
        return true
        // Password + Confirm Password
        
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
