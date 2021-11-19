//
//  EditProfileReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 21/09/21.
//

import Foundation
class EditVehicleReqModel: Encodable{
    var vehicle_id : String?
    var year : String?
    var make : String?
    var model : String?
    var color : String?
    var state :String?
    var license_plate_number : String?

    enum CodingKeys: String, CodingKey {
        case vehicle_id = "vehicle_id"
        case year = "year"
        case make = "make"
        case model = "model"
        case color = "color"
        case state = "state"
        case license_plate_number = "license_plate_number"
    }
    init(vehicle_id:String,year:String,make:String,model:String,color:String,state:String,plateno:String){
        self.vehicle_id = vehicle_id
        self.year = year
        self.make = make
        self.model = model
        self.color = color
        self.state = state
        self.license_plate_number = plateno
    }
}
