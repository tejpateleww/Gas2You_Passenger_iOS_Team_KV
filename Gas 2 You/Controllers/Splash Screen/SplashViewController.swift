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
        
        
        // ----------------------------------------------------
        // MARK: - --------- IBOutlets ---------
        // ----------------------------------------------------
        
    @IBOutlet var vmAnimation: AnimationView!

        
        // ----------------------------------------------------
        // MARK: - --------- Life-cycle Methods ---------
        // ----------------------------------------------------
        
        override func viewDidLoad() {
            super.viewDidLoad()
            playAnimation()
            self.navigationController?.navigationBar.isHidden = true
            // Do any additional setup after loading the view.
        }
        
        
        // ----------------------------------------------------
        // MARK: - --------- Custom Methods ---------
        // ----------------------------------------------------
    func playAnimation() {
        vmAnimation.backgroundColor = .clear
        vmAnimation.contentMode = .scaleAspectFill
        vmAnimation.play()
    }
        
        
        // ----------------------------------------------------
        // MARK: - --------- IBAction Methods ---------
        // ----------------------------------------------------
        
        
        
        // ----------------------------------------------------
        // MARK: - --------- Webservice Methods ---------
        // ----------------------------------------------------
        

}
   
