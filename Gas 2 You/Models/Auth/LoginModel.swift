//
//  LoginModel.swift
//  Gas 2 You
//
//  Created by Gaurang on 03/09/21.
//
import Foundation

//MARK:- Request Model
class LoginRequestModel: Encodable{
    var userName : String?
    var password : String?
    var deviceType : String? = Singleton.sharedInstance.deviceType
    var deviceToken : String? = Singleton.sharedInstance.deviceToken
    var latitude : String? = "\(Singleton.sharedInstance.userCurrentLocation.coordinate.latitude)"
    var longitude : String? = "\(Singleton.sharedInstance.userCurrentLocation.coordinate.longitude)"

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case password = "password"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case latitude = "lat"
        case longitude = "lng"
    }
//
//    init(email: String, password: String) {
//        self.userName = email
//        self.password = password
//    }
}

// MARK: - LoginResponseModel
class LoginResponseModel: Codable {
    let status: Bool
    let message: String
    let data: ProfileModel?
}

// MARK: - DataClass
class ProfileModel: Codable {
    let id: String
    let firstName, lastName, email: String?
    let countryCode, mobileNo, walletBalance, deviceType: String?
    let deviceToken, lat, lng, qrCode: String?
    let profileImage, socialID, socialType, isSocial: String?
    let rememberToken, status, referralCode, rating: String?
    let isVerify, verifyToken, createdAt, updatedAt: String?
    let deletedAt: String?
    var xAPIKey: String?
    let is_membership_user : Bool?

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
        case is_membership_user = "is_membership_user"
    }
}
