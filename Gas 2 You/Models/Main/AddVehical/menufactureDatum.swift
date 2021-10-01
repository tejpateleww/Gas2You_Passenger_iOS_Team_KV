//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 20, 2021

import Foundation

struct menufactureDatum : Codable {

        let id : String?
        let manufacturerName : String?
        let models : [Model]?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case manufacturerName = "manufacturer_name"
                case models = "models"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                manufacturerName = try values.decodeIfPresent(String.self, forKey: .manufacturerName)
                models = try values.decodeIfPresent([Model].self, forKey: .models)
        }

}
struct menufactureResModel : Codable {

        let data : [menufactureDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([menufactureDatum].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct Model : Codable {

        let id : String?
        let modelName : String?
        let vehicleManufacturerId : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case modelName = "model_name"
                case vehicleManufacturerId = "vehicle_manufacturer_id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                modelName = try values.decodeIfPresent(String.self, forKey: .modelName)
                vehicleManufacturerId = try values.decodeIfPresent(String.self, forKey: .vehicleManufacturerId)
        }

}
