//
//  nonMemberPlanListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 22, 2021

import Foundation

struct nonMemberPlanListResModel : Codable {

        let data : [nonMemberPlanDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([nonMemberPlanDatum].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct nonMemberPlanDatum : Codable {

        let id : String?
        let price : String?
        let title : String?
    var isSelected : Bool = false
        enum CodingKeys: String, CodingKey {
                case id = "id"
                case price = "price"
                case title = "title"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                price = try values.decodeIfPresent(String.self, forKey: .price)
                title = try values.decodeIfPresent(String.self, forKey: .title)
        }

}
