//
//  membershipplanResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 28, 2021

import Foundation

struct membershipplanResModel : Codable {
    
    let data : [memberPlanListDatum]?
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        data = try? values?.decodeIfPresent([memberPlanListDatum].self, forKey: .data)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}
class memberPlanListDatum : Codable {
    
    let descriptionField : String?
    let id : String?
    var isPurchased : Bool?
    let planName : String?
    let price : String?
    let type : String?
    var isSelected : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case id = "id"
        case isPurchased = "is_purchased"
        case planName = "plan_name"
        case price = "price"
        case type = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        descriptionField = try? values?.decodeIfPresent(String.self, forKey: .descriptionField)
        id = try? values?.decodeIfPresent(String.self, forKey: .id)
        isPurchased = try? values?.decodeIfPresent(Bool.self, forKey: .isPurchased)
        planName = try? values?.decodeIfPresent(String.self, forKey: .planName)
        price = try? values?.decodeIfPresent(String.self, forKey: .price)
        type = try? values?.decodeIfPresent(String.self, forKey: .type)
    }
    
}
class memberListReqModel: Encodable{
    var customer_id : String?
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
    }
}
class purchaseMemberReqModel:Encodable{
    var customer_id : String?
    var plan_id : String?
    var card_id : String?
    enum codingkeys : String,CodingKey {
        case customer_id = "customer_id"
        case plan_id = "plan_id"
        case card_id = "card_id"
    }
}
class cancelMemberPlanReqModel : Encodable{
    var customer_id : String?
    enum codingkeys : String,CodingKey {
        case customer_id = "customer_id"
    }
}
