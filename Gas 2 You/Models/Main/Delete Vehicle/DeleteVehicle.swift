//
//  DeleteVehicle.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 20/09/21.
//

import Foundation
class deleteVehicleReqModel : Encodable{
    var customerid : String?
    var vehicleid : String?
    
    enum CodingKeys: String, CodingKey {
        case customerid = "customer_id"
        case vehicleid = "vehicle_id"
    }
}
