//
//  addCardResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 26, 2021

import Foundation

struct addCardResModel : Codable {

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
class AddCardReqModel: Encodable{
    var customer_id : String?
    var name_on_card : String?
    var expiry_date: String?
    var card_number : String?
    var cvv : String?
    var zip_code : String?
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case name_on_card = "name_on_card"
        case expiry_date = "expiry_date"
        case card_number = "card_number"
        case cvv = "cvv"
        case zip_code = "zipcode"
    }
}
