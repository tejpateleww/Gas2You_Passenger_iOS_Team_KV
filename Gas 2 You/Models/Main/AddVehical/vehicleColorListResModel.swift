//
//  vehicleColorListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 20, 2021

import Foundation

struct vehicleColorListResModel : Codable {

        let data : [VehicleColorDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([VehicleColorDatum].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct VehicleColorDatum : Codable {

        let color : String?
        let id : String?

        enum CodingKeys: String, CodingKey {
                case color = "color"
                case id = "id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                color = try values.decodeIfPresent(String.self, forKey: .color)
                id = try values.decodeIfPresent(String.self, forKey: .id)
        }

}
