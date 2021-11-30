//
//  AddVehicleVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit


protocol
AddVehicleDelegate{
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
    @IBOutlet weak var txtStateName: UITextField!
    @IBOutlet weak var btnSave: ThemeButton!
    
    var delegateAdd : AddVehicleDelegate!
    var delegateEdit : editVehicleDelegate!
    var isfromEdit : Bool = false
    var isfromhome : Bool = false
    var yearPicker: UIPickerView = UIPickerView()
    var makePicker: UIPickerView = UIPickerView()
    var modelPicker: UIPickerView = UIPickerView()
    var colorPicker: UIPickerView = UIPickerView()
    var statePicker: UIPickerView = UIPickerView()
    var makeandmodelList = addVehicalViewModel()
    var vehiclecolorList = VehicleColorListViewModel()
    var AddVehicle = AddVehicleGetViewModel()
    var EditVehicle = EditVehicleGetViewModel()
    var yearVal : [String] = []
    var makeVal = [menufactureDatum]()
    var colorVal = [yearcolorstateListDatum]()
    var stateList = [StateList]()
    var SelectedMakeIndex = -1
    var objData : VehicleListDatum?
    var make = ""
    var model = ""
    var color = ""
    var state = ""
        
    
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
        statePicker.delegate = self
        statePicker.dataSource = self
        dismissPickerView()
//        yearPicker.addDoneOnKeyboardWithTarget(self, action: #selector(self.donePicker))
        txtEnterYear.delegate = self
        txtEnterMake.delegate = self
        txtEnterModel.delegate = self
        txtEnterColor.delegate = self
        txtLicencePlateNo.delegate = self
        txtStateName.delegate = self
    }
    @objc func donePicker(){
        if self.txtEnterYear.isFirstResponder {
            let row = yearPicker.selectedRow(inComponent: 0);
            if yearVal.count != 0{
                self.txtEnterYear.text = self.yearVal[row]
                pickerView(yearPicker, didSelectRow: row, inComponent:0)
                txtEnterYear.endEditing(true)
            }else{
                txtEnterYear.endEditing(true)
            }
        } else if self.txtEnterMake.isFirstResponder {
            let row = makePicker.selectedRow(inComponent: 0);
            if isfromEdit{
                if makeVal.count != 0{
                    self.make = self.makeVal[row].id ?? ""
                    self.SelectedMakeIndex = row
                    self.txtEnterMake.text = self.makeVal[row].manufacturerName
                    self.txtEnterModel.text = ""
                    txtEnterMake.endEditing(true)
                }else{
                    txtEnterMake.endEditing(true)
                }
            }else{
                if makeVal.count != 0{
                    self.make = self.makeVal[row].id ?? ""
                    self.SelectedMakeIndex = row
                    self.txtEnterMake.text = self.makeVal[row].manufacturerName
                    self.txtEnterModel.text = ""
                    txtEnterMake.endEditing(true)
                }else{
                    txtEnterMake.endEditing(true)
                }
            }
        } else if self.txtEnterModel.isFirstResponder {
            let row = modelPicker.selectedRow(inComponent: 0);
            if isfromEdit{
                if self.makeVal[SelectedMakeIndex].models?.count != 0{
                    self.model = self.makeVal[SelectedMakeIndex].models?[row].id ?? ""
                    self.txtEnterModel.text = self.makeVal[SelectedMakeIndex].models?[row].modelName
                    txtEnterModel.endEditing(true)
                }else{
                    txtEnterModel.endEditing(true)
                }
            }else{
                if self.makeVal[self.SelectedMakeIndex].models?.count != 0{
                    self.model = self.makeVal[self.SelectedMakeIndex].models?[row].id ?? ""
                    self.txtEnterModel.text = self.makeVal[self.SelectedMakeIndex].models?[row].modelName
                    txtEnterModel.endEditing(true)
                }else{
                    txtEnterModel.endEditing(true)
                }
            }
        } else if self.txtEnterColor.isFirstResponder {
            let row = colorPicker.selectedRow(inComponent: 0);
            if colorVal.count != 0{
            self.color = self.colorVal[row].id ?? ""
            self.txtEnterColor.text = self.colorVal[row].color
            txtEnterColor.endEditing(true)
            }else{
                txtEnterColor.endEditing(true)
            }
        }else if self.txtStateName.isFirstResponder{
            let row = statePicker.selectedRow(inComponent: 0);
            if stateList.count != 0{
                self.state = self.stateList[row].id ?? ""
                self.txtStateName.text = self.stateList[row].stateName
                pickerView(statePicker, didSelectRow: row, inComponent:0)
                txtStateName.endEditing(true)
            }else{
                txtStateName.endEditing(true)
            }
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
        txtStateName.inputAccessoryView = toolBar
    }
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        if isfromEdit{
            if validation(){
                EditVehicle.doLogin(vehicleId: objData?.id ?? "", year: txtEnterYear.text ?? "", make: make, model: model, color: color, state: state, plateno: txtLicencePlateNo.text ?? "")
                NotificationCenter.default.post(name: notifRefreshVehicleList, object: nil)
            }
        }else{
            if validation(){
                AddVehicle.doLogin(customerid: Singleton.sharedInstance.userId, year: txtEnterYear.text ?? "", make:make, model:model, color: color, state: state, plateno: txtLicencePlateNo.text ?? "")
            }
        }
    }
    func setup() {
        txtEnterYear.text = objData?.year
        txtEnterMake.text = objData?.make
        txtEnterModel.text = objData?.model
        txtEnterColor.text = objData?.color
        txtStateName.text = objData?.state_name
        txtLicencePlateNo.text = objData?.plateNumber
        make = objData?.makeId ?? ""
        model = objData?.modelId ?? ""
        color = objData?.colorId ?? ""
        state = objData?.state_id ?? ""
    }
    //MARK: - Validation
    func validation() -> Bool{
        var stringData : String?
        let strTitle = "Please select "
        let plateno = txtLicencePlateNo.validatedText(validationType: .requiredField(field: txtLicencePlateNo.placeholder?.lowercased() ?? ""))
        if txtEnterYear.text == ""{
            Toast.show(title: UrlConstant.Required, message: strTitle + "year", state: .info)
            return false
        }else if txtEnterMake.text == ""{
            //            Utilities.ShowAlertOfrequired(OfMessage: strTitle + "make")
            Toast.show(title: UrlConstant.Required, message: strTitle + "make", state: .info)
            return false
        }else if txtEnterModel.text == ""{
            //            Utilities.ShowAlertOfrequired(OfMessage: strTitle + "model")
            Toast.show(title: UrlConstant.Required, message: strTitle + "model", state: .info)
            return false
        }else if txtEnterColor.text == ""{
            //            Utilities.ShowAlertOfrequired(OfMessage: strTitle + "color")
            Toast.show(title: UrlConstant.Required, message: strTitle + "color", state: .info)
            return false
        }else if txtStateName.text == ""{
            Toast.show(title: UrlConstant.Required, message: strTitle + "state", state: .info)
            return false
        }else if !plateno.0 {
            stringData = plateno.1
        }
        
        if let str = stringData  {
            //            Utilities.ShowAlertOfrequired(OfMessage: str)
            Toast.show(title: UrlConstant.Required, message: str, state: .info)
            return false
        }
        return true
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
            if isfromEdit{
                if SelectedMakeIndex != -1 {
                    
                    return makeVal[SelectedMakeIndex].models?.count ?? 0
                } else {
                    return 0
                }
            }else{
                if SelectedMakeIndex != -1 {
                    return makeVal[SelectedMakeIndex].models?.count ?? 0
                } else {
                    return 0
                }
            }
        }else if txtEnterColor.isFirstResponder {
            return colorVal.count
        }else if txtStateName.isFirstResponder{
            return stateList.count
        }
        return colorVal.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtEnterYear.isFirstResponder {
            return yearVal[row]
        } else if txtEnterMake.isFirstResponder {
            return makeVal[row].manufacturerName
        } else if txtEnterModel.isFirstResponder {
            if isfromEdit{
                return makeVal[SelectedMakeIndex].models?[row].modelName
            }else{
                return makeVal[SelectedMakeIndex].models?[row].modelName
            }
        } else if txtEnterColor.isFirstResponder {
            return colorVal[row].color
        } else if txtStateName.isFirstResponder{
            return stateList[row].stateName
        }
        return colorVal[row].color
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
extension AddVehicleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-"
        let currentString: NSString = txtLicencePlateNo.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if textField != txtLicencePlateNo{
            return false
        }else{
            return (string == filtered) ? (newString.length <= TEXTFIELD_MaximumLimitPASSWORD) : false
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEnterYear:
            if yearVal.count != 0{
                txtEnterYear.inputView = yearPicker
                return true
            }else{
                Toast.show(title: UrlConstant.Failed, message: "Year data is empty", state: .failure)
            }
        case txtEnterMake:
            if txtEnterYear.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select year", state: .info)
            }else{
                if makeVal.count != 0{
                    txtEnterMake.inputView = makePicker
                    return true
                }else{
                    Toast.show(title: UrlConstant.Failed, message: "Make data is empty", state: .failure)
                }
            }
        case txtEnterModel:
            if isfromEdit{
                if txtEnterYear.text == ""{
                    Toast.show(title: UrlConstant.Required, message: "Please select year", state: .info)
                }else if txtEnterMake.text == ""{
                    Toast.show(title: UrlConstant.Required, message: "Please select make", state: .info)
                }else{
                    if makeVal[SelectedMakeIndex].models?.count != 0{
                        txtEnterModel.inputView = modelPicker
                        return true
                    }else{
                        Toast.show(title: UrlConstant.Failed, message: "Model data is empty", state: .failure)
                    }
                }
            }else{
                if txtEnterYear.text == ""{
                    Toast.show(title: UrlConstant.Required, message: "Please select year", state: .info)
                }else if txtEnterMake.text == ""{
                    Toast.show(title: UrlConstant.Required, message: "Please select make", state: .info)
                }else{
                    if makeVal[SelectedMakeIndex].models?.count != 0{
                        txtEnterModel.inputView = modelPicker
                        return true
                    }else{
                        Toast.show(title: UrlConstant.Failed, message: "Model data is empty", state: .failure)
                    }
                }
            }
        case txtEnterColor:
            if txtEnterYear.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select year", state: .info)
            }else if txtEnterMake.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select make", state: .info)
            }else if txtEnterModel.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select model", state: .info)
            }else{
                if colorVal.count != 0{
                    txtEnterColor.inputView = colorPicker
                    return true
                }else{
                    Toast.show(title: UrlConstant.Failed, message: "Color data is empty", state: .failure)
                }
            }
        case txtStateName:
            if txtEnterYear.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select year", state: .info)
            }else if txtEnterMake.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select make", state: .info)
            }else if txtEnterModel.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select model", state: .info)
            }else if txtEnterColor.text == ""{
                Toast.show(title: UrlConstant.Required, message: "Please select color", state: .info)
            }else{
                if stateList.count != 0{
                    txtStateName.inputView = statePicker
                    return true
                }else{
                    Toast.show(title: UrlConstant.Failed, message: "Color data is empty", state: .failure)
                }
            }
        case txtLicencePlateNo:
            return true
        default:
            break
        }
        return false
    }
}
