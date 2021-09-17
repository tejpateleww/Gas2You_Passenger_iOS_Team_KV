//
//  NavigationViewController.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import UIKit

class NavigationController: UINavigationController {

    override var shouldAutorotate : Bool {
        return true
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23),NSAttributedString.Key.foregroundColor:UIColor.clear]
        self.navigationBar.titleTextAttributes = attributes
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .clear
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.barTintColor = UIColor.clear
        self.navigationBar.isTranslucent = true
    }
}

