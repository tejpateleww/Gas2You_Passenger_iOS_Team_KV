//
//  appleLoginResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 1, 2021

import Foundation

struct appleLoginResModel : Codable {

        let appleDetail : AppleDetail?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case appleDetail = "apple_detail"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                appleDetail = try values.decodeIfPresent(AppleDetail.self, forKey: .appleDetail)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct AppleDetail : Codable {

        let appleId : String?
        let email : String?
        let firstName : String?
        let lastName : String?

        enum CodingKeys: String, CodingKey {
                case appleId = "apple_id"
                case email = "email"
                case firstName = "first_name"
                case lastName = "last_name"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                appleId = try? values?.decodeIfPresent(String.self, forKey: .appleId)
                email = try? values?.decodeIfPresent(String.self, forKey: .email)
                firstName = try? values?.decodeIfPresent(String.self, forKey: .firstName)
                lastName = try? values?.decodeIfPresent(String.self, forKey: .lastName)
        }

}
