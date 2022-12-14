//
//  Themes.swift
//  Gas 2 You
//
//  Created by MacMini on 29/07/21.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import MKProgress

//==========================
//MARK:- === Label ===
//==========================

class ThemeLabel: UILabel{
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue+5
    @IBInspectable public var isBold: Bool = false
    @IBInspectable public var isSemibold: Bool = false
    @IBInspectable public var isLight: Bool = false
    @IBInspectable public var isMedium: Bool = false
    @IBInspectable public var fontColor: UIColor = .black
    @IBInspectable public var isThemeColour : Bool = false
    @IBInspectable public var is50Oppacity : Bool = false
    @IBInspectable public var is8ppacity : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

            if isBold {
                if UIDevice.current.userInterfaceIdiom == .phone{
                    self.font = CustomFont.PoppinsBold.returnFont(Font_Size)
                }else if UIDevice.current.userInterfaceIdiom == .pad{
                    self.font = CustomFont.PoppinsBold.returnFont(Font_Size + 4)
                }
            } else if isSemibold {
                if UIDevice.current.userInterfaceIdiom == .phone{
                    self.font = CustomFont.PoppinsSemiBold.returnFont(Font_Size)
                }else if UIDevice.current.userInterfaceIdiom == .pad{
                    self.font = CustomFont.PoppinsSemiBold.returnFont(Font_Size + 4)
                }
            } else if isMedium {
                if UIDevice.current.userInterfaceIdiom == .phone{
                    self.font = CustomFont.PoppinsMedium.returnFont(Font_Size)
                }else if UIDevice.current.userInterfaceIdiom == .pad{
                    self.font = CustomFont.PoppinsMedium.returnFont(Font_Size + 4)
                }
            } else if isLight {
                if UIDevice.current.userInterfaceIdiom == .phone{
                    self.font = CustomFont.PoppinsLight.returnFont(Font_Size)
                }else if UIDevice.current.userInterfaceIdiom == .pad{
                    self.font = CustomFont.PoppinsLight.returnFont(Font_Size + 4)
                }
            } else {
                if UIDevice.current.userInterfaceIdiom == .phone{
                    self.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
                }else if UIDevice.current.userInterfaceIdiom == .pad{
                    self.font = CustomFont.PoppinsRegular.returnFont(Font_Size + 4)
                }
            }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if is50Oppacity == true {
            self.textColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        }
        else if is8ppacity == true {
            self.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.13)
        }
        else {
            self.textColor = isThemeColour == true ? UIColor.appColor(ThemeColor.themeBlue) : fontColor
        }
    }
}


//==========================
//MARK: ====== Button ======
//==========================


class ThemeButton: UIButton {
    
    @IBInspectable public var Font_Size: CGFloat = FontSize.size19.rawValue
    @IBInspectable public var isbordered: Bool = false
    @IBInspectable public var isBold: Bool = false
    @IBInspectable public var isSemibold: Bool = false
    @IBInspectable public var isLight: Bool = false
    @IBInspectable public var isMedium: Bool = false
    @IBInspectable public var isRegular: Bool = false
    @IBInspectable public var background : UIColor = UIColor.clear
    @IBInspectable public var fontColor: UIColor = UIColor.appColor(ThemeColor.themeButtonBlue)
    @IBInspectable public var shadowColor: UIColor = UIColor.lightGray
    @IBInspectable public var radius: CGFloat = 0.0
    @IBInspectable public var shadow: Bool = false

    var activityIndicator: UIActivityIndicatorView!
    private var originalButtonText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.font = FontBook.semibold.staticFont(size: Font_Size)
        self.backgroundColor = background
        self.tintColor = fontColor
        self.layer.cornerRadius = radius
        
        if isBold {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.titleLabel?.font = CustomFont.PoppinsBold.returnFont(Font_Size)
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.titleLabel?.font = CustomFont.PoppinsBold.returnFont(Font_Size + 4)
            }
        } else if isSemibold {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(Font_Size)
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(Font_Size + 4)
            }
        } else if isMedium {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(Font_Size)
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(Font_Size + 4)
            }
        } else if isLight {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.titleLabel?.font = CustomFont.PoppinsLight.returnFont(Font_Size)
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.titleLabel?.font = CustomFont.PoppinsLight.returnFont(Font_Size + 4)
            }
        } else if isRegular {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(Font_Size + 4)
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(Font_Size + 4)
            }
        }
        
        if isbordered {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.setunderline(title: self.titleLabel?.text ?? "", color: UIColor.appColor(ThemeColor.themeButtonBlue), font: CustomFont.PoppinsRegular.returnFont(Font_Size))
            }else if UIDevice.current.userInterfaceIdiom == .pad{
                self.setunderline(title: self.titleLabel?.text ?? "", color: UIColor.appColor(ThemeColor.themeButtonBlue), font: CustomFont.PoppinsRegular.returnFont(Font_Size + 4))
            }
        }
        if shadow {
            addShadow(view: self, shadowColor: shadowColor)
        }
        
    }

    func showLoading() {
        isEnabled = false
        originalButtonText = self.titleLabel?.text

        self.setTitle("", for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        isEnabled = true
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = self.background
            }
        }
    }
    
}

class ThemeCompleteButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
            self.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.23), for: .normal)
            self.backgroundColor = .clear
            self.titleLabel?.font  =  FontBook.regular.of(size: 14.0)
            self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.23).cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 10
    }
}

class ThemeRoundBtn : UIButton {
    
    @IBInspectable var isRed : Bool = false
    @IBInspectable var isCornerRound : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = isCornerRound == true ? 8 : self.frame.height / 2
        self.clipsToBounds = true
        self.backgroundColor = isRed == true ? UIColor(hexString: "C94B4B") : .white
        
    }
}

class ThemeCustomShadowButton : UIControl {
    @IBInspectable public var front_image: UIImage = UIImage(named: "s") ?? UIImage()
    @IBInspectable public var Font_Size: CGFloat = FontSize.size19.rawValue
    @IBInspectable public var fontColor: UIColor = UIColor.appColor(.themeBlue)
    @IBInspectable public var Title: String = ""
    @IBInspectable public var isYellowBG : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSoftUIEffectForView(yellowBG: isYellowBG)
        
        let imageView = UIImageView(image: front_image)
//        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width - 10, height: self.frame.height - 10)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: imageView.frame.width - 10, height: imageView.frame.height - 10))
        label.text = Title
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        if UIDevice.current.userInterfaceIdiom == .phone{
            label.font = FontBook.regular.of(size: Font_Size)
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            label.font = FontBook.regular.of(size: Font_Size + 4)
        }
        label.textColor = fontColor
        imageView.addSubview(label)
        
        if isYellowBG {
            label.textColor = .black
        }
    }
}

class ThemeGrayButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.backgroundColor =  UIColor(hexString: "414141")
        self.titleLabel?.font  = FontBook.regular.of(size: 13.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        
        
    }
}

class CustomShadowButton: UIButton {

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!

        backgroundColor =  UIColor(hexString: "#707070")
        
    }

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }

    func updateLayerProperties() {
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.height / 2

        //superview is your optional embedding UIView
        if let superview = superview {
            superview.backgroundColor = UIColor.clear
            superview.layer.shadowColor = UIColor.darkGray.cgColor
            superview.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath
            superview.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            superview.layer.shadowOpacity = 0.5
            superview.layer.shadowRadius = 2
            superview.layer.masksToBounds = true
            superview.clipsToBounds = false
        }
    }

}


class ThemeGradientButton: UIButton {

 
    public let buttongradient: CAGradientLayer = CAGradientLayer()

    override var isSelected: Bool {  // or isHighlighted?
        didSet {
            updateGradientColors()
        }
    }

    func updateGradientColors() {
        let colors: [UIColor]

        
        self.titleLabel?.font = FontBook.regular.of(size:13.0)
        self.setTitleColor(UIColor.white, for: .normal)
        colors = [UIColor(hexString: "2F2F2F") , UIColor(hexString: "414141")]
        
        buttongradient.colors = colors.map { $0.cgColor }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
    }

    func setupGradient() {
        buttongradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        buttongradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.insertSublayer(buttongradient, at: 0)

        updateGradientColors()
    }

    func updateGradient() {
        buttongradient.frame = self.bounds
       
    }
}



//==========================
//MARK: === Textfield ===
//==========================

protocol textFieldDelegate {
    func didTapRightButton()
}

class ThemeTextfield : UITextField {
    
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
    @IBInspectable public var Border_Width: CGFloat = 1.0
    @IBInspectable public var Border_Color: UIColor = .clear
    @IBInspectable public var Corner_Radius: CGFloat = 1
    
