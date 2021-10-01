//
//  AddVehicleResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 20, 2021

import Foundation

struct AddVehicleResModel : Codable {

        let data : AddVehicleDatum?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try AddVehicleDatum(from: decoder)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct AddVehicleDatum : Codable {

        let color : String?
        let createdAt : String?
        let customerId : String?
        let deletedAt : String?
        let id : String?
        let make : String?
        let model : String?
        let plateNumber : String?
        let updatedAt : String?
        let year : String?

        enum CodingKeys: String, CodingKey {
                case color = "color"
                case createdAt = "created_at"
                case customerId = "customer_id"
                case deletedAt = "deleted_at"
                case id = "id"
                case make = "make"
                case model = "model"
                case plateNumber = "plate_number"
                case updatedAt = "updated_at"
                case year = "year"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                color = try values.decodeIfPresent(String.self, forKey: .color)
                createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
                customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
                deletedAt = try values.decodeIfPresent(String.self, forKey: .deletedAt)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                make = try values.decodeIfPresent(String.self, forKey: .make)
                model = try values.decodeIfPresent(String.self, forKey: .model)
                plateNumber = try values.decodeIfPresent(String.self, forKey: .plateNumber)
                updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
                year = try values.decodeIfPresent(String.self, forKey: .year)
        }

}
