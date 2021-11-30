//
//  AddBookingReqModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 24/09/21.
//

import Foundation
class AddBookingReqModel : Encodable{
    var customer_id : String?
    var service_id : String?
    var sub_service_id : String?
    var parking_location : String?
    var latitude : String?
    var longitude : String?
    var date : String?
    var time : String?
    var vehicle_id : String?
    var total_amount : String?
    var add_on_id : String?
    var card_id : String?

    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case service_id = "service_id"
        case sub_service_id = "sub_service_id"
        case parking_location = "parking_location"
        case latitude = "latitude"
        case longitude = "longitude"
        case date = "date"
        case time = "time"
        case vehicle_id = "vehicle_id"
        case total_amount = "total_amount"
        case add_on_id = "add_on_id"
        case card_id = "card_id"
    }
    init(customerid:String,serviceid:String,subserviceid:String,parkinglocation:String,lat:String,lng:String,date:String,time:String,vehicleid:String,totalAmount:String,addonid:String,card_id:String){
        self.customer_id = customerid
        self.service_id = serviceid
        self.sub_service_id = subserviceid
        self.parking_location = parkinglocation
        self.latitude = lat
        self.longitude = lng
        self.date = date
        self.time = time
        self.vehicle_id = vehicleid
        self.total_amount = totalAmount
        self.add_on_id = addonid
        self.card_id = card_id
    }
}
