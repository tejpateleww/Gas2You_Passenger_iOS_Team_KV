//
//  GiftCardVC.swift
//  Gas 2 You
//
//  Created by Tej P on 02/05/22.
//

import UIKit
import GrowingTextView

class GiftCardVC: BaseVC {
    
    //MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var giftCardView: UIView!
    @IBOutlet weak var imgGiftCard: UIImageView!
    
    @IBOutlet weak var Btn$50: UIButton!
    @IBOutlet weak var Btn$100: UIButton!
    @IBOutlet weak var Btn$250: UIButton!
    @IBOutlet weak var Btn$500: UIButton!
    @IBOutlet weak var Btn$1000: UIButton!
    @IBOutlet weak var Btn$2500: UIButton!
    @IBOutlet weak var txtAmount: ThemeTextfield!
    @IBOutlet weak var txtName: ThemeTextfield!
    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var lblAmount: ThemeLabel!
    @IBOutlet weak var txtMessage: GrowingTextView!
    @IBOutlet weak var btnPay: ThemeButton!
    
    private var arrBtns : [UIButton] = []
    private let ACCEPTABLE_CHARACTERS_FOR_AMOUNT = "0123456789"
    
    //MARK: - Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    //MARK: - Custom methods
    private func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    private func setupUI(){
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Gift Card", controller: self)
        self.arrBtns = [self.Btn$50,self.Btn$100,self.Btn$250,self.Btn$500,self.Btn$1000,self.Btn$2500]
        
        self.txtAmount.delegate = self
        self.txtAmount.placeholder = "Enter amount"
        self.txtAmount.placeHolderColor = (UIColor.lightGray).withAlphaComponent(0.5)
        self.txtName.delegate = self
        self.txtName.placeholder = "Enter recipient name"
        self.txtName.placeHolderColor = (UIColor.lightGray).withAlphaComponent(0.5)
        self.txtEmail.delegate = self
        self.txtEmail.placeholder = "Enter recipient email"
        self.txtEmail.placeHolderColor = (UIColor.lightGray).withAlphaComponent(0.5)
        
        self.txtMessage.trimWhiteSpaceWhenEndEditing = false
        self.txtMessage.placeholder = "Write a short message"
        self.txtMessage.placeholderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.txtMessage.minHeight = 100
        self.txtMessage.maxHeight = 150
        self.txtMessage.layer.cornerRadius = 10
        self.txtMessage.layer.borderColor = UIColor.lightGray.cgColor
        self.txtMessage.layer.borderWidth = 1
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupData(){
    }
    
    private func setupButtons(sender: UIButton) {
    }
    
    private func resetAllBtn(){
        for btn in arrBtns{
            btn.borderWidth = 1
            btn.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        }
    }
    
    private func validation() -> Bool {
        let txtTemp = UITextField()
        var strTitle : String?
        
        if(txtAmount.text == "" || txtAmount.text == "$"){
            strTitle = "Please enter valid amount"
            Toast.show(title: UrlConstant.Required, message:strTitle ?? "", state: .info)
            return false
        }
        
        let fullName = txtName.validatedText(validationType: .username(field: txtName.placeholder?.lowercased() ?? ""))
        txtTemp.text = txtEmail.text?.replacingOccurrences(of: " ", with: "")
        let checkEmailRequired = txtTemp.validatedText(validationType: ValidatorType.requiredField(field: txtEmail.placeholder?.lowercased() ?? ""))
        let checkEmail = txtTemp.validatedText(validationType: .email)
        
        if !fullName.0{
            Toast.show(title: UrlConstant.Required, message:"Please enter recipient's name", state: .info)
            return false
            
        }else if(!checkEmailRequired.0){
            Toast.show(title: UrlConstant.Required, message: "Please enter recipient's email", state: .info)
            return false
            
        }else if !checkEmail.0{
            Toast.show(title: UrlConstant.Required, message:"Please enter valid email", state: .info)
            return false
        }
        
        if(self.txtMessage.text.trimmedString == ""){
            Toast.show(title: UrlConstant.Required, message:"Please enter message", state: .info)
            return false
        }
        
        return true
    }
    
    //MARK: - Action methods
    @IBAction func selectAmount(_ sender: UIButton) {
        for btn in arrBtns{
            if(sender == btn){
                btn.borderWidth = 1
                btn.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
                btn.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
                btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                self.txtAmount.text = btn.titleLabel?.text ?? ""
                self.lblAmount.text = btn.titleLabel?.text ?? ""
                
                let Title = btn.titleLabel?.text ?? ""
                self.btnPay.setTitle((self.txtAmount.text == "") ? "PAY \(Title)" : "PAY \(Title)", for: .normal)
                
            }else{
                btn.borderWidth = 1
                btn.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                btn.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
            }
        }
    }
    
    @IBAction func btnPayAction(_ sender: Any) {
        if(validation()){
           print("Success...")
        }
    }
}


//MARK: - UITextFieldDelegate methods
extension GiftCardVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.txtAmount :
            if(!newString.contains("$")){
                self.txtAmount.text = "$"
            }
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_FOR_AMOUNT).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return (string == filtered) ? (newString.length <= MAX_AMOUNT_DIGITS) : false
        default:
            print("")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtAmount :
            self.resetAllBtn()
            self.lblAmount.text = (self.txtAmount.text == "") ? "$0" : self.txtAmount.text ?? "$0"
            let Title = (self.txtAmount.text == "") ? "$0" : self.txtAmount.text ?? "$0"
            self.btnPay.setTitle((self.txtAmount.text == "") ? "PAY \(Title)" : "PAY \(Title)", for: .normal)
        default:
            print("")
        }
    }
}

//MARK: - GrowingTextViewDelegate methods
extension GiftCardVC: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            DispatchQueue.main.async {
                self.scrollView.scrollToBottom()
            }
            self.view.layoutIfNeeded()
        }
    }
}
