//
//  purchaseMemberPlanResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 22, 2021

import Foundation

struct purchaseMemberPlanResModel : Codable {
    
    let data : purchaseMemberDatum?
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        data = try? values?.decodeIfPresent(purchaseMemberDatum.self, forKey: .data)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}
struct purchaseMemberDatum : Codable {
    
    let amount : String?
    let expiryDate : String?
    let isMembershipUser : Bool?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case expiryDate = "expiry_date"
        case isMembershipUser = "is_membership_user"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        amount = try? values?.decodeIfPresent(String.self, forKey: .amount)
        expiryDate = try? values?.decodeIfPresent(String.self, forKey: .expiryDate)
        isMembershipUser = try? values?.decodeIfPresent(Bool.self, forKey: .isMembershipUser)
        type = try? values?.decodeIfPresent(String.self, forKey: .type)
    }
    
}
