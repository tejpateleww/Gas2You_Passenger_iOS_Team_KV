//
//  String+extension.swift
//  Gas 2 You
//
//  Created by MacMini on 29/07/21.
//

import Foundation
import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font ?? .systemFont(ofSize: 15), range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

extension NSAttributedString {
    func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {


        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}



extension String{
    //    func currencyInputFormatting() -> String {
    //
    //        var number: NSNumber!
    //               let formatter = NumberFormatter()
    //               formatter.numberStyle = .currencyAccounting
    //               formatter.currencySymbol = currency
    //               formatter.maximumFractionDigits = 2
    //               formatter.minimumFractionDigits = 2
    //
    //               var amountWithPrefix = self
    //
    //               // remove from String: "$", ".", ","
    //               let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    //               amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    //
    //               let double = (amountWithPrefix as NSString).doubleValue
    //               number = NSNumber(value: (double / 100))
    //
    //               // if first number is 0 or all numbers were deleted
    //               guard number != 0 as NSNumber else {
    //                   return ""
    //               }
    //
    //               return formatter.string(from: number)!
    //    }
    

    
    // hexStringToUIColor(hex: "#7F7F7F")
    func withsttributedText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: FontBook.regular.of(size:FontSize.size15.rawValue)]
        let range = (self as NSString).range(of: text)
        //fullString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range:range)

        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).localizedUppercase + lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}

//extension NSMutableAttributedString {
//
//    func setColorForStr(textToFind: String, color: UIColor) {
//
//        let range = self.mutableString.range(of: textToFind, options:NSString.CompareOptions.caseInsensitive);
//        if range.location != NSNotFound {
//            self.addAttribute(NSForegroundColorAttributeName, value: color, range: range);
//        }
//
//    }
//}
//extension UIColor {
//    convenience init(hexString: String) {
//           let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//           var int = UInt64()
//           Scanner(string: hex).scanHexInt64(&int)
//           let a, r, g, b: UInt64
//           switch hex.count {
//           case 3: // RGB (12-bit)
//               (a, r, g, b) = (255, (int >> 8)  17, (int >> 4 & 0xF)  17, (int & 0xF) * 17)
//           case 6: // RGB (24-bit)
//               (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//           case 8: // ARGB (32-bit)
//               (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//           default:
//               (a, r, g, b) = (255, 0, 0, 0)
//           }
//           self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
//       }
//}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


// underline label extension

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

extension String{

    var trimmedString: String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }

    var length: Int { return self.trimmedString.count}

    //MARK: - ================================
    //MARK: URL Encoding
    //MARK: ==================================
    func urlencoding() -> String {
        var output: String = ""

        for thisChar in self {
            if thisChar == " " {
                output += "+"
            }
            else if thisChar == "." ||
                        thisChar == "-" ||
                        thisChar == "_" ||
                        thisChar == "~" ||
                        (thisChar >= "a" && thisChar <= "z") ||
                        (thisChar >= "A" && thisChar <= "Z") ||
                        (thisChar >= "0" && thisChar <= "9") {
                let code = String(thisChar).utf8.map{ UInt8($0) }[0]
                output += String(format: "%c", code)
            }
            else {
                let code = String(thisChar).utf8.map{ UInt8($0) }[0]
                output += String(format: "%%%02X", code)
            }
        }
        return output;
    }

    //MARK: - ================================
    //MARK: Contains Alphabets
    //MARK: ==================================
    func containsAlphabets() -> Bool {
        var iscontain : Bool = false
        let characterSet = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyz")
        if self.count > 1 {
            for character in self.lowercased() {
                let string = String.init(character)
                if string.rangeOfCharacter(from: characterSet) != nil {
                    iscontain = true
                    break
                }
            }
        }
        else {
            if self.rangeOfCharacter(from: characterSet) != nil {
                iscontain = true
            }
            else {
                iscontain = false
            }
        }
        return iscontain
    }

    //MARK: - ================================
    //MARK: Contains Numbers
    //MARK: ==================================
    func containsNumbers() -> Bool {
        var iscontain : Bool = false
        let characterSet = CharacterSet(charactersIn:"0123456789")
        if self.count > 1 {
            for character in self {
                let string = String.init(character)
                if string.rangeOfCharacter(from: characterSet) != nil {
                    iscontain = true
                    break
                }
            }
        }
        else {
            if self.rangeOfCharacter(from: characterSet) != nil {
                iscontain = true
            }
            else {
                iscontain = false
            }
        }
        return iscontain
    }

    //MARK: - ================================
    //MARK: Convert String to Dictionary
    //MARK: ==================================
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                Utilities.printOutput(error.localizedDescription)
            }
        }
        return nil
    }

    //MARK: - ================================
    //MARK: Check if string is Image
    //MARK: ==================================
    public func isImageFromString() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg",
                            "png",
                            "gif",
                            "webp",
                            "svg",
                            "ai",
                            "eps",
                            "bmp",
                            "psd",
                            "thm",
                            "pspimage",
                            "tif",
                            "yuv",
                            "drw",
                            "Eps",
                            "ps",
                            "pcd"]

        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }
        return false
    }

    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        if ext.isEmpty {
            return nil
        }
        return ext
    }

    //MARK: - ================================
    //MARK: Replace a Pertucular character
    //MARK: ==================================
    public func replaceCharacter(oldCharacter:String, newCharacter:String)->String{
        return self.replacingOccurrences(of: oldCharacter, with: newCharacter, options: .literal, range: nil)
    }

    //MARK: - ================================
    //MARK: Convert to HTML Text
    //MARK: ==================================
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }

    //MARK: - ================================
    //MARK: Get Currency Symbol
    //MARK: ==================================
    func getSymbolForCurrencyCode() -> String? {
        var cod = self
        if cod == ""{
            if Locale.current.currencyCode != nil{
                cod = Locale.current.currencyCode!
            } else{
                cod = "USD"
            }
        }
        let upperCode = cod.uppercased()
        let symbol = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == upperCode }
        let sym = "\((symbol?.currencySymbol?.last)!)"
        return sym
    }

    //MARK: - ================================
    //MARK: Strike Through Words
    //MARK: ==================================
    func strikeThrough(color: UIColor)->NSAttributedString{
        let textRange = NSMakeRange(0, self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: color, range: textRange)
        return attributedText
    }

    func strikeThrough(color: UIColor, forString:String)->NSAttributedString{
        let textRange = (self as NSString).range(of: forString)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: color, range: textRange)
        return attributedText
    }


    //MARK: - ================================
    //MARK: Remove HTML Tags from string
    //MARK: ==================================
    func removeHTMLTags()->String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }

    //MARK: - ================================
    //MARK: Convert to Double
    //MARK: ==================================
    func toDouble() -> Double {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return 0.0
        }
    }
    //MARK: - ================================
    //MARK: Convert to Intger
    //MARK: ==================================
    func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }

    //MARK: - ================================
    //MARK: For Coupon codes with spacing
    //MARK: ==================================
    func getAttributedStringWithKern() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 4, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }

    //MARK: - ================================
    //MARK: For localized string
    //MARK: ==================================
    func Localized() -> String {
        guard let lang = Constants.userDefaults.value(forKey: UserDefaultsKey.selLanguage.rawValue) as? String else { return "" }
        let path = Bundle.main.path(forResource: lang , ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }

    func heightForView(font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()

        return label.frame.height
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func isEmpty() -> Bool {
        return self.trimming().isEmpty
    }

    func trimming() -> String {
        let strText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strText
    }

    func validatedText(validationType: ValidatorType) -> (Bool,String) {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return validator.validated(self)
    }
}
