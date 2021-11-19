//
//  dateReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 18/11/21.
//

import Foundation
class DateReqModel: Encodable{
    var user_id : String?
    var booking_date : String?
    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case booking_date = "booking_date"
    }
}
