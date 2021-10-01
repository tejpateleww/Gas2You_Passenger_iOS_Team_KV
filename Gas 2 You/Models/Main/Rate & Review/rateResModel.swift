//
//  rateResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 28, 2021

import Foundation

struct rateResModel : Codable {

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
class rateReqModel : Encodable{
    var order_id : String?
    var rate : String?
    var review : String?
    
    enum CodingKeys: String, CodingKey {
        case order_id = "order_id"
        case rate = "rate"
        case review = "review"
    }
    init(order_id:String,rate:String,review:String){
        self.order_id = order_id
        self.rate = rate
        self.review = review
    }
}
