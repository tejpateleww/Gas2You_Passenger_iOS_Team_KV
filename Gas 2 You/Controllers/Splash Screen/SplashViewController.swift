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


    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        observeAnimationAndVersionChange()
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

    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func animate(completion: @escaping EmptyClosure) {
        animationView.frame = CGRect(x: 0, y: 0, width: vmAnimation.frame.width, height: vmAnimation.frame.height)
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
                        self.openForceUpdateAlert(msg: message)
                    }else{
                        Utilities.showAlertOfAPIResponse(param: error, vc: self)
                    }
                }
            }

            //Location Update
            let status = CLLocationManager.authorizationStatus()
            if(status == .authorizedAlways || status == .authorizedWhenInUse){
                Constants.appDel.locationService.startUpdatingLocation()
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
                self.openForceUpdateAlert(msg: msg)
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

