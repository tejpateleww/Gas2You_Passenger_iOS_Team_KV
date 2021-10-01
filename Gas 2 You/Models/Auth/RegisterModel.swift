//
//  RegisterModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 06/09/21.
//

import Foundation

//MARK:- OTP Request Model
class OTPRequestModel : Encodable{
    var email: String?
    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
}

//MARK:- OTP Response Model
class OTPResponseModel: Codable {
    var status: Bool?
    var otp: Int?
    var message: String?

    init(status: Bool?, otp: Int?, message: String?) {
        self.status = status
        self.otp = otp
        self.message = message
    }

    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
        otp = try? values?.decodeIfPresent(Int.self, forKey: .otp)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
    }
}

//MARK:- Register Request Model
class RegisterRequestModel: Encodable{
    var firstName : String?
    var lastName: String?
    var email : String?
    var password : String?
    var phone : String?
    var countryCode : String? = Constants.defaultCountryCode
    var deviceType : String? = Singleton.sharedInstance.deviceType
    var deviceToken : String? = Singleton.sharedInstance.deviceToken
    var latitude : String? = "\(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)"
    var longitude : String? = "\(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)"

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName  = "last_name"
        case email
        case password
        case phone = "mobile_no"
        case latitude = "lat"
        case longitude = "lng"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case countryCode = "country_code"
    }

    init(values: SignupViewModel.SignupValues) {
        self.firstName = values.firstName
        self.lastName = values.lastName
        self.email = values.email
        self.password = values.password
        self.phone = values.mobile
    }
}

// MARK: - RegisterResponseModel
class RegisterResponseModel: Codable {
    let status: Bool?
    let message: String?
    let data: RegisterModel?
}

// MARK: - RegisterModel
class RegisterModel: Codable {
    let id, firstName, lastName, email: String?
    let countryCode, mobileNo, walletBalance, deviceType: String?
    let deviceToken, lat, lng, qrCode: String?
    let profileImage, socialID, socialType, isSocial: String?
    let rememberToken, status, referralCode, rating: String?
    let isVerify, verifyToken, createdAt, updatedAt: String?
    let deletedAt, xAPIKey: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case countryCode = "country_code"
        case mobileNo = "mobile_no"
        case walletBalance = "wallet_balance"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case lat, lng
        case qrCode = "qr_code"
        case profileImage = "profile_image"
        case socialID = "social_id"
        case socialType = "social_type"
        case isSocial = "is_social"
        case rememberToken = "remember_token"
        case status
        case referralCode = "referral_code"
        case rating
        case isVerify = "is_verify"
        case verifyToken = "verify_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case xAPIKey = "x-api-key"
    }
}
