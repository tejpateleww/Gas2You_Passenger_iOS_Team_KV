//
//  AddNewVehicleVC.swift
//  Gas 2 You
//
//  Created by Tej P on 11/01/22.
//

import UIKit

class AddNewVehicleVC: BaseVC {
    
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtMakeOther: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtModelOther: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtLicense: UITextField!
    @IBOutlet weak var btnSave: ThemeButton!
    @IBOutlet weak var stackOtherMake: UIStackView!
    @IBOutlet weak var stackOtherModel: UIStackView!
    
    var arrPickerViews : [UIPickerView?] = []
    var arrTextFields : [UITextField?] = []
    var addVehicleViewModel = AddVehicleViewModel()
    
    var yearPicker: UIPickerView?
    var arrYearList : [String] = []
    
    var makePicker: UIPickerView?
    var arrMakeList : [menufactureDatum] = []
    
    var modelPicker: UIPickerView?
    var arrModelList : [Model] = []
    
    var colorPicker: UIPickerView?
    var arrColorList : [yearcolorstateListDatum] = []
    
    var statePicker: UIPickerView?
    var arrStateList : [StateList] = []
    
    let ACCEPTABLE_CHARACTERS_YEAR = "0123456789"
    let ACCEPTABLE_CHARACTERS_MAKE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
    let ACCEPTABLE_CHARACTERS_MODEL = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -()_"
    let ACCEPTABLE_CHARACTERS_COLOR = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
    let ACCEPTABLE_CHARACTERS_STATE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
    let ACCEPTABLE_CHARACTERS_LICENSE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-()"
    let ACCEPTABLE_CHARACTERS__OTHER_MODEL = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -()_"
    let ACCEPTABLE_CHARACTERS__OTHER_MAKE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -()_"
    
    var makeID:String = ""
    var modelID:String = ""
    var stateID:String = ""
    var colorID:String = ""
    
    var isFromEdit:Bool = false
    var editVehicleData : VehicleListDatum?
    
    //MARK: - Life-Cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        self.stackOtherMake.isHidden = true
        self.stackOtherModel.isHidden = true
        self.disableData()
        self.txtModel.isUserInteractionEnabled = false
        self.txtLicense.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    //MARK: - Custom methods
    func prepareView(){
        
        self.yearPicker = UIPickerView()
        self.makePicker = UIPickerView()
        self.modelPicker = UIPickerView()
        self.colorPicker = UIPickerView()
        self.statePicker = UIPickerView()
        
        self.arrPickerViews = [self.yearPicker,self.makePicker,self.modelPicker,self.colorPicker,self.statePicker]
        self.arrTextFields = [self.txtYear,self.txtMake,self.txtMakeOther,self.txtModelOther,self.txtColor,self.txtState]
        for picker in arrPickerViews{
            self.setupPickerDataSource(picker: picker)
        }
        
        self.AddDoneOnPicker()
        self.setupUI()
        self.setupData()
    }
    
    func setupPickerDataSource(picker : UIPickerView?){
        picker?.dataSource = self
        picker?.delegate = self
    }
    
    func setupUI(){
        if(isFromEdit){
            NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Edit Vehicle", controller: self)
            self.setupEditData()
        }else{
            NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add Vehicle", controller: self)
        }
        
        self.txtYear.inputView = self.yearPicker
        self.txtMake.inputView = self.makePicker
        self.txtModel.inputView = self.modelPicker
        self.txtColor.inputView = self.colorPicker
        self.txtState.inputView = self.statePicker
    }
    
    func setupEditData(){
        self.txtYear.text = self.editVehicleData?.year
        self.txtMake.text = self.editVehicleData?.make
        self.txtModel.text = self.editVehicleData?.model
        self.txtColor.text = self.editVehicleData?.color
        self.txtState.text = self.editVehicleData?.state_name
        self.txtLicense.text = self.editVehicleData?.plateNumber
        self.makeID = self.editVehicleData?.makeId ?? ""
        self.modelID = self.editVehicleData?.modelId ?? ""
        self.colorID = self.editVehicleData?.colorId ?? ""
        self.stateID = self.editVehicleData?.state_id ?? ""
        
        
    }
    