    @IBInspectable var rightButton: String? {
        didSet {
            if let titleText = rightButton {
                rightViewMode = .always
                let button = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 40))
                button.setTitle(titleText, for: .normal)
                if UIDevice.current.userInterfaceIdiom == .phone{
                    button.setColorFont(color: .gray , font: FontBook.regular.staticFont(size: Font_Size - 2))
                }else{
                    button.setColorFont(color: .gray , font: FontBook.regular.staticFont(size: Font_Size))
                }
                button.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 80, height: 40))
                view.addSubview(button)
                rightView = view
            } else {
                rightViewMode = .never
            }
        }
    }

    @objc func rightBtnAction() {
//        print("forgot pressed")
//        let loginStory = UIStoryboard(name: "Login", bundle: nil)
//        let loginVC = LogInVC()
//        let forgotPassVC = loginStory.instantiateViewController(identifier: ForgotPasswordVC.className) as! ForgotPasswordVC
//        loginVC.navigationController?.pushViewController(forgotPassVC, animated: true)
        
    }
    
    @IBInspectable var LeftImage: UIImage? {
        didSet {
            if let image = LeftImage {
              //  SetLeftImage(image: image)
                leftViewMode = .always
                let button = UIButton(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
                //let imageView = UIImageView(frame: )
                button.setImage(image, for: .normal)

                button.contentMode = .scaleAspectFit
                button.tintColor = tintColor
                button.isUserInteractionEnabled = false
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 40, height: 20))
                view.isUserInteractionEnabled = false
                view.addSubview(button)
                leftView = view
            }else{
                leftViewMode = .never
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .phone{
            self.font = FontBook.regular.of(size : Font_Size)
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            self.font = FontBook.regular.of(size : Font_Size + 4)
        }
        self.layer.borderWidth = Border_Width
        self.layer.borderColor = Border_Color.cgColor
        self.layer.cornerRadius = Corner_Radius
        
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.tag == 101{
            if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return false
            }
            // Default
            return super.canPerformAction(action, withSender: sender)
        }
        return true
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }
}

protocol OTPTextFieldDelegate   {
    func textFieldDidDelete(currentTextField: SingleDigitField)
}
class SingleDigitField: UITextField {
    
    var myDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(currentTextField: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        keyboardType = .numberPad
        textAlignment = .center
        backgroundColor = .clear
        isSecureTextEntry = false
        clipsToBounds = true
        if UIDevice.current.userInterfaceIdiom == .phone{
            font = CustomFont.medium.returnFont(17)
        }else{
            font = CustomFont.medium.returnFont(22)
        }
        tintColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    }
}



class ThemeSearchBar: UITextField {

    

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 25);

    

    override func textRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: padding)

    }

    

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: padding)

    }

    

    override func editingRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: padding)

    }

}

class ThemeView : UIView {
    
    @IBInspectable public var isShadow: Bool = false
    @IBInspectable public var cornerRadius: CGFloat = 0.0
    @IBInspectable public var shadowColor: UIColor = UIColor.lightGray
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            addShadow(view: self, shadowColor: shadowColor)
        }
        
    }
    
}

//MARK:- custom chat screen view
class RatingTextview : IQTextView{
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.init(hexString: "#E4E9F2").cgColor
//        self.layer.cornerRadius = 5
//        self.clipsToBounds = true
        self.textContainerInset = UIEdgeInsets(top: 13, left: 5, bottom: 13, right: 13)
    }
}


class WriteTextView: UIView {
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 0.3)
        self.layer.cornerRadius = 9
        self.clipsToBounds = true
    }
    
}


//MARK:- custom chat screen view

class ChatScreenView : UIView {
    
    @IBInspectable var isSenderView : Bool = false
    @IBInspectable var isReciverView : Bool = false
    
    override func awakeFromNib() {
     //   self.roundCorners(corners: [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 12)
//        if isSenderView {
//            self.backgroundColor = UIColor(hexString: "#00AA7E")
//        } else if isReciverView {
//            self.backgroundColor = UIColor(hexString: "#DEE2EA")
//        }
    }
    
    override func layoutSubviews() {
    super.layoutSubviews()
        if isSenderView {
            self.backgroundColor = #colorLiteral(red: 0.2145549953, green: 0.2144483924, blue: 0.2096654773, alpha: 1)
            let bounds: CGRect = self.bounds
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: ([ .topLeft, .topRight, .bottomLeft]), cornerRadii: CGSize(width: 18, height: 0.0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        } else if isReciverView {
            self.backgroundColor = UIColor(hexString: ThemeColor.themeBlue.rawValue)
            let bounds: CGRect = self.bounds
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: ([.topLeft, .bottomRight, .topRight]), cornerRadii: CGSize(width: 18.0, height: 0.0))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
        
    }
}

//MARK:- custom chat scrren label

class ChatScreenLabel : UILabel {
    @IBInspectable var lblSender : Bool = false
    @IBInspectable var lblReciver : Bool = false
    @IBInspectable var lblHeader : Bool = false
    
    override func awakeFromNib() {
        self.numberOfLines = 0
        if lblSender {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.font = CustomFont.PoppinsMedium.returnFont(12)
            }else{
                self.font = CustomFont.PoppinsMedium.returnFont(17)
            }
            self.textColor = UIColor.white
            self.textAlignment = .right
        } else if lblReciver {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.font = CustomFont.PoppinsMedium.returnFont(12)
            }else{
                self.font = CustomFont.PoppinsMedium.returnFont(17)
            }
            self.textColor = UIColor.white
            self.textAlignment = .left
        } else if lblHeader {
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.font = CustomFont.PoppinsMedium.returnFont(9)
            }else{
                self.font = CustomFont.PoppinsMedium.returnFont(14)
            }
            self.textColor = UIColor(hexString: "#ACB1C0")
            self.textAlignment = .center
        }
    }
}
