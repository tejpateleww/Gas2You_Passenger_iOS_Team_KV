//
//  CancelOrderResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 24, 2021

import Foundation

struct CancelOrderResModel : Codable {

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
class CancelOrderReqModel: Encodable{
    var customer_id : String?
    var order_id : String?

    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case order_id = "order_id"
    }
    init(customer_id:String,order_id:String){
        self.customer_id = customer_id
        self.order_id = order_id
    }
}
