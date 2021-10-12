//
//  LogInVC.swift
//  Gas 2 You
//
//  Created by MacMini on 29/07/21.
//

import UIKit

class LogInVC: UIViewController {

    class func getNewInstance() -> LogInVC {
        UIStoryboard(storyboard: .auth).instantiate()
    }

    @IBOutlet weak var btnPrivacyPolicy: ThemeButton!
    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var txtPassword: ThemeTextfield!
    @IBOutlet weak var btnSignUp: ThemeButton!
    @IBOutlet weak var btnLogin: ThemeButton!
    @IBOutlet weak var btnTerms: ThemeButton!
    
    
    private let viewModel = LoginViewModel()
    var googleSignInManager : GoogleLoginProvider?
    var appleSignInManager : AppleSignInProvider?
    var locationManager : LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        txtPassword.delegate = self
        let _ = self.getLocation()
        btnTerms.underline()
        btnPrivacyPolicy.underline()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.text = ""
        txtPassword.text = ""
    }
    func getLocation() -> Bool {
        if Singleton.sharedInstance.userCurrentLocation == nil{
            self.locationManager = LocationService()
            self.locationManager?.startUpdatingLocation()
            return false
        }else{
            return true
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    @IBAction func btnSocialRequests(_ sender: UIButton) {
        self.view.endEditing(true)
        print(#function)
        
        if self.getLocation(){
            if sender.tag == 0{
                let faceBookSignInManager = FacebookLoginProvider(self)
                faceBookSignInManager.delegate = self
                faceBookSignInManager.fetchToken(from: self)
            }else if sender.tag == 1{
                self.googleSignInManager = GoogleLoginProvider(self)
                self.googleSignInManager?.delegate = self
            }else{
                self.appleSignInManager = AppleSignInProvider()
                self.appleSignInManager?.delegate = self
            }
        }
    }
    func setupUI() {
        btnSignUp.setunderline(title: btnSignUp.titleLabel?.text ?? "", color: .white, font: CustomFont.PoppinsSemiBold.returnFont(16))
        setupTextfields(textfield: txtPassword)
    }

    private func setupTextfields(textfield: UITextField) {

        textfield.rightViewMode = .always
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 40))
        button.setTitle("Forgot?", for: .normal)
        button.setColorFont(color:.lightGreyBtn , font: CustomFont.PoppinsMedium.returnFont(14))
        button.addTarget(self, action: #selector(navigateToForgotPassword), for: .touchUpInside)
        let view = UIView(frame : CGRect(x: 0, y: 0, width: 80, height: 40))
        view.addSubview(button)
        textfield.rightView = view
    }

    @IBAction func logInButtonPreesed(_ sender: ThemeButton) {
        view.endEditing(true)
        if self.validation(){
            if self.getLocation(){
                self.callLoginApi()
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: ThemeButton) {
        self.push(SignUpVC.getNewInstance())
    }
    
    @objc func navigateToForgotPassword(){
        self.push(ForgotPasswordVC.getNewInstance())
    }
}

// MARK: - TextField delegate
extension LogInVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword{
            if (string == " ") {
                Utilities.showAlert(AppInfo.appName, message: "Space should not allow in current password", vc: self)
                   return false
               }
        // If consecutive spaces entered by user
         return true
            
        }
        return true
    }
}
extension LogInVC{
    func validation() -> Bool {
        var strTitle : String?
        let txtTemp = UITextField()
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmailRequired = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtEmail.placeholder?.lowercased() ?? ""))
        let checkEmail = txtTemp.validatedText(validationType: .email)
        let password = txtPassword.validatedText(validationType: .password(field: txtPassword.placeholder?.lowercased() ?? ""))
        
        if(!checkEmailRequired.0)
        {
            Toast.show(title: AppInfo.appName, message: "Please enter email", state: .failure)
            return checkEmailRequired.0
        }else if !checkEmail.0{
            strTitle = checkEmail.1
        }else if !password.0{
            strTitle = password.1
        }
        //"Entered email address or username doesn't match with the records"
        if let str = strTitle{
            Toast.show(title: UrlConstant.Required, message:str, state: .failure)
            return false
        }
        
        return true
    }
    func callLoginApi(){
        self.viewModel.loginvc = self
        
        let reqModel = LoginRequestModel()
        reqModel.userName = self.txtEmail.text ?? ""
        reqModel.password = self.txtPassword.text ?? ""
        
        self.viewModel.webserviceLogin(reqModel: reqModel)
    }
    
    func callSocialLoginApi(reqModel: SocialLoginRequestModel){
        self.viewModel.loginvc = self
        self.viewModel.webserviceSocialLogin(reqModel: reqModel)
    }
    func callAppleLoginDetails(reqModel: appleDetailReqModel){
        self.viewModel.loginvc = self
        self.viewModel.webserviceAppleLOgin(reqModel: reqModel)
    }
}
extension LogInVC: SocialSignInDelegate{
    func FetchUser(socialType: SocialType, success: Bool, user: SocialUser?, error: String?) {
        if let userObj = user{
            
            if socialType == .Apple {
                let reqModel = appleDetailReqModel()
                reqModel.apple_id = userObj.userId
                reqModel.first_name = userObj.firstName
                reqModel.last_name = userObj.lastName
                reqModel.email = userObj.email
                callAppleLoginDetails(reqModel: reqModel)
                
            } else {
                let reqModel = SocialLoginRequestModel()
                reqModel.socialId = userObj.userId
                reqModel.socialType = socialType.rawValue
                reqModel.firstName = userObj.firstName
                reqModel.lastName = userObj.lastName
                reqModel.email = userObj.email
                reqModel.userName = userObj.email
                reqModel.country_code = "+91"
                self.callSocialLoginApi(reqModel: reqModel)
            }
            
           
        }
    }
    
}
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
