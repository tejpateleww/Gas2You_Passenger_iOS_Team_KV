//
//  AddVehicleVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class AddVehicleVC: BaseVC {
    
    
    
    @IBOutlet weak var lblMake: themeLabel!
    @IBOutlet weak var lblYear: themeLabel!
    @IBOutlet weak var txtEnterYear: UITextField!
    @IBOutlet weak var txtEnterMake: UITextField!
    @IBOutlet weak var lblModel: themeLabel!
    @IBOutlet weak var txtEnterModel: UITextField!
    @IBOutlet weak var lblColor: themeLabel!
    @IBOutlet weak var txtEnterColor: UITextField!
    @IBOutlet weak var lblLicencePlateNum: themeLabel!
    @IBOutlet weak var txtLicencePlateNo: UITextField!
    @IBOutlet weak var btnSave: ThemeButton!
    
    let picker: GeneralPickerView = GeneralPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add Vehicle", controller: self)
        
        txtEnterYear.isUserInteractionEnabled = false
        txtEnterMake.isUserInteractionEnabled = false
        txtEnterModel.isUserInteractionEnabled = false
        txtEnterColor.isUserInteractionEnabled = false
        
        picker.generalPickerDelegate = self
    }
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension AddVehicleVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        
        return false
    }
}

extension AddVehicleVC: GeneralPickerViewDelegate{
    
    func didTapDone() {
        print("done button pressed")
    }
    
    func didTapCancel() {
        print("cancel button pressed")
    }
    
}
