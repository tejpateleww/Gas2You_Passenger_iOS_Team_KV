//
//  MapVC.swift
//  Gas 2 You
//
//  Created by MacMini on 03/08/21.
//

import UIKit

class MapVC: BaseVC {
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            NavbarrightButton()
            NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
}
