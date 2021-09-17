//
//  LoginViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

class LoginViewModel {

    var locationManager : LocationService?

    var changeHandler: ((AuthViewModelChange) -> Void)?

    func doLogin(email: String, password: String, passwordPlaceholder: String?) {
        guard isValidCredFormate(email: email,
                                 password: password,
                                 passwordPlaceholder: passwordPlaceholder) else {
            return
        }
        guard getLocation() else {
            return
        }
        let reqModel = LoginRequestModel(email: email, password: password)
        webserviceLogin(reqModel)
    }

    func emit(_ change: AuthViewModelChange) {
        changeHandler?(change)
    }

    func isValidCredFormate(email: String, password: String, passwordPlaceholder: String?) -> Bool {
        var messageArray: [String] = []
        let checkEmail = email.validatedText(validationType: .email)
        let checkPassword = password.validatedText(validationType: .password(field: passwordPlaceholder?.lowercased() ?? ""))
        if !checkEmail.0 {
            messageArray.append(checkEmail.1)
        }
        if !checkPassword.0 {
            messageArray.append(checkPassword.1)
        }
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

    private func webserviceLogin(_ reqModel: LoginRequestModel){
        emit(.loaderStart)
        WebServiceSubClass.LoginApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.emit(.loaderEnd)
            if status{
                Constants.userDefaults.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                Constants.userDefaults.setValue(response?.data?.xAPIKey, forKey: UserDefaultsKey.X_API_KEY.rawValue)

                Singleton.sharedInstance.userProfilData = response?.data
                Constants.userDefaults.setUserData()

                if let apikey = response?.data?.xAPIKey{
                    Singleton.sharedInstance.api_Key = apikey
                    Singleton.sharedInstance.userProfilData?.xAPIKey = apikey
                    Constants.userDefaults.setValue(apikey, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                }

                if let userID = response?.data?.id{
                    Singleton.sharedInstance.userId = userID
                }
                self.emit(.authSucceed())
            } else {
                self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
            }
        }
    }

}
