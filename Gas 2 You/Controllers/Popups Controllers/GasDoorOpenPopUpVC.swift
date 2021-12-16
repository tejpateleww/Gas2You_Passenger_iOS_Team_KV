//
//  GasDoorOpenPopUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 12/08/21.
//

import UIKit

class GasDoorOpenPopUpVC: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgGasdoor: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwBlur: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwBlur.layer.cornerRadius = 20
    }
    @IBAction func btnCloseTap(_ sender: UIButton) {
        AppDel.hideCarDoorOpenVC()
    }
    
}
