//
//  AddVehicleVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit


protocol AddVehicleDelegate{
    func refreshVehicleScreen()
}
protocol editVehicleDelegate{
    func refreshVehicleScreenEdit()
}
class AddVehicleVC: BaseVC {
    @IBOutlet weak var lblMake: ThemeLabel!
    @IBOutlet weak var lblYear: ThemeLabel!
    @IBOutlet weak var txtEnterYear: UITextField!
    @IBOutlet weak var txtEnterMake: UITextField!
    @IBOutlet weak var lblModel: ThemeLabel!
    @IBOutlet weak var txtEnterModel: UITextField!
    @IBOutlet weak var lblColor: ThemeLabel!
    @IBOutlet weak var txtEnterColor: UITextField!
    @IBOutlet weak var lblLicencePlateNum: ThemeLabel!
    @IBOutlet weak var txtLicencePlateNo: UITextField!
    @IBOutlet weak var btnSave: ThemeButton!
    
    var delegateAdd : AddVehicleDelegate!
    var delegateEdit : editVehicleDelegate!
    var isfromEdit : Bool = false
    var isfromhome : Bool = false
    var yearPicker: UIPickerView = UIPickerView()
    var makePicker: UIPickerView = UIPickerView()
    var modelPicker: UIPickerView = UIPickerView()
    var colorPicker: UIPickerView = UIPickerView()
    var makeandmodelList = addVehicalViewModel()
    var vehiclecolorList = VehicleColorListViewModel()
    var AddVehicle = AddVehicleGetViewModel()
    var EditVehicle = EditVehicleGetViewModel()
    var yearVal = ["2001" , "2002" , "2003" , "2004" , "2005" , "2006"]
    var makeVal = [menufactureDatum]()
    var colorVal = [VehicleColorDatum]()
    var SelectedMakeIndex = -1
    var objData : VehicleListDatum?
    var make = ""
    var model = ""
    var color = ""
    
    var doneButton : (()->())?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isfromEdit{
            setup()
            NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Edit Vehicle", controller: self)
        }else{
            NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add Vehicle", controller: self)
        }
        self.makeandmodelList.webserviceofmakeandmodel()
        self.makeandmodelList.addvehicle = self
        self.vehiclecolorList.webserviceofcolorList()
        self.vehiclecolorList.Vehiclecolor = self
        self.AddVehicle.addvehicle = self
        self.EditVehicle.addvehicle = self
        yearPicker.delegate = self
        yearPicker.dataSource = self
        makePicker.delegate = self
        makePicker.dataSource = self
        modelPicker.delegate = self
        modelPicker.dataSource = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
        dismissPickerView()
        txtEnterYear.inputView = yearPicker
        txtEnterMake.inputView = makePicker
        txtEnterModel.inputView = modelPicker
        txtEnterColor.inputView = colorPicker
        yearPicker.addDoneOnKeyboardWithTarget(self, action: #selector(self.donePicker))
        txtEnterYear.delegate = self
        txtEnterMake.delegate = self
        txtEnterModel.delegate = self
        txtEnterColor.delegate = self
    }
    @objc func donePicker(){
        if let click = self.doneButton{
            click()
        }
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtEnterYear.inputAccessoryView = toolBar
        txtEnterColor.inputAccessoryView = toolBar
        txtEnterModel.inputAccessoryView = toolBar
        txtEnterMake.inputAccessoryView = toolBar
    }
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        if isfromEdit{
            EditVehicle.doLogin(vehicleId: objData?.id ?? "", year: txtEnterYear.text ?? "", make: make, model: model, color: color, plateno: txtLicencePlateNo.text ?? "")
            NotificationCenter.default.post(name: notifRefreshVehicleList, object: nil)
        }else{
            AddVehicle.doLogin(customerid: Singleton.sharedInstance.userId, year: txtEnterYear.text ?? "", make:make, model:model, color: color, plateno: txtLicencePlateNo.text ?? "")
        }
    }
    func setup() {
        txtEnterYear.text = objData?.year
        txtEnterMake.text = objData?.make
        txtEnterModel.text = objData?.model
        txtEnterColor.text = objData?.color
        txtLicencePlateNo.text = objData?.plateNumber
        make = objData?.makeId ?? ""
        model = objData?.modelId ?? ""
        color = objData?.colorId ?? ""
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
            if SelectedMakeIndex != -1 {
                return makeVal[SelectedMakeIndex].models?.count ?? 0
            } else {
                return 0
            }
        } else if txtEnterColor.isFirstResponder {
            return colorVal.count
        }
        return colorVal.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtEnterYear.isFirstResponder {
            return yearVal[row]
        } else if txtEnterMake.isFirstResponder {
            self.make = makeVal[row].id ?? ""
            return makeVal[row].manufacturerName
        } else if txtEnterModel.isFirstResponder {
            self.model = makeVal[SelectedMakeIndex].models?[row].id ?? ""
            return makeVal[SelectedMakeIndex].models?[row].modelName
        } else if txtEnterColor.isFirstResponder {
            self.color = colorVal[row].id ?? ""
            return colorVal[row].color
        }
        return colorVal[row].color
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.doneButton = {
            if self.txtEnterYear.isFirstResponder {
                self.txtEnterYear.text = self.yearVal[row]
                self.txtEnterYear.endEditing(true)
            } else if self.txtEnterMake.isFirstResponder {
                self.make = self.makeVal[row].id ?? ""
                self.SelectedMakeIndex = row
                self.txtEnterMake.text = self.makeVal[row].manufacturerName
                self.txtEnterMake.endEditing(true)
            } else if self.txtEnterModel.isFirstResponder {
                self.model = self.makeVal[self.SelectedMakeIndex].models?[row].id ?? ""
                self.txtEnterModel.text = self.makeVal[self.SelectedMakeIndex].models?[row].modelName
                self.txtEnterModel.endEditing(true)
            } else if self.txtEnterColor.isFirstResponder {
                self.color = self.colorVal[row].id ?? ""
                self.txtEnterColor.text = self.colorVal[row].color
                self.txtEnterColor.endEditing(true)
            }
        }
    }
}
extension AddVehicleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != txtLicencePlateNo{
            return false
        }else{
            return true
        }
    }
}
