//
//  AddVehicleVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class AddVehicleVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add Vehicle", controller: self)
    }
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        navigationController?.popViewController(animated: true)
    }
}
