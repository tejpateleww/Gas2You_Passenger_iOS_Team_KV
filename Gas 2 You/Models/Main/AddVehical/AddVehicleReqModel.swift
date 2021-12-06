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
    var state : String?
    var license_plate_number : String?
    var isothermodel : Bool = false
    var modelname : String?
    var isothermake : Bool = false
    var makename : String?

    enum CodingKeys: String, CodingKey {
        case customerid = "customer_id"
        case year = "year"
        case make = "make"
        case model = "model"
        case color = "color"
        case state = "state"
        case license_plate_number = "license_plate_number"
        case isothermodel = "is_other_model"
        case modelname = "model_name"
        case isothermake = "is_other_make"
        case makename = "make_name"
    }
    init(customerid:String,year:String,make:String,model:String,color:String,state:String,plateno:String,isothermodel:Bool,modelname:String,isothermake:Bool,makename:String){
        self.customerid = customerid
        self.year = year
        self.make = make
        self.model = model
        self.color = color
        self.state = state
        self.license_plate_number = plateno
        self.isothermake = isothermake
        self.modelname = modelname
        self.makename = makename
        self.isothermodel = isothermodel
    }
}
