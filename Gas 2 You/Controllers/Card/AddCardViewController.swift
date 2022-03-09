//
//  AddCardViewController.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 25/11/21.
//

import UIKit

protocol AddCardDelegate {
    func refreshCardListScreen()
}

class AddCardViewController: BaseVC {

    //MARK:- Variables and Properties
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var addcardmodel = addCardViewModel()
    var delegateAddcard : AddCardDelegate!
    var isCreditCardValid = Bool()
    var aryMonth = [String]() {
        didSet {
            print(aryMonth.count)
        }
    }
    var aryYear = [String]()
    var strMonth = ""
    var strYear = ""
    lazy var creditCardValidator = CreditCardValidator()
    var cardTypeLabel = String()
    var addCardClosure : (()->())?
    let expiryDatePicker = MonthYearPickerView()
    
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var btnAddCart: ThemeButton!
    @IBOutlet weak var txtZip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addcardmodel.addCard = self
        txtExpiryDate.delegate = self
        txtExpiryDate.tintColor = .clear
        txtCardNumber.delegate = self
        NavBarTitle(isOnlyTitle: false, isMenuButton: false, title: "Add card", isTitlewhite: false, controller: self)
        txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        txtCVV.delegate = self
        txtCVV.keyboardType = .numberPad
        txtCardNumber.keyboardType = .numberPad
//        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
//            let string = String(format: "%02d/%d", month, year % 100)
//            self.txtExpiryDate.text = string
////            if month < 9
//            self.strMonth = month <= 9 ? "0" + "\(month)" : "\(month)"
//            self.strYear = String(format: "%d", year % 100)
//        }
        txtExpiryDate.inputView = expiryDatePicker
        txtExpiryDate.delegate = self
        dismissPickerView()
        // Do any additional setup after loading the view.
    }
    //MARK :- Other function
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDoneButtonTappedService))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtExpiryDate.inputAccessoryView = toolBar
    }
    func clearAllTextFieldsAndSetDefaults(){
        self.txtCardNumber.text = ""
        self.txtCVV.text = ""
        self.txtCardName.text = ""
        self.txtExpiryDate.text = ""
    }
    func isValidatePaymentDetail() -> (Bool,String) {
        var isValidate:Bool = true
        var ValidatorMessage:String = ""
        let holder = txtCardName.validatedText(validationType: ValidatorType.username(field: "card holder name") )//ValidatorType.requiredField(field: "first name"))
        
        if (!holder.0) {
            isValidate = false
            ValidatorMessage = holder.1
            
        }else if (txtCardNumber.text!.isEmptyOrWhitespace()) {
            isValidate = false
            ValidatorMessage = "Please enter card number"
            
        }else if !isCreditCardValid {
            isValidate = false
            ValidatorMessage = "Your card number is invalid"
        }
        else if txtExpiryDate.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            isValidate = false
            ValidatorMessage = "Please select expiry date"
            
        } else if txtCVV.text!.isEmptyOrWhitespace() {
            isValidate = false
            ValidatorMessage = "Please enter cvv"
        }
        
        return (isValidate,ValidatorMessage)
    }
    //MARK: - Validation
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            isCreditCardValid = true
            self.cardTypeLabel = type.name.lowercased()
            print(type.name.lowercased())
                        
            //SJ_Change : If valid : text colour changed to black from red.
            
            self.txtCardNumber.textColor = .black