    func AddDoneOnPicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtYear.inputAccessoryView = toolBar
        txtColor.inputAccessoryView = toolBar
        txtModel.inputAccessoryView = toolBar
        txtMake.inputAccessoryView = toolBar
        txtState.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(){
        if(self.txtYear.isFirstResponder){
            if(self.txtYear.text == ""){
                self.txtYear.text = self.arrYearList[0]
            }
            self.txtYear.endEditing(true)
        }else if(self.txtMake.isFirstResponder){
            if(self.txtMake.text == ""){
                self.txtMake.text = self.arrMakeList[0].manufacturerName
                self.makeID = self.arrMakeList[0].id ?? ""
                self.stackOtherMake.isHidden = (self.txtMake.text == "Other") ? false : true
                self.txtModel.text = ""
                self.txtModel.isUserInteractionEnabled = true
                for make in arrMakeList{
                    if(make.id == self.arrMakeList[0].id){
                        self.arrModelList = make.models ?? []
                        break
                    }
                }
            }
            self.txtMake.endEditing(true)
        }else if(self.txtModel.isFirstResponder){
            if(self.txtModel.text == ""){
                self.txtModel.text = self.arrModelList[0].modelName
                self.modelID = self.arrModelList[0].id ?? ""
                self.stackOtherModel.isHidden = (self.txtModel.text == "Other") ? false : true
            }
            self.txtModel.endEditing(true)
        }else if(self.txtColor.isFirstResponder){
            if(self.txtColor.text == ""){
                self.txtColor.text = self.arrColorList[0].color
                self.colorID = arrColorList[0].id ?? ""
            }
            self.txtColor.endEditing(true)
        }else if(self.txtState.isFirstResponder){
            if(self.txtState.text == ""){
                self.txtLicense.isUserInteractionEnabled = true
                self.txtState.text = self.arrStateList[0].stateName
                self.stateID = self.arrStateList[0].id ?? ""
                self.txtLicense.text = "\(self.arrStateList[0].stateCode ?? "") - "
            }
            self.txtState.endEditing(true)
        }
    }
    
    func setupData(){
        self.callColorListAPI()
        self.callMakeAndModelListAPI()
    }
    
    func enableData(){
        for txtfield in self.arrTextFields{
            txtfield?.isUserInteractionEnabled = true
        }
    }
    
    func disableData(){
        for txtfield in self.arrTextFields{
            txtfield?.isUserInteractionEnabled = false
        }
    }
    
    func validation() -> Bool {
        if(self.txtYear.text == ""){
            Toast.show(title: UrlConstant.Required, message: "Please select year", state: .info)
            return false
        }else if(self.txtMake.text == ""){
            Toast.show(title: UrlConstant.Required, message: "Please select make", state: .info)
            return false
        }else if(self.txtModel.text == ""){
            Toast.show(title: UrlConstant.Required, message: "Please select model", state: .info)
            return false
        }else if(self.txtColor.text == ""){
            Toast.show(title: UrlConstant.Required, message: "Please select color", state: .info)
            return false
        }else if(self.txtState.text == ""){
            Toast.show(title: UrlConstant.Required, message: "Please select state", state: .info)
            return false
        }else if(self.txtLicense.text == ""){
            Toast.show(title: UrlConstant.Required, message: "Please enter license plate number", state: .info)
            return false
        }
        
        if(!self.stackOtherMake.isHidden){
            if(self.txtMakeOther.text?.trimmedString == ""){
                Toast.show(title: UrlConstant.Required, message: "Please enter make", state: .info)
                return false
            }
        }
        
        if(!self.stackOtherModel.isHidden){
            if(self.txtModelOther.text?.trimmedString == ""){
                Toast.show(title: UrlConstant.Required, message: "Please enter model", state: .info)
                return false
            }
        }
        
        let fullLicenceArr = txtLicense.text?.components(separatedBy: "- ")
        if(fullLicenceArr?.count ?? 0 > 1){
            if(fullLicenceArr?[1] == nil || fullLicenceArr?[1] == ""){
                Toast.show(title: UrlConstant.Required, message: "Please enter license plate number", state: .info)
                return false
            }
        }else{
            Toast.show(title: UrlConstant.Required, message: "Please enter license plate number", state: .info)
            return false
        }
        
        
        return true
    }
    
    //MARK: - UIButtonAction methods
    @IBAction func btnSaveAction(_ sender: Any) {
        if(self.validation()){
            if(isFromEdit){
                self.callEditNewVehicleAPI()
            }else{
                self.callAddNewVehicleAPI()
            }
        }
    }
    
}

