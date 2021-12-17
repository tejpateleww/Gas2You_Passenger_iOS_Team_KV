//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Singleton: NSObject{
    static let sharedInstance = Singleton()
    
    var userId = String()
    
    //Objects
    var appInitModel : InitResponseModel?
    var userProfilData : ProfileModel?
    var api_Key = String()
    var deviceType : String = "ios"
    var deviceToken : String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var userInforForNotification : [AnyHashable : Any] = [:]
    
    //MARK:- User' Custom Details
    var userCurrentLocation = CLLocation()
    var carParkingLocation = CLLocation()
  
//    func locationString() -> (latitude: String, longitude: String){
//        return (String(userCurrentLocation?.latitude ?? 0.0), String(userCurrentLocation?.longitude ?? 0.0))
//    }
    
    var arrFutureYears:[String] {
        get {
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            return (currentYear...(currentYear + 11)).map { String($0)}
        }
    }
    
    func clearSingletonClass() {
        Singleton.sharedInstance.userId = ""
        Singleton.sharedInstance.api_Key = ""
        Singleton.sharedInstance.userProfilData = nil
    }
}

