//
//  SignUpVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit
import SafariServices

class SignUpVC: BaseVC {

    class func getNewInstance() -> SignUpVC {
        UIStoryboard(storyboard: .auth).instantiate()
    }

    @IBOutlet weak var btnLoginNow: ThemeButton!
    @IBOutlet weak var txtFirstName: ThemeTextfield!
    @IBOutlet weak var txtLastName: ThemeTextfield!
    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var txtPhoneNo: ThemeTextfield!
    @IBOutlet weak var txtPassword: ThemeTextfield!
    @IBOutlet weak var txtConfirmPassword: ThemeTextfield!
    @IBOutlet weak var btnTerms: ThemeButton!
    @IBOutlet weak var btnPrivacy: ThemeButton!
    @IBOutlet weak var btnSignup: ThemeButton!
    
    private let viewModel = SignupViewModel()
    var otpUserModel = SignupViewModel()
    
    
    var strOtp = ""
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
    let ACCEPTABLE_CHARACTERS_FOR_EMAIL = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@."
    let ACCEPTABLE_CHARACTERS_FOR_PHONE = "0123456789"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        btnTerms.underline()
        btnPrivacy.underline()
        setupUI()
        
    }
    func storeDataInRegisterModel(){
        let registerRequestModel = RegisterRequestModel()
        registerRequestModel.firstName = self.txtFirstName.text ?? ""
        registerRequestModel.lastName = self.txtLastName.text ?? ""
        registerRequestModel.countryCode = "+91"
        
        registerRequestModel.phone = self.txtPhoneNo.text ?? ""
        registerRequestModel.email = self.txtEmail.text ?? ""
        registerRequestModel.password = self.txtPassword.text ?? ""
        if #available(iOS 13.0, *) {
            let OtpVC = storyboard?.instantiateViewController(identifier: OtpVC.className) as! OtpVC
            OtpVC.registerRequestModel = registerRequestModel
            OtpVC.StringOTP = self.strOtp
            navigationController?.pushViewController(OtpVC, animated: true)
        }else{
            let OtpVC = storyboard?.instantiateViewController(withIdentifier: OtpVC.className) as! OtpVC
            OtpVC.registerRequestModel = registerRequestModel
            OtpVC.StringOTP = self.strOtp
            navigationController?.pushViewController(OtpVC, animated: true)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func setupUI() {
        if UIDevice.current.userInterfaceIdiom == .phone{
            btnLoginNow.setunderline(title: btnLoginNow.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        }else{
            btnLoginNow.setunderline(title: btnLoginNow.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(21))
        }
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "", controller: self)
        setupPhoneTextField()
    }
    func previewDocument(strURL : String){
        guard let url = URL(string: strURL) else {return}
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    private func setupPhoneTextField() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 20))
        txtPhoneNo.font = FontBook.regular.of(size : 16)
        txtPhoneNo.leftView = paddingView
        txtPhoneNo.leftViewMode = .always
        txtPhoneNo.layer.borderWidth = 1
        txtPhoneNo.layer.borderColor = UIColor.white.cgColor
        txtPhoneNo.layer.cornerRadius = 8
    }

    
    @IBAction func btnTermsClick(_ sender: Any) {
        var TC = ""
        if let TCLink = Singleton.sharedInstance.appInitModel?.appLinks.filter({ $0.name == "terms_and_condition"}) {
            if TCLink.count > 0 {
                TC = TCLink[0].url ?? ""
                self.previewDocument(strURL: TC)
            }
        }
    }
    @IBAction func btnPrivacyClick(_ sender: Any) {
        var PP = ""
        if let PPLink = Singleton.sharedInstance.appInitModel?.appLinks.filter({ $0.name == "privacy_policy"}) {
            if PPLink.count > 0 {
                PP = PPLink[0].url ?? ""
                self.previewDocument(strURL: PP)
            }
        }
    }
    @IBAction func btnSignupTap(_ sender: ThemeButton) {
        view.endEditing(true)
        if self.validation(){
            self.callOtpApi()
        }
    }
    func validation() -> Bool{
        let txtTemp = UITextField()
        var strTitle : String?
        let firstName = txtFirstName.validatedText(validationType: .username(field: txtFirstName.placeholder?.lowercased() ?? ""))
        let lastName = txtLastName.validatedText(validationType: .username(field: txtLastName.placeholder?.lowercased() ?? ""))
        
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmailRequired = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtEmail.placeholder?.lowercased() ?? ""))
        let checkEmail = txtTemp.validatedText(validationType: .email)
        let mobileNo = txtPhoneNo.validatedText(validationType: .requiredField(field: txtPhoneNo.placeholder?.lowercased() ?? ""))
        let password = txtPassword.validatedText(validationType: .password(field: txtPassword.placeholder?.lowercased() ?? ""))
        let Confpassword = txtConfirmPassword.validatedText(validationType: .password(field: txtConfirmPassword.placeholder?.lowercased() ?? ""))
        
        
        if !firstName.0{
            strTitle = firstName.1
        }else if !lastName.0{
            strTitle = lastName.1
        }else if(!checkEmailRequired.0){
            Toast.show(title: UrlConstant.Required, message: "Please enter email", state: .info)
            return checkEmailRequired.0
        }else if !checkEmail.0{
            strTitle = checkEmail.1
        }else if !mobileNo.0{
            strTitle = mobileNo.1
        }else if txtPhoneNo.text?.count != 10 {
            strTitle = UrlConstant.ValidPhoneNo
        }
        else if !password.0{
            strTitle = password.1
        }else if !Confpassword.0{
            strTitle = Confpassword.1
        }else if txtPassword.text?.lowercased() != txtConfirmPassword.text?.lowercased(){
            Toast.show(title: UrlConstant.Required, message: "Password and confirm password must be same", state: .info)
            return false
        }
        
        
        if let str = strTitle{
            Toast.show(title: UrlConstant.Required, message:str, state: .info)
            return false
        }
//
        return true
    }
}

// MARK: - TextField delegate
extension SignUpVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFirstName:
            txtLastName.becomeFirstResponder()
        case txtLastName:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            txtPhoneNo.becomeFirstResponder()
        case txtPhoneNo:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtConfirmPassword.becomeFirstResponder()
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
        
        case self.txtFirstName :
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
            
        case self.txtEmail :
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_FOR_EMAIL).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
            
        case self.txtPhoneNo :
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_FOR_PHONE).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return (string == filtered) ? (newString.length <= MAX_PHONE_DIGITS) : false
            
        case self.txtPassword :
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in current password", vc: self)
                   return false
               }
            return (newString.length <= TEXTFIELD_MaximumLimitPASSWORD)
            
        case self.txtConfirmPassword :
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in current password", vc: self)
                   return false
               }
            return (newString.length <= TEXTFIELD_MaximumLimitPASSWORD)
            
        default:
            print("")
        }
        return true
    }

}

extension SignUpVC{
    func callOtpApi(){
        otpUserModel.signupmodel = self
        let otpReqModel = OTPRequestModel()
        otpReqModel.email = txtEmail.text
        otpUserModel.webserviceSignupOtp(reqModel: otpReqModel)
    }
}
