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
    var notificationType : NotificationTypes?
    var orderid = String()
    var status = 0
    var ObjUserData : BookingListDatum?
    var deliveryBoyId = String()
    static var pushNotificationObj : NotificationObjectModel?
    static var pushNotificationType : String?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    let signInConfig = GIDConfiguration.init(clientID: "651860703785-am67b73lv131cjjv47dhpsf079e4cfic.apps.googleusercontent.com")

    //Location
    var locationService = LocationService()
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.initializeSDK(nil)
        // GIDSignIn.sharedInstance().clientID = "651860703785-am67b73lv131cjjv47dhpsf079e4cfic.apps.googleusercontent.com"
        // Thread.sleep(forTimeInterval: 3.0)
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyAiBKDiFXeYbV2f23EBtmpk8pmZYgNgExo")
        GMSPlacesClient.provideAPIKey("AIzaSyAiBKDiFXeYbV2f23EBtmpk8pmZYgNgExo")
        setUpLocationServices()
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        registerForPushNotifications()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
                launchOptions
        )
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        return true
    }
    // MARK: - LocationManagerDelegate
    
    
    
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
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        var handled: Bool
//        handled = GIDSignIn.sharedInstance.handle(url)
//        if handled {
//            return true
//        }
//        return false
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        Singleton.sharedInstance.userCurrentLocation = location
    }
    // MARK: - LocationManagerDelegate
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        
//        SingletonClass.sharedInstance.arrCarLists
        
        print("Error: \(error)")
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
    
    func showCarDoorOpenVC(){
        let topVC = UIApplication.appTopViewController()
        if (topVC?.isKind(of: GasDoorOpenPopUpVC.self) ?? false){
            return
        }else{
//            let GasDoorOpenPopUpVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: GasDoorOpenPopUpVC.storyboardID) as! GasDoorOpenPopUpVC
//            GasDoorOpenPopUpVC.modalPresentationStyle = .fullScreen
//            topVC?.present(GasDoorOpenPopUpVC, animated: false, completion: nil)
            
            let GasDoorOpenPopUpVC: GasDoorOpenPopUpVC = GasDoorOpenPopUpVC.instantiate(fromAppStoryboard: .Main)
            GasDoorOpenPopUpVC.modalPresentationStyle = .overFullScreen
            topVC?.present(GasDoorOpenPopUpVC, animated: false, completion: nil)
        }
    }
    
    func hideCarDoorOpenVC(){
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
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
    static let refreshVehicleScreen = NSNotification.Name("refreshVehicleScreen")
    static let refreshHomeScreen = NSNotification.Name("refreshHomeScreen")
    static let refreshChatScreen = NSNotification.Name("refreshChatScreen")
    static let goToChatScreen = NSNotification.Name("goToChatScreen")
    static let openCarDoorScreen = NSNotification.Name("openCarDoorScreen")
    static let clearAddonArray = NSNotification.Name("clearAddonArray")
    static let refreshCompOrderScreen = NSNotification.Name("refreshCompOrderScreen")
    static let goToCompOrderScreen = NSNotification.Name("goToCompOrderScreen")
    static let goToUpcomingOrderScreen = NSNotification.Name("goToUpcomingOrderScreen")
}

enum NotificationTypes : String {
    case JobStarted = "jobStart"
    case JobCompleted = "jobComplete"
    case InvoiceGenerated = "invoiceGenerated"
    case Chatnewmessagereceived = "newMessage"
}
