//
//  AddVehicleReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 20/09/21.
//

import Foundation
class AddVehicleReqModel: Encodable{
    var customerid : String?
    var year : String?
    var make : String?
    var model : String?
    var color : String?
    var license_plate_number : String?

    enum CodingKeys: String, CodingKey {
        case customerid = "customer_id"
        case year = "year"
        case make = "make"
        case model = "model"
        case color = "color"
        case license_plate_number = "license_plate_number"
    }
    init(customerid:String,year:String,make:String,model:String,color:String,plateno:String){
        self.customerid = customerid
        self.year = year
        self.make = make
        self.model = model
        self.color = color
        self.license_plate_number = plateno
    }
}
