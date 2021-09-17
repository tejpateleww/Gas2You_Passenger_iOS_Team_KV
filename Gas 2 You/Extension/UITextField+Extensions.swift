//
//  UITextField+Extension.swift
//  ValidatorsMediumPost
//
//  Created by Arlind on 8/5/18.
//  Copyright © 2018 Arlind Aliu. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    
    
    func validatedText(validationType: ValidatorType) -> (Bool,String) {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return validator.validated(self.text!)
    }
    
    func AddLeftView(str : String){
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        let lbl = UILabel(frame: CGRect(x:0, y: 0, width: 20, height: 30))
        lbl.textColor = UIColor.appColor(ThemeColor.themeBlue)
        lbl.font = FontBook.regular.of(size: 28.0)
        lbl.text = str
        
        lbl.textAlignment = .center
        leftView.addSubview(lbl)
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
    func addInputViewDatePicker(target: Any, selector: Selector ,PickerMode : UIDatePicker.Mode, MinDate : Bool? = false , MaxDate : Bool? = false) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker()//UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
       
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                // Fallback on earlier versions
            }
        datePicker.minuteInterval = 30
      
        datePicker.datePickerMode = PickerMode
        if PickerMode == .date{
            if MinDate == true{
                datePicker.minimumDate = Date()
            }
            if MaxDate == true{
                datePicker.maximumDate = Date()
            }
        }
       
        
        self.inputView = datePicker
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        
        self.inputAccessoryView = toolBar
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
    }
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }

    var isEmpty: Bool {
        return (text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
    }

    func getText() -> String {
        text = (text ?? "").trimmingCharacters(in: .whitespaces)
        return text ?? ""
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
