//
//  AppDelegate+PushNotification.swift
//  User
//
//  Created by apple on 6/29/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import GoogleMaps
import UserNotifications


extension AppDelegate : MessagingDelegate {
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_ , _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let token = fcmToken ?? "No Token found"
        print("Firebase registration token: \(fcmToken ?? "No Token found")")
        Singleton.sharedInstance.deviceToken = token
        userDefault.set(fcmToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
        
        let dataDict:[String: String] = ["token": token]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = token {
                print("Remote instance ID token: \(result)")
                UserDefaults.standard.set(Singleton.sharedInstance.deviceToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("fcmToken : \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function, notification)
        guard let isUserLogin = UserDefaults.standard.value(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool,isUserLogin == true,userDefault.getUserData() != nil else {
            print("User is not login, can not process push")
            return
        }
        
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        print("USER INFo : ",userInfo)
        if NotificationTypes(rawValue: (userInfo["gcm.notification.type"] as? String ?? "")) != nil {
            notificationType = NotificationTypes(rawValue: (userInfo["gcm.notification.type"] as? String ?? ""))!
            var orderDict = [String:Any]()
            if let response = userInfo["gcm.notification.data"] as? String {
                let jsonData = response.data(using: .utf8)!
                orderDict = try! (JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String : Any] ?? [:])
                
            }
            orderid = (orderDict["order_id"] as? String ?? "")
            status = (orderDict["status"] as? Int ?? 0)
            switch notificationType{
            case .JobStarted :
                completionHandler([.alert, .sound])
            case .JobCompleted :
                completionHandler([.alert, .sound])
            case .InvoiceGenerated:
                completionHandler([.alert, .sound])
            case .Chatnewmessagereceived:
                completionHandler([.alert, .sound])
            default:
                completionHandler([.alert, .sound])
            }
        }else{
            completionHandler([.alert, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        
        
        guard let isUserLogin = UserDefaults.standard.value(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool,isUserLogin == true,userDefault.getUserData() != nil else {
            print("User is not login, can not process push")
            return
        }
        
        
        let userInfo = response.notification.request.content.userInfo
        print("USER INFo : ",userInfo)
//        guard let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type") as? String else  {
//            return
//        }
        
//        if key == "Account Active" {
//            SingletonClass.sharedInstance.OwnerProfileInfo?.profile.active = "1"
//            user_defaults.setUserData()
//            appDelegate.delegateEditProfile?.accountActivated()
//        }

        
        if NotificationTypes(rawValue: (userInfo["gcm.notification.type"] as? String ?? "")) != nil {
            notificationType = NotificationTypes(rawValue: (userInfo["gcm.notification.type"] as? String ?? ""))!
//            var orderDict = [String:Any]()
//            if let response = userInfo["gcm.notification.data"] as? String {
//                let jsonData = response.data(using: .utf8)!
//                orderDict = try! (JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String : Any] ?? [:])
//
//                if let dictUser = orderDict["BookingListDatum"] as? [String:Any] {
////                    ObjUserData =
//                print(ObjUserData)
//                print(orderDict)
//            }
//            }
//            var deliveryBoyId = "\(orderDict["sender_id"] ?? 0)"
//            let orderid = (orderDict["order_id"] as? String ?? "")
//            print(orderid,"Order id")
            
        
            switch notificationType {
            case .JobStarted:
                print("JobStarted")
                //
                guard let dictParam = (userInfo as NSDictionary).object(forKey: "gcm.notification.extra_param") as? String else {
                    return
                }
                let jsonData = dictParam.data(using: .utf8)!
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                  guard let personsDictionary = dictionary  as? [String: Any] else {
                      return
                   }
                guard let bookingid = personsDictionary["booking_id"] as? String  else {
                        return
                  }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    if let vc = (AppDel.window?.rootViewController as! UINavigationController).viewControllers.first as? MyOrdersVC {
                        vc.isFromPayment = true
                    }else{
                        if let Navigation = AppDel.window?.rootViewController as? UINavigationController{
                            let MyOrdersVC : MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
                            MyOrdersVC.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "1", page: "1")
                            Navigation.hidesBottomBarWhenPushed = true
                            Navigation.pushViewController(MyOrdersVC, animated: true)
                        }
                        //self.Gotomyorderscreen()
                    }
                }
                
            case .JobCompleted :
                print("JobCompleted")
                if let vc = (AppDel.window?.rootViewController as! UINavigationController).viewControllers.first as? MyOrdersVC {
                    vc.isInProcess = 2
                }else{
                    self.GotocompleteOrderscreen()
                }
                
            case .InvoiceGenerated :
                print("InvoiceGenerated")
                if let _ = (AppDel.window?.rootViewController as! UINavigationController).viewControllers.first as? CompleteJobVC {
                }else{
                    GotoCompletejobvc()
                }
                
            case .Chatnewmessagereceived :
                print("Chatnewmessagereceived")
                guard let dictParam = (userInfo as NSDictionary).object(forKey: "gcm.notification.extra_param") as? String else {
                    return
                }
                let jsonData = dictParam.data(using: .utf8)!
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                  guard let personsDictionary = dictionary  as? [String: Any] else {
                      return
                   }
                guard let bookingid = personsDictionary["booking_id"] as? String  else {
                        return
                  }
                if let _ = (AppDel.window?.rootViewController as! UINavigationController).viewControllers.first as? ChatViewController {
                }else{
                    if let Navigation = AppDel.window?.rootViewController as? UINavigationController{
                        let chatVc : ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
                        chatVc.bookingID = bookingid
                        //                    chatVc.objUser = ObjUserData
                        //                    chatVc.isfromPush = true
                        //                    chatVc.deliveryBoyid = deliveryBoyId
                        chatVc.callChatHistoryAPI()
                        Navigation.hidesBottomBarWhenPushed = true
                        Navigation.pushViewController(chatVc, animated: true)
                    }
                    //chatPushClickTonavigate()
                }
            default :
                completionHandler()
                break
            }
        }
        print(notificationType)
        completionHandler()
    }
    @objc func Gotomyorderscreen(){
        if let Navigation = AppDel.window?.rootViewController as? UINavigationController{
            let MyOrdersVC : MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
            MyOrdersVC.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "1", page: "1")
            Navigation.hidesBottomBarWhenPushed = true
            Navigation.pushViewController(MyOrdersVC, animated: true)
        }
    }
    @objc func GotocompleteOrderscreen(){
        if let Navigation = AppDel.window?.rootViewController as? UINavigationController{
            let MyOrdersVC : MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
            MyOrdersVC.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "2", page: "1")
            Navigation.hidesBottomBarWhenPushed = true
            Navigation.pushViewController(MyOrdersVC, animated: true)
        }
    }
    @objc func GotoCompletejobvc(){
        if let Navigation = AppDel.window?.rootViewController as? UINavigationController{
            let CompleteJobVC : CompleteJobVC = CompleteJobVC.instantiate(fromAppStoryboard: .Main)
            CompleteJobVC.bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: orderid))
            Navigation.hidesBottomBarWhenPushed = true
            Navigation.pushViewController(CompleteJobVC, animated: true)
        }
    }
    @objc func chatPushClickTonavigate(){
        if let Navigation = AppDel.window?.rootViewController as? UINavigationController{
            let chatVc : ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
//            chatVc.bookingID = bookingid
            //                    chatVc.objUser = ObjUserData
            //                    chatVc.isfromPush = true
            //                    chatVc.deliveryBoyid = deliveryBoyId
            chatVc.callChatHistoryAPI()
            Navigation.hidesBottomBarWhenPushed = true
            Navigation.pushViewController(chatVc, animated: true)
        }
    }
}
extension UIApplication {
    class func appTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return appTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return appTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return appTopViewController(controller: presented)
        }
        return controller
    }
}
