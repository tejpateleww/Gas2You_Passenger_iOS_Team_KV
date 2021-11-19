//
//  chatListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 15, 2021

import Foundation

struct chatListResModel : Codable {

        let data : [ChatListDatum]?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                data = try? values?.decodeIfPresent([ChatListDatum].self, forKey: .data)
                message = try? values?.decodeIfPresent(String.self, forKey: .message)
                status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct ChatListDatum : Codable {

    var bookingId : String?
        let createdAt : String?
        let fullName : String?
        let image : String?
        let message : String?
        let receiverId : String?

        enum CodingKeys: String, CodingKey {
                case bookingId = "booking_id"
                case createdAt = "created_at"
                case fullName = "full_name"
                case image = "image"
                case message = "message"
                case receiverId = "receiver_id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                bookingId = try? values?.decodeIfPresent(String.self, forKey: .bookingId)
                createdAt = try? values?.decodeIfPresent(String.self, forKey: .createdAt)
                fullName = try? values?.decodeIfPresent(String.self, forKey: .fullName)
                image = try? values?.decodeIfPresent(String.self, forKey: .image)
                message = try? values?.decodeIfPresent(String.self, forKey: .message)
                receiverId = try? values?.decodeIfPresent(String.self, forKey: .receiverId)
        }

}
