//
//  socialLoginReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 27/09/21.
//

import Foundation
class SocialLoginRequestModel: Encodable{
    var socialId : String?
    var socialType : String?
    var userName : String?
    var firstName : String?
    var lastName : String?
    var deviceType : String? = Singleton.sharedInstance.deviceType
    var deviceToken : String? = Singleton.sharedInstance.deviceToken
    var latitude : String? = "\(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)"
    var longitude : String? = "\(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)"
    var email : String?
    var mobileNo : String?
    var country_code : String?
    
    enum CodingKeys: String, CodingKey {
        case socialId = "social_id"
        case socialType = "social_type"
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case latitude = "lat"
        case longitude = "lng"
        case email = "email"
        case mobileNo = "mobile_no"
        case country_code = "country_code"
    }
}
class appleDetailReqModel : Encodable{
    var apple_id: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    
    enum CodingKeys : String,CodingKey {
        case apple_id = "apple_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
    }
}
