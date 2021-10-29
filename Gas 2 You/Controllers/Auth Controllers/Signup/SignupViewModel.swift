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
        Utilities.showHud()
        WebServiceSubClass.otpRequestApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.signupvc?.StringOTP = "\(response?.otp ?? 0)"
                self.signupvc?.otpToastDisplay()
                self.signupvc?.reversetimer()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
                //Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        }
    }
    func webserviceSignupOtp(reqModel: OTPRequestModel){
        Utilities.showHud()
        self.signupmodel?.btnSignup.showLoading()
        WebServiceSubClass.otpRequestApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            self.signupmodel?.btnSignup.hideLoading()
            if status{
                let otpvc = self.signupmodel?.storyboard?.instantiateViewController(identifier: OtpVC.className) as! OtpVC
                otpvc.registerRequestModel = self.signupmodel!.registerRequestModel
                self.signupmodel?.navigationController?.pushViewController(otpvc, animated: true)
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
//                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        }
    }
    func callRegisterApi(reqModel:RegisterRequestModel){
        self.signupvc?.btnVerify.showLoading()
        Utilities.showHud()
        WebServiceSubClass.RegisterApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            self.signupvc?.btnVerify.hideLoading()
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
                AppDel.navigateToHome()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
//                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        }
    }
}
