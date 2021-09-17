//
//  Constants.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import Foundation
import UIKit

class Constants {
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    static let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    static let appName = "Gas2You"
    static let appURL = "itms-apps://itunes.apple.com/app/id1488928328"
    static let defaultCountryCode = "+91"

    static let userDefaults = UserDefaults.standard
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

    func getIcon(of size: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(
            pointSize: size, weight: .medium, scale: .default)
        let image = UIImage(systemName: self.iconName, withConfiguration: config)
        return image
    }
}
