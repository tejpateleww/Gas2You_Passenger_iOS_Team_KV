//
//  InitResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on October 13, 2021

import Foundation

struct InitResponseModel : Codable {
    let status: Bool?
    let update: Int?
    let message: String?
    let appLinks: [InitResponseAppLink]?
    let currentDate: String?
    let isMembershipUser: Bool?
    let type: String?
    let amount: String?
    let expiryDate: String?
    var userProfilData : ProfileModel?
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case update = "update"
        case message = "message"
        case appLinks = "app_links"
        case currentDate = "current_date"
        case isMembershipUser = "is_membership_user"
        case type = "type"
        case amount = "amount"
        case expiryDate = "expiry_date"
        case userProfilData = "customer_data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        update = try values.decodeIfPresent(Int.self, forKey: .update)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        appLinks = try values.decodeIfPresent([InitResponseAppLink].self, forKey: .appLinks)
        currentDate = try values.decodeIfPresent(String.self, forKey: .currentDate)
        isMembershipUser = try values.decodeIfPresent(Bool.self, forKey: .isMembershipUser)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        expiryDate = try values.decodeIfPresent(String.self, forKey: .expiryDate)
        userProfilData = try values.decodeIfPresent(ProfileModel.self, forKey: .userProfilData)
    }
    
}

struct InitResponseAppLink : Codable {
    
    let name: String?
    let showName: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case showName = "show_name"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        showName = try values.decodeIfPresent(String.self, forKey: .showName)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}

