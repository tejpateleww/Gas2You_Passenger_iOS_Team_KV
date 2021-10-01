//
//  UpdateProfile.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 21/09/21.
//

import Foundation
class UpdateProfileRequestModel: Encodable{
    var customer_id : String?
    var first_name : String?
    var last_name : String?
    var mobile_no : String?
    var profile_image : String?
    

    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case mobile_no = "mobile_no"
        case profile_image = "profile_image"
    }

    init(customer_id:String,first_name: String, last_name: String,mobile_no:String) {
        self.customer_id = customer_id
        self.first_name = first_name
        self.last_name = last_name
        self.mobile_no = mobile_no
    }
}
