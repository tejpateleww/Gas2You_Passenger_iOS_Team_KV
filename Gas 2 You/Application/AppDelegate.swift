//
//  AppDelegate.swift
//  Gas 2 You
//
//  Created by MacMini on 29/07/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import FBSDKLoginKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseCore
import FirebaseCrashlytics

let AppDel = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var isChatScreen : Bool = false
    static var pushNotificationObj : NotificationObjectModel?
    static var pushNotificationType : String?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    //Location
    var locationService = LocationService()
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.initializeSDK(nil)
        GIDSignIn.sharedInstance().clientID = "651860703785-am67b73lv131cjjv47dhpsf079e4cfic.apps.googleusercontent.com"
        // Thread.sleep(forTimeInterval: 3.0)
        setUpLocationServices()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyAiBKDiFXeYbV2f23EBtmpk8pmZYgNgExo")
        GMSPlacesClient.provideAPIKey("AIzaSyAiBKDiFXeYbV2f23EBtmpk8pmZYgNgExo")
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        registerForPushNotifications()
        return true
    }
    // MARK: - LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        Singleton.sharedInstance.userCurrentLocation = location
        //print(location.coordinate.latitude)
    }
    func setUpLocationServices() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if ((locationManager?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) != nil)
            {
                if locationManager?.location != nil
                {
                    locationManager?.startUpdatingLocation()
                    locationManager?.delegate = self
                }
                //                manager.startUpdatingLocation()
            }
        }
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Gas_2_You")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func navigateToLogin() {
        self.setRootViewController(LogInVC.getNewInstance())
        let loginNavVC = LogInVC.getNewInstance().bindToNavigation()
        setRootViewController(loginNavVC)
    }

    func navigateToHome() {
        let homeNavVC = MainViewController.getNewInstance().bindToNavigation()
        setRootViewController(homeNavVC)
    }

    func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
    }

    func dologout(){
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {

            if key != UserDefaultsKey.DeviceToken.rawValue && key  != "language"  {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }

        Constants.userDefaults.setValue(false, forKey: UserDefaultsKey.isUserLogin.rawValue)
        Singleton.sharedInstance.clearSingletonClass()
        Constants.userDefaults.setUserData()
        Constants.userDefaults.synchronize()
        AppDel.navigateToLogin()
    }
}


class NotificationObjectModel: Codable {
    var booking_id: String?
    var type: String?
    var title: String?
    var text: String?
}
extension Notification.Name {
    static let sessionExpire = NSNotification.Name("sessionExpire")
    static let refreshHomeScreen = NSNotification.Name("refreshHomeScreen")
    static let refreshChatScreen = NSNotification.Name("refreshChatScreen")
    static let goToChatScreen = NSNotification.Name("goToChatScreen")
}

enum NotificationTypes : String {
    case notifLoggedOut = "sessionTimeout"
    case newBooking = "newBooking"
    case newMessage = "newMessage"
}
