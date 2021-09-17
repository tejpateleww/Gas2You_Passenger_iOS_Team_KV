//
//  OTPViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 07/09/21.
//

import Foundation

class OtpViewModel {
    
    let email: String
    let registerRequestModel: RegisterRequestModel
    var otpStr: String = ""

    var changeHandler: ((OtpViewModelChange) -> Void)?

    var emailMessageString: String {
        let components = email.components(separatedBy: "@")
        let result = self.hideMidChars(components.first!) + "@" + components.last!
        return "Check your email address. We've sent you the code at \(result)"
    }

    init(registerRequestModel: RegisterRequestModel) {
        self.email = registerRequestModel.email ?? ""
        self.registerRequestModel = registerRequestModel
    }

    func emit(_ change: OtpViewModelChange) {
        changeHandler?(change)
    }

    private func hideMidChars(_ value: String) -> String {
        return String(value.enumerated().map { index, char in
            return [0, 1, value.count, value.count].contains(index) ? char : "*"
        })
    }

    func callOtpApi(){
        let otpReqModel = OTPRequestModel()
        otpReqModel.email = email
        emit(.loaderStart)
        WebServiceSubClass.otpRequestApi(reqModel: otpReqModel) { (status, apiMessage, response, error) in
            self.emit(.loaderEnd)
            if status, let otp = response?.otp {
                self.otpStr = String(otp)
                self.emit(.otpSent)
            }else{
                self.emit(.fatalError(message: apiMessage))
            }
        }
    }

    func callRegisterApi(){
        emit(.loaderStart)
        WebServiceSubClass.RegisterApi(reqModel: registerRequestModel) { (status, apiMessage, response, error) in
            self.emit(.loaderEnd)
            if status {
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
                self.emit(.userRegstered)
            } else {
                self.emit(.showToast(title: UrlConstant.Failed, message: apiMessage, state: .failure))
            }
        }
    }
}
