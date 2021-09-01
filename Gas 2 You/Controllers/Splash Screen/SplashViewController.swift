//
//  SplashViewController.swift
//  Gas 2 You
//
//  Created by Apple on 27/08/21.
//

import UIKit
import Lottie
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
            animate()
            
            
            
            delay(2.0) {
                
            }
            
            // Do any additional setup after loading the view.
        }
        
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
        
        // ----------------------------------------------------
        // MARK: - --------- Custom Methods ---------
        // ----------------------------------------------------
        func animate() {
       
        animationView.frame = CGRect(x: 0, y: 0, width: vmAnimation.frame.width, height: vmAnimation.frame.height)
        animationView.contentMode = .scaleAspectFill
            animationView.animationSpeed = 2
        if !vmAnimation.subviews.contains(animationView){
            vmAnimation.addSubview(animationView)
        }
        animationView.play { (success) in
            
           // self.animate()
            self.delay(1.0) {
                self.navigationController?.navigationBar.isHidden = true
                if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
                   
                    AppDel.navigateToLogin()
                } else {

                    AppDel.navigateToHome()
                }
            }
            
        }
            
            
            
    }
    
   // ----------------------------------------------------
        // MARK: - --------- IBAction Methods ---------
        // ----------------------------------------------------
        
        
        
        // ----------------------------------------------------
        // MARK: - --------- Webservice Methods ---------
        // ----------------------------------------------------
        

}
   
