//
//  NotificationStatusReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 01/12/21.
//

import Foundation
class NotificationStatusReqModel: Encodable{
    var customerid : String? = Singleton.sharedInstance.userId
    var notification : String?
    
    enum CodingKeys: String, CodingKey {
        case customerid = "customer_id"
        case notification = "notification"
    }
}
class NotificationReqModel: Encodable{
    var customerid : String? = Singleton.sharedInstance.userId
    var page : String?
    
    enum CodingKeys: String, CodingKey {
        case customerid = "customer_id"
        case page = "page"
    }
}
