//
//  Constants.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import Foundation
import UIKit


let CurrencySymbol = "$"
let arrow = " -"
let notifRefreshVehicleList = NSNotification.Name("refreshVehicleList")
let notifRefreshHomeScreen = NSNotification.Name("refreshHomeScreen")

let themeColor = hexStringToUIColor(hex: "#00AA7E")
let screenWidth = UIScreen.main.bounds.width
let NotificationBadges = NSNotification.Name(rawValue: "NotificationBadges")
class Constants {
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    static let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let appName = "Gas2You"
    static let appURL = "itms-apps://itunes.apple.com/app/id1488928328"
    static let defaultCountryCode = "+91"

    static let userDefaults = UserDefaults.standard
}
enum GlobalStrings : String{
    case Alert_logout = "Are you sure you want to logout ?"
    case EndSession_Logout = "Your account is logged in to another device"
}

typealias EmptyClosure = () -> Void

struct ScreenSize {

    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)

}

struct DeviceType {

    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }

    static let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_SE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_7 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7PLUS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

enum SystemIcon {
    case roundedCancel
    case roundedYes
    case roundedInfo

    var iconName: String {
        switch self {
        case .roundedCancel:
            return "multiply.circle"
        case .roundedYes:
            return "checkmark.circle"
        case .roundedInfo:
            return "info.circle"
        }
    }

    func getIcon(_ ofsize: CGFloat = 21.0) -> UIImage? {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: ofsize, weight: .medium, scale: .default)
            let image = UIImage(systemName: self.iconName, withConfiguration: config)
            return image
        } else {
            
            let image = UIImage(named: self.iconName)
            return image
        }
    }
}
let TEXTFIELD_MaximumLimit = 25
let TEXTFIELD_MaximumLimitPASSWORD = 15
let TEXTFIELD_MinimumLimit = 2
let MAX_PHONE_DIGITS = 10
let MAX_AMOUNT_DIGITS = 7

let TEXTFIELD_YEAR_LIMIT = 4
let TEXTFIELD_MAKE_LIMIT = 25
let TEXTFIELD_MODEL_LIMIT = 25
let TEXTFIELD_LICENSE = 15
let TEXTFIELD_OTHER_MAKE_MODEL = 25
