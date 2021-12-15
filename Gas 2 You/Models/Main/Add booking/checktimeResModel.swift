//
//  checktimeResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2021

import Foundation

struct checktimeResModel : Codable {

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
class CheckTimeReqModel: Encodable{
    var customerid : String? = Singleton.sharedInstance.userId
    var booking_time : String?
    var booking_date : String?
    var vehicle_id : String?
    
    enum CodingKeys: String, CodingKey {
        case booking_time = "booking_time"
        case booking_date = "booking_date"
        case vehicle_id = "vehicle_id"
        case customerid = "user_id"
    }
}