//            self.CvvValidation()
        } else {
            isCreditCardValid = false
            self.cardTypeLabel = "Undefined"
        }
    }
    @objc func onDoneButtonTappedService() {
        strMonth = expiryDatePicker.selectedMonth
        strYear = expiryDatePicker.selectedYear
        txtExpiryDate.text = "\(strMonth)/\(strYear)"
            self.txtExpiryDate.text = "\(strMonth)/\(strYear)"
            self.txtExpiryDate.endEditing(true)
    }
    func validateCardNumber(number: String) {
           if creditCardValidator.validate(string: number) {
               isCreditCardValid = true
           } else {
               isCreditCardValid = false
           }
       }
    func validation() -> Bool
    {
        let CardHolderName = txtCardName.validatedText(validationType: .username(field: txtCardName.placeholder?.lowercased() ?? ""))
        let CardNumber = txtCardNumber.validatedText(validationType: .requiredField(field: txtCardNumber.placeholder?.lowercased() ?? ""))
        let ExpDate = txtExpiryDate.validatedText(validationType: .requiredField(field: txtExpiryDate.placeholder?.lowercased() ?? ""))
        let Cvv = txtCVV.validatedText(validationType: .requiredField(field: txtCVV.placeholder ?? ""))
        let ZipCode = txtZip.validatedText(validationType: .requiredField(field: txtZip.placeholder ?? ""))
        if (!CardHolderName.0) {
            Toast.show(title: UrlConstant.Required, message: CardHolderName.1, state: .info)
            return CardHolderName.0
        }else if(!CardNumber.0) {
            Toast.show(title: UrlConstant.Required, message: CardNumber.1, state: .info)
            return CardNumber.0
        }
        else if (txtCardNumber.text?.count ?? 0) < 15
        {
            Toast.show(title: UrlConstant.Error, message: "Please enter valid Card number", state: .failure)
            return false
        }
        else  if(!ExpDate.0)
        {
            Toast.show(title: UrlConstant.Required, message: ExpDate.1, state: .info)
            return ExpDate.0
        }
        else if (!expDateValidation(dateStr: txtExpiryDate.text ?? ""))
        {
            Toast.show(title: UrlConstant.Error, message: "Please select valid expiry date", state: .failure)
            return false
        }
        else  if(!Cvv.0)
        {
            Toast.show(title: UrlConstant.Required, message: Cvv.1, state: .info)
            return Cvv.0
        }
        else if (txtCVV.text?.count ?? 0) < 3
        {
            Toast.show(title: UrlConstant.Error, message: "Please enter valid CVV", state: .failure)
            return false
        }
        else if (!ZipCode.0)
        {
            Toast.show(title: UrlConstant.Error, message: ZipCode.1, state: .info)
            return ZipCode.0
        }
        else if (txtZip.text?.count ?? 0) < 5
        {
            Toast.show(title: UrlConstant.Error, message: "Please enter valid ZIP Code", state: .failure)
            return false
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCVV{
            if let text = txtCVV.text, let range = Range(range, in: text) {
                let proposedText = text.replacingCharacters(in: range, with: string)
                guard proposedText.count <= 4 else {
                    return false
                }
            }
        }
        if textField == txtZip{
            if let text = txtZip.text, let range = Range(range, in: text) {
                let proposedText = text.replacingCharacters(in: range, with: string)
                guard proposedText.count <= 5 else {
                    return false
                }
            }
        }
        previousTextFieldContent = txtCardNumber.text;
        previousSelection = txtCardNumber.selectedTextRange;
            return true
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtCardName:
            txtCardNumber.becomeFirstResponder()
        case txtCardNumber:
            txtExpiryDate.becomeFirstResponder()
        case txtExpiryDate:
            txtCVV.becomeFirstResponder()
        case txtExpiryDate:
            txtZip.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func expDateValidation(dateStr:String) -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        let enterdYr = Int(dateStr.suffix(2)) ?? 0
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0
        print(dateStr)

        if enterdYr > currentYear{
            if (1 ... 12).contains(enterdMonth){
                return true
            } else{
                return false
            }
        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth{
                if (1 ... 12).contains(enterdMonth) {
                    return true
                } else{
                    return false
                }
            } else {
                return false
            }
        } else {
            return true
        }
    }
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }

        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }

        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }

        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces

        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition

        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }

        return digitsOnlyString
    }
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns

        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")

        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",

            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
        ].contains { string.hasPrefix($0) }

        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)

        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition

        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)

            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")

                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }

            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }

        return stringWithAddedSpaces
    }
    @IBAction func txtCardNumberEditingChange(_ sender: UITextField) {
        if let number = sender.text {
                  if number.isEmpty {
                      isCreditCardValid = false
                      //                   self.btnVisa.isSelected = false
                      //                   self.btnMasterCard.isSelected = false
                      //                   self.btnAmerican.isSelected = false
                      //                   self.btnJCB.isSelected = false
                      //                   self.btnDiscover.isSelected = false
                      //                   self.btnDiner.isSelected = false
                    self.txtCardNumber.textColor = UIColor.black
                  } else {
                      validateCardNumber(number: number)
                      detectCardNumberType(number: number)
                  }
              }
    }
    @IBAction func btnAddCardClick(_ sender: UIButton) {
        if (validation()){
            addcardmodel.webservieAddCard(number: txtCardNumber.text ?? "", name: txtCardName.text?.trimmedString ?? "", expDate: txtExpiryDate.text ?? "", cvv: txtCVV.text ?? "", zip: txtZip.text ?? "")
        }
    }
}
extension AddCardViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField == txtExpiryDate && txtExpiryDate.text?.count == 0 {
            let string = String(format: "%02d/%d", expiryDatePicker.month, (expiryDatePicker.year) % 100)
            self.strYear = String(format: "%d", (expiryDatePicker.year) % 100)
            self.strMonth = String(format: "%02d", expiryDatePicker.month)
            self.txtExpiryDate.text = string
        }
    }
}
public class CreditCardValidator {
    
    public lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object))
        }
        return types
        }()
    
    public init() { }
    
    /**
    Get card type from string
    
    - parameter string: card number string
    
    - returns: CreditCardValidationType structure
    */
    public func type(from string: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbers(string: string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }
    
    /**
    Validate card number
    
    - parameter string: card number string
    
    - returns: true or false
    */
    public func validate(string: String) -> Bool {
        let numbers = self.onlyNumbers(string: string)
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range: Range<String.Index> = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [.reverse, .byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = reversedString
        
        for (i, s) in reversedArray.enumerated() {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
    
    /**
    Validate card number string for type
    
    - parameter string: card number string
    - parameter type:   CreditCardValidationType structure
    
    - returns: true or false
    */
    public func validate(string: String, forType type: CreditCardValidationType) -> Bool {
        return self.type(from: string) == type
    }
    
    public func onlyNumbers(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    private static let types = [
        [
            "name": "Amex",
            "regex": "^3[47][0-9]{5,}$"
        ], [
            "name": "Visa",
            "regex": "^4\\d{0,}$"
        ], [
            "name": "MasterCard",
            "regex": "^5[1-5]\\d{0,14}$"
        ], [
            "name": "Maestro",
            "regex": "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        ], [
            "name": "Diners Club",
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        ], [
            "name": "JCB",
            "regex": "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        ], [
            "name": "Discover",
            "regex": "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        ], [
            "name": "UnionPay",
            "regex": "^62[0-5]\\d{13,16}$"
        ], [
            "name": "Mir",
            "regex": "^22[0-9]{1,14}$"
        ]
    ]
    
}

public func ==(lhs: CreditCardValidationType, rhs: CreditCardValidationType) -> Bool {
    return lhs.name == rhs.name
}

public struct CreditCardValidationType: Equatable {
    
    public var name: String
    
    public var regex: String

    public init(dict: [String: Any]) {
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let regex = dict["regex"] as? String {
            self.regex = regex
        } else {
            self.regex = ""
        }
    }
    
}
