//
//  HomeViewModel.swift
//  Gas 2 You
//
//  Created by Tej P on 18/02/22.
//

import Foundation

class HomeViewModel {
    weak var homeVC : HomeVC?
   
    func callInitAPI(){
        Utilities.showHud()
        WebServiceSubClass.InitApi(completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                Singleton.sharedInstance.appInitModel = response
                if(response?.userProfilData != nil){
                    Singleton.sharedInstance.userProfilData = response?.userProfilData
                    Constants.userDefaults.setUserData()
                    NotificationCenter.default.post(name: .clearAddonArray, object: nil)
                    self.homeVC?.ReloadAddonsAfterInitResponse()
                    
                    AppDelegate.shared.updateUiAfterInit()
                }
            }else{
                Toast.show(title: UrlConstant.Error, message: apiMessage, state:.failure)
            }
        })
    }
}
