//
//  DeleteCardResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2021

import Foundation

struct DeleteCardResModel : Codable {

        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
class DeleteCardReqModel: Encodable{
    var customer_id : String?
    var card_id : String?
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case card_id = "card_id"
    }
}
