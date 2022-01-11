//
//  AddNewVehicleReqModel.swift
//  Gas 2 You
//
//  Created by Tej P on 11/01/22.
//

import Foundation

class AddNewVehicleReqModel: Encodable{
    var customerId : String?  = Singleton.sharedInstance.userId
    var year : String?
    var make : String?
    var model : String?
    var color : String?
    var licensePlateNumber : String?
    var state : String?
    var isOtherModel : Bool?
    var OtherModelName : String?
    var isOtherMake : Bool?
    var OtherMakeName : String?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case year = "year"
        case make = "make"
        case model = "model"
        case color = "color"
        case licensePlateNumber = "license_plate_number"
        case state = "state"
        case isOtherModel = "is_other_model"
        case OtherModelName = "model_name"
        case isOtherMake = "is_other_make"
        case OtherMakeName = "make_name"
    }
}

class EditNewVehicleReqModel: Encodable{
    var vehicleId : String?
    var year : String?
    var make : String?
    var model : String?
    var color : String?
    var licensePlateNumber : String?
    var state : String?
    var isOtherModel : Bool?
    var OtherModelName : String?
    var isOtherMake : Bool?
    var OtherMakeName : String?
    
    enum CodingKeys: String, CodingKey {
        case vehicleId = "vehicle_id"
        case year = "year"
        case make = "make"
        case model = "model"
        case color = "color"
        case licensePlateNumber = "license_plate_number"
        case state = "state"
        case isOtherModel = "is_other_model"
        case OtherModelName = "model_name"
        case isOtherMake = "is_other_make"
        case OtherMakeName = "make_name"
    }
}
