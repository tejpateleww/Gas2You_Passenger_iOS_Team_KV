//
//  OtpVC.swift
//  Gas 2 You Driver
//
//  Created by Tej on 02/09/21.
//

import UIKit

class OtpVC: BaseVC,OTPTextFieldDelegate,UITextFieldDelegate {
    
    
    //MARK:- IBOutlets
    //    @IBOutlet weak private var txtFldOTP1: SingleDigitField!
    //    @IBOutlet weak private var txtFldOTP2: SingleDigitField!
    //    @IBOutlet weak private var txtFldOTP3: SingleDigitField!
    //    @IBOutlet weak private var txtFldOTP4: SingleDigitField!
    @IBOutlet var txtOtp: [SingleDigitField]!
    @IBOutlet weak var btnResend: ThemeButton!
    @IBOutlet weak var btnVerify: ThemeButton!
    @IBOutlet weak var lblCheckEmail: ThemeLabel!
    @IBOutlet weak var lblTimer: ThemeLabel!
    
    var email: String = ""
    var StringOTP = ""
    var textFieldsIndexes:[SingleDigitField:Int] = [:]
    var counter = 30
    var countOfAstric = 0
    var timer = Timer()
    var otpUserModel = SignupViewModel()
    var registerRequestModel = RegisterRequestModel()
    var emailMessageString: String {
        let components = email.components(separatedBy: "@")
//        let result = self.hideMidChars(components.first!) + "@" + components.last!
        if(components.first?.count ?? 0 <= 2){
            
        }else{
            self.email = self.hideMidChars(components.first!) + "@" + components.last!
            
            print(self.email.countInstances(of: "*"))
            self.countOfAstric = self.email.countInstances(of: "*")
            if(self.countOfAstric != 5){
                self.replaceEmail()
            }
        }
        return "Check your email address. We've sent you the code at \(email)"
        
              
    }
    //MARK:- Life Cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        email = registerRequestModel.email ?? ""
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Verify OTP", isTitlewhite: true, controller: self)
//        self.callOtpApi()
        self.lblCheckEmail.text = self.emailMessageString
        for i in txtOtp {
            i.addBottomBorder()
        }
        
        for index in 0 ..< txtOtp.count {
            textFieldsIndexes[txtOtp[index]] = index
        }
        self.txtOtp[0].delegate = self
        self.txtOtp[1].delegate = self
        self.txtOtp[2].delegate = self
        self.txtOtp[3].delegate = self
        reversetimer()
    }
    func reversetimer(){
        self.timer.invalidate() // just in case this button is tapped multiple times
        self.lblTimer.isHidden = false
        self.btnResend.isUserInteractionEnabled = false
        self.btnResend.setTitle("Resend code in", for: .normal)
        self.btnResend.setTitleColor(colors.themeBlue.value, for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    private func hideMidChars(_ value: String) -> String {
        return String(value.enumerated().map { index, char in
            return [0, 1, value.count, value.count].contains(index) ? char : "*"
        })
    }
    func replaceEmail(){
        self.countOfAstric = self.email.countInstances(of: "*")
        if(self.countOfAstric == 5){return}
        
        if(self.countOfAstric < 5){
            self.email = self.email.replaceCharacter(oldCharacter: "*", newCharacter: "**")
            self.replaceEmail()
        }else{
            self.email = self.email.replacingLastOccurrenceOfString("*", with: "")
            self.replaceEmail()
        }
    }
    
    func otpToastDisplay(){
        Utilities.showAlert(UrlConstant.OTPSent, message: self.StringOTP, vc: self)
    }
    
    @objc func timerAction() {
        if self.counter > 0{
            self.counter -= 1
            self.lblTimer.text =  self.counter > 9 ? "00:\(self.counter)" : "00:0\(self.counter)"
        } else {
            self.lblTimer.isHidden = true
            self.btnResend.isUserInteractionEnabled = true
            self.btnResend.setTitle("Resend code", for: .normal)
            self.btnResend.setTitleColor(colors.themeBlue.value, for: .normal)
            self.timer.invalidate()
        }
    }
    func setNextResponder(_ index:Int?, direction: Direction) {
        guard let index = index else { return }
        
        if direction == .left {
            index == 0 ?
            (_ = self.txtOtp.first?.resignFirstResponder()) :
            (_ = self.txtOtp[(index - 1)].becomeFirstResponder())
            if index > 0 {
                let neIndex = index + 1
                for i in neIndex..<self.txtOtp.count {
                    self.txtOtp[i].text = ""
                }
            }
        } else {
            index == self.txtOtp.count - 1 ?
            (_ = self.txtOtp.last?.resignFirstResponder()) :
            (_ = self.txtOtp[(index + 1)].becomeFirstResponder())
        }
    }
    
    func setNextResponderBlank(_ index:Int?) {
        if index! >= 0 {
            let neIndex = index! + 1
            for i in neIndex..<self.txtOtp.count {
                self.txtOtp[i].text = ""
                
            }
        }
    }
    func clearAllFields() {
        for index in 0 ..< txtOtp.count {
            txtOtp[index].text = ""
        }
    }
    // MARK:- button action methods
    @IBAction func btnVerifyAction(_ sender: Any) {
        let strTokenCode = "\(self.txtOtp[0].text ?? "" )\(self.txtOtp[1].text ?? "" )\(self.txtOtp[2].text ?? "" )\(self.txtOtp[3].text ?? "")"
        if strTokenCode == ""{
            Toast.show(title: UrlConstant.Required, message: "Please enter OTP.", state: .info)
        }else if(self.StringOTP != strTokenCode){
//            Utilities.ShowAlertOfrequired(OfMessage:"Please enter valid OTP.")
            Toast.show(title: UrlConstant.Required, message: "Please enter valid OTP.", state: .info)
        }else{
            self.timer.invalidate()
            otpUserModel.callRegisterApi(reqModel: registerRequestModel)
        }
    }
    
    @IBAction func btnResendAction(_ sender: Any) {
        txtOtp.forEach { (textfield) in
            textfield.text = ""
        }
        self.counter = 31
        self.reversetimer()
        self.callOtpApi()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {
            self.setNextResponder(textFieldsIndexes[textField as! SingleDigitField], direction: .right)
            textField.text = string
            return true
        } else if range.length == 1 {
            self.setNextResponder(textFieldsIndexes[textField as! SingleDigitField], direction: .left)
            textField.text = ""
            return false
        }
        return false
    }
    
    func textFieldDidDelete(currentTextField: SingleDigitField) {
        self.setNextResponder(textFieldsIndexes[currentTextField], direction: .left)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        self.setNextResponderBlank(textFieldsIndexes[textField as! SingleDigitField])
    }
    
}
extension OtpVC{
    
    func callOtpApi(){
        self.otpUserModel.signupvc = self
        self.otpUserModel.registerRequestModel = self.registerRequestModel
        let otpReqModel = OTPRequestModel()
        otpReqModel.email = self.registerRequestModel.email ?? ""
        self.otpUserModel.webserviceOtp(reqModel: otpReqModel)
    }
}
