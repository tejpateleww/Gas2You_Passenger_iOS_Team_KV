//
//  NotificationChangeViewModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 01/12/21.
//

import Foundation
class NotiChangeViewModel{
    
    weak var settingsVC : SettingsVC? = nil
    
    func webserviceNotiStatusChangeAPI(reqModel: NotificationStatusReqModel){
        Utilities.showHud()
        WebServiceSubClass.changeNotificationStatusApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            DispatchQueue.main.async {
                if status{
                    userDefault.setValue(response?.data?.xAPIKey, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                    Singleton.sharedInstance.userProfilData = response?.data
                    userDefault.setUserData()
                    
                    if let apikey = response?.data?.xAPIKey{
                        Singleton.sharedInstance.api_Key = apikey
                        Singleton.sharedInstance.userProfilData?.xAPIKey = apikey
                        userDefault.setValue(apikey, forKey: UserDefaultsKey.X_API_KEY.rawValue)
                    }
                    
                    if let userID = response?.data?.id{
                        Singleton.sharedInstance.userId = userID
                    }
                    
                    if(Singleton.sharedInstance.userProfilData?.notification == "1"){
                        self.settingsVC?.switchNotification.setOn(true, animated: true)
                    }else{
                        self.settingsVC?.switchNotification.setOn(false, animated: true)
                    }
                }else{
                    Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
                }
            }
        }
    }
    
}
class NotificationModelClass{
    
    weak var notificationVC : NotificationListVC? = nil
    
    func webserviceNotificationListAPI(reqModel: NotificationReqModel){
        
        self.notificationVC?.isApiProcessing = true
        WebServiceSubClass.getNotificationListApi(reqModel: reqModel) { (status, apiMessage, response, error) in
            
            DispatchQueue.main.async {
                self.notificationVC?.refreshControl.endRefreshing()
            }
            self.notificationVC?.isLoading = false
            self.notificationVC?.isTblReload = true
            
            if status{
                self.notificationVC?.isApiProcessing = false
                
                if(response?.data?.count == 0){
                    if(self.notificationVC?.CurrentPage == 1){
                        self.notificationVC?.arrNotification = response?.data ?? []
                    }else{
                        self.notificationVC?.isStopPaging = true
                    }
                }else{
                    if(self.notificationVC?.CurrentPage == 1){
                        self.notificationVC?.arrNotification = response?.data ?? []
                    }else{
                        self.notificationVC?.arrNotification.append(contentsOf: response?.data ?? [])
                    }
                }
                self.notificationVC?.reloadData()
            }else{
                Toast.show(title: UrlConstant.Failed, message: apiMessage, state: .failure)
            }
        }
    }
    
}
