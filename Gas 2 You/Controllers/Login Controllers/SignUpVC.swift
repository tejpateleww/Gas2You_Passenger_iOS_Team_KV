//
//  SignUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logInNowButtonPressed(_ sender: themeButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
