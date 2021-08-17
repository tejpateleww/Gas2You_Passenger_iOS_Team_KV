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
    
    var yearPicker: UIPickerView = UIPickerView()
    var makePicker: UIPickerView = UIPickerView()
    var modelPicker: UIPickerView = UIPickerView()
    var colorPicker: UIPickerView = UIPickerView()
    
    var yearVal = ["2001" , "2002" , "2003" , "2004" , "2005" , "2006"]
    var makeVal = ["Toyota", "Lexus", "Porche", "Maruti", "Sobaru", "Audi"]
    var modelVal = ["Thar", "Civic", "Supra", "M5" , "Superb", "R8"]
    var colorVal = ["White", "Matt Black", "Gray", "Blue", "Yellow", "Red"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add Vehicle", controller: self)
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        makePicker.delegate = self
        makePicker.dataSource = self
        modelPicker.delegate = self
        modelPicker.dataSource = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        txtEnterYear.inputView = yearPicker
        txtEnterMake.inputView = makePicker
        txtEnterModel.inputView = modelPicker
        txtEnterColor.inputView = colorPicker
        
        txtEnterYear.delegate = self
        txtEnterMake.delegate = self
        txtEnterModel.delegate = self
        txtEnterColor.delegate = self
        
        
    }
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension AddVehicleVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtEnterYear.isFirstResponder {
            return yearVal.count
        } else if txtEnterMake.isFirstResponder {
            return makeVal.count
        } else if txtEnterModel.isFirstResponder {
            return modelVal.count
        } else if txtEnterColor.isFirstResponder {
            return colorVal.count
        }
        return colorVal.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtEnterYear.isFirstResponder {
            return yearVal[row]
        } else if txtEnterMake.isFirstResponder {
            return makeVal[row]
        } else if txtEnterModel.isFirstResponder {
            return modelVal[row]
        } else if txtEnterColor.isFirstResponder {
            return colorVal[row]
        }
        return colorVal[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if txtEnterYear.isFirstResponder {
            txtEnterYear.text = yearVal[row]
        } else if txtEnterMake.isFirstResponder {
            txtEnterMake.text = makeVal[row]
        } else if txtEnterModel.isFirstResponder {
            txtEnterModel.text = modelVal[row]
        } else if txtEnterColor.isFirstResponder {
            txtEnterColor.text = colorVal[row]
        }
    }
}

extension AddVehicleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
