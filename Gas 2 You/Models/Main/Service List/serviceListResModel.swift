//
//  serviceListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 22, 2021

import Foundation

struct serviceListResModel : Codable {
    
    let data : [ServiceListDatum]?
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ServiceListDatum].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}
struct ServiceListDatum : Codable {
    
    let id : String?
    let name : String?
    let price : String?
    let subServices : [SubService]?
    var SubCount: Int
    var isSelected : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case subServices = "sub_services"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        subServices = try values.decodeIfPresent([SubService].self, forKey: .subServices)
        
        SubCount = subServices?.count ?? 0
    }
    
}
struct SubService : Codable {
    
    let id : String?
    let name : String?
    let price : String?
    let typeId : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case typeId = "type_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        typeId = try values.decodeIfPresent(String.self, forKey: .typeId)
    }
    
}
