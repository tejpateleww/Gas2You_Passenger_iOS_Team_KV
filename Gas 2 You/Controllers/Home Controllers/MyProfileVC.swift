//
//  MyProfileVC.swift
//  Gas 2 You
//
//  Created by MacMini on 10/08/21.
//

import UIKit

class MyProfileVC: BaseVC {
    
    var updateprofileviewmodel = MyProfileViewModel()
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
    
    @IBOutlet weak var changePassButton: ThemeButton!
    @IBOutlet weak var lblFullName: ThemeLabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblEmail: ThemeLabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblMobile: ThemeLabel!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var lblMyGarage: ThemeLabel!
    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var btnSave: ThemeButton!
    @IBOutlet weak var lblLastName: ThemeLabel!
    @IBOutlet weak var txtLastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateprofileviewmodel.myprofilevc = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "My Profile", controller: self)
        navBarRightImage()
        setData()
        txtUserName.delegate = self
        txtMobile.delegate = self
        txtLastName.delegate = self
        changePassButton.layer.cornerRadius = 10
        changePassButton.layer.borderWidth = 2
        changePassButton.layer.borderColor = UIColor.appColor(.themeBlue).cgColor
        changePassButton.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(14)
        changePassButton.setTitleColor(UIColor.appColor(.themeBlue), for: .normal)
    }
    func setData(){
        let userData = Singleton.sharedInstance.userProfilData
        txtEmail.text = userData?.email
        txtMobile.text = userData?.mobileNo
        txtUserName.text = userData?.firstName
        txtLastName.text = userData?.lastName
        setupPhoneTextField()
    }
    private func setupPhoneTextField() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 20))
        txtMobile.font = FontBook.regular.of(size : 16)
        txtMobile.leftView = paddingView
        txtMobile.leftViewMode = .always
    }
    func validation() -> Bool{
        var strTitle : String?
        let firstName = txtUserName.validatedText(validationType: .username(field: txtUserName.placeholder?.lowercased() ?? ""))
        let lastName = txtLastName.validatedText(validationType: .username(field: txtLastName.placeholder ?? ""))
        let mobileNo = txtMobile.validatedText(validationType: .phoneNo)
        
        if !(firstName.0){
            strTitle = firstName.1
        }else if !lastName.0{
            strTitle = lastName.1
        }else if !(txtMobile.text?.isEmptyOrWhitespace() ?? false){
            if txtMobile.text?.count != 10 {
                strTitle = UrlConstant.ValidPhoneNo
            }
        }
        
        if let str = strTitle{
            Utilities.ShowAlertOfValidation(OfMessage: str)
            //Toast.show(title: UrlConstant.Required, message: str, state: .failure)
            return false
        }
        
        return true
    }
    @IBAction func btnMyGarageTap(_ sender: UIButton) {
        let myGarageVC: MyGarageVC = MyGarageVC.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(myGarageVC, animated: true)
    }
    
    @IBAction func btnChangePasswordTap(_ sender: ThemeButton) {
        self.push(ChangePasswordVC.getNewInstance())
    }
    
    @IBAction func btnSaveTap(_ sender: ThemeButton) {
        if validation(){
            self.updateprofileviewmodel.doLogin(customerid: Singleton.sharedInstance.userId, firstname: txtUserName.text ?? "", lastname: txtLastName.text ?? "", mobileno: txtMobile.text ?? "")
        }
    }
}
extension MyProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtUserName:
            txtLastName.becomeFirstResponder()
        case txtLastName:
            txtMobile.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newString.hasPrefix(" "){
            textField.text = ""
            return false
        }
        switch textField {
            
        case self.txtUserName :
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in first name", vc: self)
                   return false
               }
            return (string == filtered) ? (newString.length <= TEXTFIELD_MaximumLimit) : false
        case self.txtLastName:
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in last name", vc: self)
                   return false
               }
            return (string == filtered) ? (newString.length <= TEXTFIELD_MaximumLimit) : false
        default:
            print("")
        }
        return true
    }
    
}
