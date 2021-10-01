//
//  logoutResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 23, 2021

import Foundation

struct logoutResModel : Codable {

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
