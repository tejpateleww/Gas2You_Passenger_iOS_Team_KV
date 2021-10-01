//
//  vehicalListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 21, 2021

import Foundation

struct vehicalListResModel : Codable {

        let data : [VehicleListDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([VehicleListDatum].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct VehicleListDatum : Codable {

        let color : String?
        let colorId : String?
        let createdAt : String?
        let customerId : String?
        let deletedAt : String?
        let id : String?
        let make : String?
        let makeId : String?
        let model : String?
        let modelId : String?
        let plateNumber : String?
        let updatedAt : String?
        let year : String?

        enum CodingKeys: String, CodingKey {
                case color = "color"
                case colorId = "color_id"
                case createdAt = "created_at"
                case customerId = "customer_id"
                case deletedAt = "deleted_at"
                case id = "id"
                case make = "make"
                case makeId = "make_id"
                case model = "model"
                case modelId = "model_id"
                case plateNumber = "plate_number"
                case updatedAt = "updated_at"
                case year = "year"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                color = try values.decodeIfPresent(String.self, forKey: .color)
                colorId = try values.decodeIfPresent(String.self, forKey: .colorId)
                createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
                customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
                deletedAt = try values.decodeIfPresent(String.self, forKey: .deletedAt)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                make = try values.decodeIfPresent(String.self, forKey: .make)
                makeId = try values.decodeIfPresent(String.self, forKey: .makeId)
                model = try values.decodeIfPresent(String.self, forKey: .model)
                modelId = try values.decodeIfPresent(String.self, forKey: .modelId)
                plateNumber = try values.decodeIfPresent(String.self, forKey: .plateNumber)
                updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
                year = try values.decodeIfPresent(String.self, forKey: .year)
        }

}
