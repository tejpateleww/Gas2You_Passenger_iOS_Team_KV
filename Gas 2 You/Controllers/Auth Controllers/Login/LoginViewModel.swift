//
//  LoginViewModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

class LoginViewModel {
    weak var loginvc : LogInVC? = nil
    func webserviceLogin(reqModel: LoginRequestModel){
        Utilities.showHud()
        WebServiceSubClass.LoginApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
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
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Success, message: apiMessage, state: status ? .success : .success)
                AppDel.navigateToHome()
            } else {
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state: status ? .success : .failure)
            }
        }
    }

    func webserviceSocialLogin(reqModel: SocialLoginRequestModel){
        Utilities.showHud()
        
        WebServiceSubClass.SocialLoginApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state: status ? .success : .failure)
            if status{
                Constants.userDefaults.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                Constants.userDefaults.setValue(response?.data?.xAPIKey, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                
                Singleton.sharedInstance.userProfilData = response?.data
                Constants.userDefaults.setUserData()
                
                if let apikey = response?.data?.xAPIKey{
                    Singleton.sharedInstance.api_Key = apikey
                    Constants.userDefaults.setValue(apikey, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                }
                
                if let userID = response?.data?.id{
                    Singleton.sharedInstance.userId = userID
                }
                
                AppDel.navigateToHome()
            }
        }
    }
//    func webserviceAppleLOgin(reqModel:appleDetailReqModel){
//        Utilities.showHud()
//        WebServiceSubClass.AppleDetailApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
//            Utilities.hideHud()
//            Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state: status ? .success : .failure)
//            if status{
//                let loginModel = appleLoginResModel.init(fromJson: json)
//                self.socialID = loginModel.appleDetail.appleId
//                self.socialType = "Apple"
//                
//                let socialModel = userSocialData()
//                socialModel.device_token = SingletonClass.sharedInstance.DeviceToken
//                socialModel.device_type = ReqDeviceType
//                socialModel.social_id = self.socialID
//                socialModel.user_name = loginModel.appleDetail.email
//                socialModel.social_type = self.socialType
//                self.user_SocialData = socialModel
//                self.webservice_SocialLoginCheck(email: appleUserEmail, FullName: "\(loginModel.appleDetail.firstName ?? "") \(loginModel.appleDetail.lastName ?? "")" )
//            }
//        })
//    }
}