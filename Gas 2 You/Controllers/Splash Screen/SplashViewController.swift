//
//  SplashViewController.swift
//  Gas 2 You
//
//  Created by Apple on 27/08/21.
//

import UIKit
import Lottie
import CoreLocation

class SplashViewController: BaseVC {


    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var animationView = AnimationView(name: "Splash")

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
 
    
    @IBOutlet var vmAnimation: AnimationView!
    @IBOutlet weak var imgSplash: UIImageView!
    
 
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        let _ = Constants.userDefaults.getUserData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        self.imgSplash.layoutIfNeeded()
        self.imgSplash.layoutSubviews()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.imgSplash.frame.origin.x = -80
        } else {
            self.imgSplash.frame.origin.x = -40
        }
        UIView.animate(withDuration: 2.5, animations: {
            self.imgSplash.frame.origin.x = 0
        }, completion: {finished in
           
        })
       
        self.observeAnimationAndVersionChange()
        
        
    }

    override func viewDidLayoutSubviews() {
        let frame = CGRect(x: 0, y: 0, width: vmAnimation.frame.height, height: vmAnimation.frame.height)
        animationView.frame = frame
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func observeAnimationAndVersionChange() {
        let group = DispatchGroup()
        group.enter()
        // call closure only once need to set root viewController
        webserviceInit {
            group.leave()
        }
        group.enter()
        animate() {
            group.leave()
        }
        group.notify(queue: .main) {
            self.setRootViewController()
        }
    }


    func delay(_ delay: Double, closure: @escaping EmptyClosure) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
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
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func animate(completion: @escaping EmptyClosure) {
        animationView.frame = CGRect(x: 0, y: 0, width: vmAnimation.frame.height, height: vmAnimation.frame.height)
        animationView.contentMode = .scaleAspectFill
        if !vmAnimation.subviews.contains(animationView){
            vmAnimation.addSubview(animationView)
        }
        animationView.play { (success) in
            self.delay(1.0, closure: completion)
        }
    }
}

//MARK:- Apis
extension SplashViewController {
    func webserviceInit(completion: @escaping EmptyClosure){
        WebServiceSubClass.InitApi { (status, message, response, error) in
            if let dic = error as? [String: Any], let msg = dic["The request timed out"] as? String, msg == UrlConstant.NoInternetConnection || msg == UrlConstant.SomethingWentWrong || msg == UrlConstant.RequestTimeOut{
                Utilities.showAlertWithTitleFromVC(vc: self, title: Constants.appName, message: msg, buttons: [UrlConstant.Retry], isOkRed: false) { (ind) in
                    self.webserviceInit(completion: completion)
                }
                return
            }

            if status {
                Singleton.sharedInstance.appInitModel = response
                if let responseDic = error as? [String:Any], let _ = responseDic["update"] as? Bool{
                    Utilities.showAlertWithTitleFromWindow(title: Constants.appName, andMessage: message, buttons: [UrlConstant.Ok,UrlConstant.Cancel]) { (ind) in
                        if ind == 0{
                            if let url = URL(string: Constants.appURL) {
                                UIApplication.shared.open(url)
                            }
                        }else {
                            completion()
                        }
                    }
                }else{
                    completion()
                }
            }else{
                if let responseDic = error as? [String:Any], let _ = responseDic["maintenance"] as? Bool{
                    Utilities.showAlertWithTitleFromWindow(title: Constants.appName, andMessage: message, buttons: []) {_ in}
                }else{
                    if let responseDic = error as? [String:Any], let _ = responseDic["update"] as? Bool{
                        if(responseDic["update"] as? Bool == false){
                            Utilities.showAlertWithTitleFromWindow(title: Constants.appName, andMessage: message, buttons: [UrlConstant.Ok,UrlConstant.Cancel]) { (ind) in
                                if ind == 0{
                                    if let url = URL(string: Constants.appURL) {
                                        UIApplication.shared.open(url)
                                    }
                                }else {
                                    completion()
                                }
                            }
                        }else{
                            self.openForceUpdateAlert(msg: message)
                        }
                    }else{
                        Utilities.showAlertOfAPIResponse(param: error, vc: self)
                    }
                }
            }

            //Location Update
            let status = CLLocationManager.authorizationStatus()
            if(status == .authorizedAlways || status == .authorizedWhenInUse){
                AppDel.locationService.startUpdatingLocation()
            }
        }
    }
}

//MARK:- Common Methods
extension SplashViewController {
    func openForceUpdateAlert(msg: String){
        Utilities.showAlertWithTitleFromWindow(title: Constants.appName, andMessage: msg, buttons: [UrlConstant.Ok]) { (ind) in
            if ind == 0{
                if let url = URL(string: Constants.appURL) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }

    func setRootViewController() {
        let isLogin = UserDefaults.standard.bool(forKey: UserDefaultsKey.isUserLogin.rawValue)
        if isLogin, let _ = Constants.userDefaults.getUserData() {
            Constants.appDel.navigateToHome()
        }else{
            Constants.appDel.navigateToLogin()
        }
    }
}

