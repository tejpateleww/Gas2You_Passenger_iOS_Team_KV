// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cancelMemberPlanResModel = try? newJSONDecoder().decode(CancelMemberPlanResModel.self, from: jsonData)

import Foundation

// MARK: - CancelMemberPlanResModel
class CancelMemberPlanResModel: Codable {
    let status: Bool
    let message: String
    let data: DataClass

    init(status: Bool, message: String, data: DataClass) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class DataClass: Codable {
    let id, firstName, lastName, email: String
    let countryCode, mobileNo, walletBalance, deviceType: String
    let deviceToken, lat, lng, qrCode: String
    let profileImage, socialID, socialType, isSocial: String
    let rememberToken, status, referralCode, rating: String
    let isVerify, verifyToken, notification, createdAt: String
    let updatedAt, deletedAt, xAPIKey: String
    let isMembershipUser: Bool
    let type, amount, expiryDate: String

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
        case notification
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case xAPIKey = "x-api-key"
        case isMembershipUser = "is_membership_user"
        case type, amount
        case expiryDate = "expiry_date"
    }

    init(id: String, firstName: String, lastName: String, email: String, countryCode: String, mobileNo: String, walletBalance: String, deviceType: String, deviceToken: String, lat: String, lng: String, qrCode: String, profileImage: String, socialID: String, socialType: String, isSocial: String, rememberToken: String, status: String, referralCode: String, rating: String, isVerify: String, verifyToken: String, notification: String, createdAt: String, updatedAt: String, deletedAt: String, xAPIKey: String, isMembershipUser: Bool, type: String, amount: String, expiryDate: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.countryCode = countryCode
        self.mobileNo = mobileNo
        self.walletBalance = walletBalance
        self.deviceType = deviceType
        self.deviceToken = deviceToken
        self.lat = lat
        self.lng = lng
        self.qrCode = qrCode
        self.profileImage = profileImage
        self.socialID = socialID
        self.socialType = socialType
        self.isSocial = isSocial
        self.rememberToken = rememberToken
        self.status = status
        self.referralCode = referralCode
        self.rating = rating
        self.isVerify = isVerify
        self.verifyToken = verifyToken
        self.notification = notification
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.xAPIKey = xAPIKey
        self.isMembershipUser = isMembershipUser
        self.type = type
        self.amount = amount
        self.expiryDate = expiryDate
    }
}

