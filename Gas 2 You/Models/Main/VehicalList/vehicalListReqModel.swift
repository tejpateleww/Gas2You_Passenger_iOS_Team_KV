//
//  vehicalListReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 20/09/21.
//

import Foundation
class vehicalListReqModel: Encodable{
    var customerid : String?

    enum CodingKeys: String, CodingKey {
        case customerid = "customer_id"
    }
}
