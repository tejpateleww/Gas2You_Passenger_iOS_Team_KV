//
//  chatHistoryResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 15, 2021

import Foundation

struct chatHistoryResModel : Codable {

        let bookingId : String?
        let data : [chatHistoryDatum]?
        let driverId : String?
        let driverName : String?
        let driverProfilePicture : String?
        let message : String?
        let status : Bool?

        enum CodingKeys: String, CodingKey {
                case bookingId = "booking_id"
                case data = "data"
                case driverId = "driver_id"
                case driverName = "driver_name"
                case driverProfilePicture = "driver_profile_picture"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                bookingId = try? values?.decodeIfPresent(String.self, forKey: .bookingId)
                data = try? values?.decodeIfPresent([chatHistoryDatum].self, forKey: .data)
                driverId = try? values?.decodeIfPresent(String.self, forKey: .driverId)
                driverName = try? values?.decodeIfPresent(String.self, forKey: .driverName)
                driverProfilePicture = try? values?.decodeIfPresent(String.self, forKey: .driverProfilePicture)
                message = try? values?.decodeIfPresent(String.self, forKey: .message)
                status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
        }

}
struct chatHistoryDatum : Codable {

        let bookingId : String?
        let createdAt : String?
        let id : String?
        let message : String?
        let receiverId : String?
        let receiverType : String?
        let senderId : String?
        let senderType : String?

        enum CodingKeys: String, CodingKey {
                case bookingId = "booking_id"
                case createdAt = "created_at"
                case id = "id"
                case message = "message"
                case receiverId = "receiver_id"
                case receiverType = "receiver_type"
                case senderId = "sender_id"
                case senderType = "sender_type"
        }
    
        init(from decoder: Decoder) throws {
                let values = try? decoder.container(keyedBy: CodingKeys.self)
                bookingId = try? values?.decodeIfPresent(String.self, forKey: .bookingId)
                createdAt = try? values?.decodeIfPresent(String.self, forKey: .createdAt)
                id = try? values?.decodeIfPresent(String.self, forKey: .id)
                message = try? values?.decodeIfPresent(String.self, forKey: .message)
                receiverId = try? values?.decodeIfPresent(String.self, forKey: .receiverId)
                receiverType = try? values?.decodeIfPresent(String.self, forKey: .receiverType)
                senderId = try? values?.decodeIfPresent(String.self, forKey: .senderId)
                senderType = try? values?.decodeIfPresent(String.self, forKey: .senderType)
        }

}
