//
//  cardListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2021

import Foundation

struct cardListResModel : Codable {

        let data : [cardListDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                data = try? values?.decodeIfPresent([cardListDatum].self, forKey: .data)
                message = try? values?.decodeIfPresent(String.self, forKey: .message)
                status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct cardListDatum : Codable {

        let cardImage : String?
        let cardType : String?
        let customerId : String?
        let defaultField : String?
        let displayNumber : String?
        let expiryDate : String?
        let id : String?
        let nameOnCard : String?

        enum CodingKeys: String, CodingKey {
                case cardImage = "card_image"
                case cardType = "card_type"
                case customerId = "customer_id"
                case defaultField = "default"
                case displayNumber = "display_number"
                case expiryDate = "expiry_date"
                case id = "id"
                case nameOnCard = "name_on_card"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                cardImage = try? values?.decodeIfPresent(String.self, forKey: .cardImage)
                cardType = try? values?.decodeIfPresent(String.self, forKey: .cardType)
                customerId = try? values?.decodeIfPresent(String.self, forKey: .customerId)
                defaultField = try? values?.decodeIfPresent(String.self, forKey: .defaultField)
                displayNumber = try? values?.decodeIfPresent(String.self, forKey: .displayNumber)
                expiryDate = try? values?.decodeIfPresent(String.self, forKey: .expiryDate)
                id = try? values?.decodeIfPresent(String.self, forKey: .id)
                nameOnCard = try? values?.decodeIfPresent(String.self, forKey: .nameOnCard)
        }

}
class cardListReqModel: Encodable{
    var customer_id : String?
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
    }
}
