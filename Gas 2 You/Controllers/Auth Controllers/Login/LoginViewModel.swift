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
    func webserviceAppleLOgin(reqModel:appleDetailReqModel){
        Utilities.showHud()
        WebServiceSubClass.AppleDetailApi(reqModel: reqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                
                let reqModel = SocialLoginRequestModel()
                reqModel.socialId = response?.appleDetail?.appleId
                reqModel.socialType = SocialType.Apple.rawValue
                reqModel.firstName = response?.appleDetail?.firstName
                reqModel.lastName = response?.appleDetail?.lastName
                reqModel.email = response?.appleDetail?.email
                reqModel.userName = response?.appleDetail?.email
                reqModel.country_code = "+91"
                self.webserviceSocialLogin(reqModel: reqModel)
            } else {
                Toast.show(title: status ? UrlConstant.Success : UrlConstant.Failed, message: apiMessage, state: status ? .success : .failure)
            }
        })
    }
}
