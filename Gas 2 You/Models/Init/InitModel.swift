//
//  InitResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on October 13, 2021

import Foundation

class InitResponseModel : Codable {
        let status: Bool
        let appLinks: [InitResponseAppLink]
        let currentDate: String

        enum CodingKeys: String, CodingKey {
            case status
            case appLinks = "app_links"
            case currentDate = "current_date"
        }

        init(status: Bool, appLinks: [InitResponseAppLink], currentDate: String) {
            self.status = status
            self.appLinks = appLinks
            self.currentDate = currentDate
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
