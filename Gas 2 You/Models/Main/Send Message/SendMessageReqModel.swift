//
//  SendMessageReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 16/11/21.
//

import Foundation
class SendMsgReqModel: Encodable{
    var bookingId : String?
    var senderId : String? = Singleton.sharedInstance.userId
    var receiverId : String?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case message = "message"
    }
}
