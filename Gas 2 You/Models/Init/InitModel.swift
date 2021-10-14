//
//  InitResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on October 13, 2021

import Foundation

class InitResponseModel : Codable {
    
    let appLinks : [InitResponseAppLink]?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case appLinks = "app_links"
        case status = "status"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appLinks = try values.decodeIfPresent([InitResponseAppLink].self, forKey: .appLinks)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}

class InitResponseAppLink : Codable {
    
    let name : String?
    let showName : String?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case showName = "show_name"
        case url = "url"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        showName = try values.decodeIfPresent(String.self, forKey: .showName)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
}
