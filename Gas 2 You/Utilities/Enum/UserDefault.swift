//
//  UserDefault.swift
//  Gas 2 You
//
//  Created by Gaurang on 03/09/21.
//

import Foundation
var userDefault = UserDefaults.standard
enum UserDefaultsKey : String {
    case userProfile = "userProfile"
    case isUserLogin = "isUserLogin"
    case X_API_KEY = "X_API_KEY"
    case DeviceToken = "DeviceToken"
    case countryList = "countryList"
    case selLanguage = "language"
    case PlaceName = "PlaceName"
    case Latitude = "Latitude"
    case longitude = "longitude"
}
