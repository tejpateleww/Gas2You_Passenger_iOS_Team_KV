//
//  SignupViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

class SignupViewModel {
    weak var signupvc : OtpVC? = nil
    weak var signupmodel : SignUpVC? = nil
    var registerRequestModel = RegisterRequestModel()
    
    func webserviceOtp(reqModel: OTPRequestModel){
        WebServiceSubClass.otpRequestApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state:status ? .success : .failure){
                if status{
                    self.signupvc?.StringOTP = "\(response?.otp ?? 0)"
                    self.signupvc?.reversetimer()
                }
            }
        }
    }
    func webserviceSignupOtp(reqModel: OTPRequestModel){
        self.signupmodel?.btnSignup.showLoading()
        WebServiceSubClass.otpRequestApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.signupmodel?.btnSignup.hideLoading()
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state:status ? .success : .failure){
                if status{
                    self.signupmodel?.strOtp = String(response?.otp ?? 0)
                    self.signupmodel?.storeDataInRegisterModel()
                }
            }
        }
    }
    func callRegisterApi(reqModel:RegisterRequestModel){
        self.signupvc?.btnVerify.showLoading()
        WebServiceSubClass.RegisterApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            self.signupvc?.btnVerify.hideLoading()
            if !status {
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Error, message: apiMessage, state:status ? .success : .failure)
            }else{
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
                AppDel.navigateToHome()
            }
        }
    }
}
