//
//  OtpVC.swift
//  Gas 2 You Driver
//
//  Created by Tej on 02/09/21.
//

import UIKit

class OtpVC: BaseVC {

    class func getNewInstance(_ registerReqModel: RegisterRequestModel) -> OtpVC {
        let viewCotroller: OtpVC = UIStoryboard(storyboard: .auth).instantiate()
        viewCotroller.viewModel = OtpViewModel(registerRequestModel: registerReqModel)
        return viewCotroller
    }

    //MARK:- IBOutlets
    @IBOutlet weak private var txtFldOTP1: SingleDigitField!
    @IBOutlet weak private var txtFldOTP2: SingleDigitField!
    @IBOutlet weak private var txtFldOTP3: SingleDigitField!
    @IBOutlet weak private var txtFldOTP4: SingleDigitField!
    @IBOutlet weak var btnResend: ThemeButton!
    @IBOutlet weak var btnVerify: ThemeButton!
    @IBOutlet weak var lblCheckEmail: ThemeLabel!
    @IBOutlet weak var lblTimer: ThemeLabel!

    var timer = Timer()
    var counter = 30
    var arrTextFields : [UITextField] = []
    
    var viewModel: OtpViewModel!
    
    //MARK:- Life Cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.callOtpApi()
    }

    private func setupUI() {
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Forgot Password", isTitlewhite: true, controller: self)
        self.prepareView()
        self.setupBottomBorder()
    }

    //MARK:- custom methods
    func prepareView() {
        self.lblCheckEmail.text = viewModel.emailMessageString
        self.arrTextFields = [txtFldOTP1, txtFldOTP2, txtFldOTP3, txtFldOTP4]
        
        self.txtFldOTP1.isUserInteractionEnabled = true
        self.arrTextFields.forEach {
            $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
    }
    
    func setupBottomBorder() {
        self.txtFldOTP1.addBottomBorder()
        self.txtFldOTP2.addBottomBorder()
        self.txtFldOTP3.addBottomBorder()
        self.txtFldOTP4.addBottomBorder()
    }
    
    func reversetimer(){
        self.timer.invalidate() // just in case this button is tapped multiple times
        self.lblTimer.isHidden = false
        self.btnResend.isUserInteractionEnabled = false
        self.btnResend.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.5411764706, blue: 0.7803921569, alpha: 1).withAlphaComponent(0.3), for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    
    func otpToastDisplay(){
        Utilities.showAlert(UrlConstant.OTPSent, message: self.viewModel.otpStr, vc: self)
    }
    
    @objc func timerAction() {
        if self.counter > 0{
            self.counter -= 1
            self.lblTimer.text =  self.counter > 9 ? "00:\(self.counter)" : "00:0\(self.counter)"
        } else {
            self.lblTimer.isHidden = true
            self.btnResend.isUserInteractionEnabled = true
            self.btnResend.setTitleColor(#colorLiteral(red: 0.1201425865, green: 0.5393100977, blue: 0.7819268107, alpha: 1), for: .normal)
            self.timer.invalidate()
        }
    }
    
    @objc func editingChanged(_ textField: SingleDigitField) {
        if textField.pressedDelete {
            textField.pressedDelete = false
            if textField.hasText {
                textField.text = ""
            } else {
                switch textField {
                case self.txtFldOTP2, self.txtFldOTP3, self.txtFldOTP4:
                    textField.resignFirstResponder()
                    textField.isUserInteractionEnabled = false
                    switch textField {
                    case self.txtFldOTP2:
                        self.txtFldOTP1.isUserInteractionEnabled = true
                        self.txtFldOTP1.becomeFirstResponder()
                        self.txtFldOTP1.text = ""
                    case self.txtFldOTP3:
                        self.txtFldOTP2.isUserInteractionEnabled = true
                        self.txtFldOTP2.becomeFirstResponder()
                        self.txtFldOTP2.text = ""
                    case self.txtFldOTP4:
                        self.txtFldOTP3.isUserInteractionEnabled = true
                        self.txtFldOTP3.becomeFirstResponder()
                        self.txtFldOTP3.text = ""
                    default:
                        break
                    }
                default: break
                }
            }
        }
        
        guard textField.text?.count == 1, textField.text?.last?.isWholeNumber == true else {
            textField.text = ""
            return
        }
        switch textField {
        case self.txtFldOTP1, self.txtFldOTP2, self.txtFldOTP3:
            textField.resignFirstResponder()
            textField.isUserInteractionEnabled = false
            switch textField {
            case self.txtFldOTP1:
                self.txtFldOTP2.isUserInteractionEnabled = true
                self.txtFldOTP2.becomeFirstResponder()
            case self.txtFldOTP2:
                self.txtFldOTP3.isUserInteractionEnabled = true
                self.txtFldOTP3.becomeFirstResponder()
            case self.txtFldOTP3:
                self.txtFldOTP4.isUserInteractionEnabled = true
                self.txtFldOTP4.becomeFirstResponder()
            default: break
            }
        case self.txtFldOTP4:
            self.txtFldOTP4.resignFirstResponder()
        default: break
        }
    }

    private func bindViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            switch change {
            case .loaderStart:
                self.btnVerify.showLoading()
                self.view.isUserInteractionEnabled = false
            case .loaderEnd:
                self.btnVerify.hideLoading()
                self.view.isUserInteractionEnabled = true
            case .showToast(let title, let message, let state):
                Toast.show(title: title, message: message, state: state)
            case .fatalError(let message):
                Utilities.showAlertAction(UrlConstant.Failed, message: message, vc: self) {
                    self.goBack()
                }
            case .otpSent:
                self.otpToastDisplay()
                self.reversetimer()
            case .userRegstered:
                Constants.appDel.navigateToHome()
            }
        }
    }
    
    // MARK:- button action methods
    @IBAction func btnVerifyAction(_ sender: Any) {
        let strTokenCode = "\(self.txtFldOTP1.getText())\(self.txtFldOTP2.getText())\(self.txtFldOTP3.getText())\(self.txtFldOTP4.getText())"
        if strTokenCode == ""{
            Toast.show(title: UrlConstant.Required, message: "Enter OTP", state: .failure)
        }else if (self.viewModel.otpStr != strTokenCode){
            Toast.show(title: UrlConstant.Required, message: "Please enter valid OTP", state: .failure)
        }else{
            self.timer.invalidate()
            viewModel.callRegisterApi()
        }
    }
    
    @IBAction func btnResendAction(_ sender: Any) {
        self.counter = 31
        self.reversetimer()
        self.viewModel.callOtpApi()
    }
}

