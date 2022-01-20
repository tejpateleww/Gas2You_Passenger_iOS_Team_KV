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
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        
        if let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type") {
            
            if (key as? String ?? "") == "newMessage" {
                if let topVc = UIApplication.appTopViewController() {
                    if topVc.isKind(of: ChatViewController.self) {
                        let vc = topVc as! ChatViewController
                        if let BookingID = userInfo["gcm.notification.booking_id"] as? String {
                            if vc.bookingID != BookingID {
                                completionHandler([.alert, .sound])
                            } else {
                                self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo as [AnyHashable : Any])
                            }
                        }
                       
                        
                    } else {
                        completionHandler([.alert, .sound])
                    }
                }
            }else if (key as? String ?? "") == "sessionTimeout"{
                AppDel.dologout()
                completionHandler([.alert, .sound])
            }else if (key as? String ?? "") == "jobStart"{
                if let topVc = UIApplication.appTopViewController() {
                    if topVc.isKind(of: MyOrdersVC.self) {
                        self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo as [AnyHashable : Any])
                    } else {
                        completionHandler([.alert, .sound])
                    }
                }
            }else if (key as? String ?? "") == "jobComplete" {
                if let topVc = UIApplication.appTopViewController() {
                    if topVc.isKind(of: MyOrdersVC.self) {
                        self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo as [AnyHashable : Any])
                    } else {
                        completionHandler([.alert, .sound])
                    }
                }
            }else if (key as? String ?? "") == "invoiceGenerated"{
                completionHandler([.alert, .sound])
                if let topVc = UIApplication.appTopViewController() {
                    if topVc.isKind(of: MyOrdersVC.self) {
                        NotificationCenter.default.post(name: .refreshCompOrderScreen, object: nil)
                    }
                }
            }else if (key as? String ?? "") == "leavCarDoorCapOpen"{
                if let topVc = UIApplication.appTopViewController() {
                    completionHandler([.alert, .sound])
                    if !topVc.isKind(of: GasDoorOpenPopUpVC.self) {
                        self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo as [AnyHashable : Any])
                    }
                }
            }else if (key as? String ?? "") == "SendBulkPushNotification"{
                if let topVc = UIApplication.appTopViewController() {
                    completionHandler([.alert, .sound])
                    if topVc.isKind(of: NotificationListVC.self) {
                        NotificationCenter.default.post(name: .refreshNotiScreen, object: nil)
                    }
                }
            }
        }
        
        print(#function)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
        print("USER INFo : ",userInfo)
        
        
        if let mainDic = userInfo as? [String: Any]{
            
            let pushObj = NotificationObjectModel()
            if let booking_id = mainDic["gcm.notification.booking_id"]{
                pushObj.booking_id = booking_id as? String ?? ""
            }
            if let type = mainDic["gcm.notification.type"]{
                pushObj.type = type as? String ?? ""
            }
            if let title = mainDic["title"]{
                pushObj.title = title as? String ?? ""
            }
            if let text = mainDic["text"]{
                pushObj.text = text as? String ?? ""
            }
            
            AppDelegate.pushNotificationObj = pushObj
            AppDelegate.pushNotificationType = pushObj.type
            
            if pushObj.type == "leavCarDoorCapOpen"{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if (UIApplication.appTopViewController()?.isKind(of: GasDoorOpenPopUpVC.self) ?? false){
                        AppDelegate.pushNotificationObj = nil
                        AppDelegate.pushNotificationType = nil
                    }else{
                        NotificationCenter.default.post(name: .openCarDoorScreen, object: nil)
                    }
                }
                return
            }
            
            if pushObj.type == "invoiceGenerated"{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if (UIApplication.appTopViewController()?.isKind(of: MyOrdersVC.self) ?? false){
                        AppDelegate.pushNotificationObj = nil
                        AppDelegate.pushNotificationType = nil
                    }else{
                        NotificationCenter.default.post(name: .goToCompOrderScreen, object: nil)
                    }
                }
                return
            }
            
            if pushObj.type == "SendBulkPushNotification"{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if (UIApplication.appTopViewController()?.isKind(of: NotificationListVC.self) ?? false){
                        AppDelegate.pushNotificationObj = nil
                        AppDelegate.pushNotificationType = nil
                    }else{
                        NotificationCenter.default.post(name: .goToNotiScreen, object: nil)
                    }
                }
                return
            }
        }

        
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")
        if UIApplication.shared.applicationState == .active {
            self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo)
        } else if UIApplication.shared.applicationState == .background {
            self.navigateToChatVC(userData: userInfo)
        } else if UIApplication.shared.applicationState == .inactive {
            Singleton.sharedInstance.userInforForNotification = userInfo
            NotificationCenter.default.addObserver(self, selector: #selector(GoToChatFromNotification), name: NSNotification.Name(rawValue: "MessageScreenNotification"), object: userInfo)
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(#function)
        print(userInfo)
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")
        if UIApplication.shared.applicationState == .active {
            self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo)
        } else if UIApplication.shared.applicationState == .background {
            self.navigateToChatVC(userData: userInfo)
        } else if UIApplication.shared.applicationState == .inactive {
            Singleton.sharedInstance.userInforForNotification = userInfo
            NotificationCenter.default.addObserver(self, selector: #selector(GoToChatFromNotification), name: NSNotification.Name(rawValue: "MessageScreenNotification"), object: userInfo)
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(#function)
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    @objc func GoToChatFromNotification() {
        navigateToChatVC(userData: Singleton.sharedInstance.userInforForNotification)
    }
    
    func gotoMyOrders(){
        
    }
    
     func navigateToChatVC(userData : [AnyHashable : Any]) {
       
        if let BookingID = userData["gcm.notification.booking_id"] as? String {
            
            
            if let topVc = UIApplication.appTopViewController() {
                if topVc.isKind(of: ChatViewController.self) {
                    let chatVc = topVc as! ChatViewController
                    if chatVc.bookingID == BookingID {
                        chatVc.isFromPush = true
                        chatVc.callHistory()
                    } else {
                        chatVc.isFromPush = true
                        chatVc.callHistory()
                    }
                } else {
                    let chatVc : ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
                    chatVc.bookingID = BookingID
                    chatVc.isFromPush = true
                    chatVc.callChatHistoryAPI()
                    
                    topVc.navigationController?.hidesBottomBarWhenPushed = true
                    topVc.navigationController?.pushViewController(chatVc, animated: true)
                }
            }
            
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
        if let sideMenu = controller as? MainViewController {
            if let selected = sideMenu.children.first {
                return appTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return appTopViewController(controller: presented)
        }
        return controller
    }
}
extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension AppDelegate {
    func  handlePushnotifications(NotificationType:String , userData : [AnyHashable : Any]) {
        switch NotificationType {
        case "jobStart":
         print("jobStart")
            if let BookingID = userData["gcm.notification.booking_id"] as? String {
                if let topVc = UIApplication.appTopViewController() {
                    if topVc.isKind(of: MyOrdersVC.self) {
                        let orderVc = topVc as! MyOrdersVC
                        if orderVc.bookingid == BookingID {
                        orderVc.isFromPayment = true//btnInProgressTap(orderVc.btnInProgress)
                        orderVc.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "1", page: "1")//bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: BookingID))
                        }
                    } else {
                        let orderVc : MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
                        orderVc.isFromPayment = true
                        orderVc.bookingid = BookingID
                        orderVc.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "1", page: "1")
                        topVc.navigationController?.hidesBottomBarWhenPushed = true
                        topVc.navigationController?.pushViewController(orderVc, animated: true)
                    }
                }
            }
        case "jobComplete":
            print("jobComplete")
            if let topVc = UIApplication.appTopViewController() {
                if topVc.isKind(of: MyOrdersVC.self) {
                    let orderVc = topVc as! MyOrdersVC
                   // if jobVc.orderId == BookingID {
                    orderVc.isFromComplete = true
                    orderVc.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "2", page: "1")//bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: BookingID))
                    //
                } else {
                    let orderVc : MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
                    orderVc.isFromComplete = true
                    orderVc.BookingList.doBookingList(customerid: Singleton.sharedInstance.userId, status: "2", page: "1")
                    topVc.navigationController?.hidesBottomBarWhenPushed = true
                    topVc.navigationController?.pushViewController(orderVc, animated: true)
                }
            }
        case "invoiceGenerated" :
            print("invoiceGenerated")
            if let BookingID = userData["gcm.notification.booking_id"] as? String {
                if let topVc = UIApplication.appTopViewController() {
                    if topVc.isKind(of: CompleteJobVC.self) {
                        let jobVc = topVc as! CompleteJobVC
                        if jobVc.orderId == BookingID {
                            jobVc.bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: BookingID))
                        } else {
                            
                        }
                    } else {
                        let jobVc : CompleteJobVC = CompleteJobVC.instantiate(fromAppStoryboard: .Main)
                        jobVc.orderId = BookingID
                        
                        jobVc.bookingDetailViewModel.webservicebookingDetails(bookingDetailReqModel(customerid: Singleton.sharedInstance.userId, order_id: BookingID))
                        topVc.navigationController?.hidesBottomBarWhenPushed = true
                        topVc.navigationController?.pushViewController(jobVc, animated: true)
                    }
                }
            }
        case "newMessage" :
            print("newMessage")
            if let BookingID = userData["gcm.notification.booking_id"] as? String {
                if let topVc = UIApplication.appTopViewController() {
                    print("ATDebug :: \(topVc)")
                    if topVc.isKind(of: ChatViewController.self) {
                        let chatVc = topVc as! ChatViewController
                        if chatVc.bookingID == BookingID {
                            chatVc.isFromPush = true
                            chatVc.callHistory()
                        } else {
                            if let navController = chatVc.navigationController {
                                chatVc.navigationController?.popViewController(animated: false)
                                let newChatVC : ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
                                newChatVC.bookingID = BookingID
                                newChatVC.isFromPush = true
                                newChatVC.callHistory()
                                navController.hidesBottomBarWhenPushed = true
                                navController.pushViewController(chatVc, animated: true)
                            }
                            
                        }
                    } else {
                        let chatVc : ChatViewController = ChatViewController.instantiate(fromAppStoryboard: .Main)
                        chatVc.bookingID = BookingID
                        chatVc.isFromPush = true
                        chatVc.callHistory()
                        topVc.navigationController?.hidesBottomBarWhenPushed = true
                        topVc.navigationController?.pushViewController(chatVc, animated: true)
                    }
                }
            }
        case "sessionTimeout":
            AppDel.dologout()
            
        case "leavCarDoorCapOpen":
            AppDel.showCarDoorOpenVC()
        default:
            break
        }
    }
    
    
    
    
}