//MARK: - UIPickerViewDelegate
extension AddNewVehicleVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView == self.yearPicker){
            return self.arrYearList.count
        }else if(pickerView == self.makePicker){
            return self.arrMakeList.count
        }else if(pickerView == self.modelPicker){
            return self.arrModelList.count
        }else if(pickerView == self.colorPicker){
            return self.arrColorList.count
        }else if(pickerView == self.statePicker){
            return self.arrStateList.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView == self.yearPicker){
            return self.arrYearList[row]
        }else if(pickerView == self.makePicker){
            return self.arrMakeList[row].manufacturerName
        }else if(pickerView == self.modelPicker){
            return self.arrModelList[row].modelName
        }else if(pickerView == self.colorPicker){
            return self.arrColorList[row].color
        }else if(pickerView == self.statePicker){
            return self.arrStateList[row].stateName
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if(pickerView == self.yearPicker){
            self.txtYear.text = self.arrYearList[row]
        }else if(pickerView == self.makePicker){
            self.txtMake.text = self.arrMakeList[row].manufacturerName
            self.makeID = self.arrMakeList[row].id ?? ""
            self.stackOtherMake.isHidden = (self.arrMakeList[row].manufacturerName == "Other") ? false : true
            self.txtModel.text = ""
            self.txtModel.isUserInteractionEnabled = true
            for make in arrMakeList{
                if(make.id == self.arrMakeList[row].id){
                    self.arrModelList = make.models ?? []
                    break
                }
            }
        }else if(pickerView == self.modelPicker){
            self.txtModel.text = self.arrModelList[row].modelName
            self.modelID = self.arrModelList[row].id ?? ""
            self.stackOtherModel.isHidden = (self.arrModelList[row].modelName == "Other") ? false : true
        }else if(pickerView == self.colorPicker){
            self.txtColor.text = arrColorList[row].color
            self.colorID = arrColorList[row].id ?? ""
        }else if(pickerView == self.statePicker){
            self.txtState.text = self.arrStateList[row].stateName
            self.stateID = self.arrStateList[row].id ?? ""
            self.txtLicense.text = "\(self.arrStateList[row].stateCode ?? "") - "
            self.txtLicense.isUserInteractionEnabled = true
        }else{
            
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension AddNewVehicleVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case self.txtYear :
            return false
            
        case self.txtMake :
            return false
            
        case self.txtModel :
            return false
            
        case self.txtColor :
            return false
            
        case self.txtState :
            return false
            
        case self.txtMakeOther :
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS__OTHER_MAKE).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return (string == filtered) ? (newString.length <= TEXTFIELD_OTHER_MAKE_MODEL) : false
            
        case self.txtModelOther :
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS__OTHER_MODEL).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return (string == filtered) ? (newString.length <= TEXTFIELD_OTHER_MAKE_MODEL) : false
            
        case txtLicense:
            
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    if(textField.text?.last == " "){
                        return false
                    }
                }
            }
            
            let currentString: NSString = txtLicense.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_LICENSE).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered) ? (newString.length <= TEXTFIELD_LICENSE) : false
            
        default:
            print("")
        }
        
        return true
    }
    
}

//MARK: - API call
extension AddNewVehicleVC {
    func callColorListAPI(){
        self.addVehicleViewModel.addNewVehicleVC = self
        self.addVehicleViewModel.webserviceGetColorListAPI()
    }
    
    func callMakeAndModelListAPI(){
        self.addVehicleViewModel.addNewVehicleVC = self
        self.addVehicleViewModel.webserviceGetMakeAndModelList()
    }
    
    func callAddNewVehicleAPI(){
        self.addVehicleViewModel.addNewVehicleVC = self
        
        let reqModel = AddNewVehicleReqModel()
        reqModel.year = self.txtYear.text ?? ""
        reqModel.make = self.makeID
        reqModel.model = self.modelID
        reqModel.color = self.colorID
        reqModel.state = self.stateID
        reqModel.licensePlateNumber = self.txtLicense.text ?? ""
        reqModel.isOtherMake = (!self.stackOtherMake.isHidden) ? true : false
        reqModel.OtherMakeName = (!self.stackOtherMake.isHidden) ? self.txtMakeOther.text : ""
        reqModel.isOtherModel = (!self.stackOtherModel.isHidden) ? true : false
        reqModel.OtherModelName = (!self.stackOtherModel.isHidden) ? self.txtModelOther.text : ""
        
        self.addVehicleViewModel.webserviceAddVehicle(reqModel)
    }
    
    func callEditNewVehicleAPI(){
        self.addVehicleViewModel.addNewVehicleVC = self
        
        let reqModel = EditNewVehicleReqModel()
        reqModel.vehicleId = self.editVehicleData?.id ?? ""
        reqModel.year = self.txtYear.text ?? ""
        reqModel.make = self.makeID
        reqModel.model = self.modelID
        reqModel.color = self.colorID
        reqModel.state = self.stateID
        reqModel.licensePlateNumber = self.txtLicense.text ?? ""
        reqModel.isOtherMake = (!self.stackOtherMake.isHidden) ? true : false
        reqModel.OtherMakeName = (!self.stackOtherMake.isHidden) ? self.txtMakeOther.text : ""
        reqModel.isOtherModel = (!self.stackOtherModel.isHidden) ? true : false
        reqModel.OtherModelName = (!self.stackOtherModel.isHidden) ? self.txtModelOther.text : ""
        
        self.addVehicleViewModel.webserviceEditVehicle(reqModel)
    }
}


