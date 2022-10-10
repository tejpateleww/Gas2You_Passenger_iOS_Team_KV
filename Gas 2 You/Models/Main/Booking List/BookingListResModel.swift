//
//  BookingListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 24, 2021

import Foundation

struct BookingListResModel : Codable {
    
    let data : [BookingListDatum]?
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try? values.decodeIfPresent([BookingListDatum].self, forKey: .data)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        status = try? values.decodeIfPresent(Bool.self, forKey: .status)
    }
}
struct BookingListDatum : Codable {
    
    let colorName : String?
    let completeOrderDateTime : String?
    let customerId : String?
    let date : String?
    let driverContactNumber : String?
    let driverContactNumberCode : String?
    let driverId : String?
    let finalAmount : String?
    let id : String?
    let invoiceNumber : String?
    let invoiceUrl : String?
    let latitude : String?
    let longitude : String?
    let mainServiceName : String?
    let makeName : String?
    let modelName : String?
    let statuslabel : String?
    let parkingLocation : String?
    let plateNumber : String?
    let pricePerGallon : String?
    let rate : String?
    let review : String?
    let serviceId : String?
    let status : String?
    let subServiceId : String?
    let subServiceName : String?
    let time : String?
    let totalAmount : String?
    let totalGallon : String?
    let vehicleId : String?
    let note : String?
    
    enum CodingKeys: String, CodingKey {
        case colorName = "color_name"
        case completeOrderDateTime = "complete_order_date_time"
        case customerId = "customer_id"
        case date = "date"
        case driverContactNumber = "driver_contact_number"
        case driverContactNumberCode = "driver_contact_number_code"
        case driverId = "driver_id"
        case finalAmount = "final_amount"
        case id = "id"
        case invoiceNumber = "invoice_number"
        case invoiceUrl = "invoice_url"
        case latitude = "latitude"
        case longitude = "longitude"
        case mainServiceName = "main_service_name"
        case makeName = "make_name"
        case modelName = "model_name"
        case statuslabel = "status_label"
        case parkingLocation = "parking_location"
        case plateNumber = "plate_number"
        case pricePerGallon = "price_per_gallon"
        case rate = "rate"
        case review = "review"
        case serviceId = "service_id"
        case status = "status"
        case subServiceId = "sub_service_id"
        case subServiceName = "sub_service_name"
        case time = "time"
        case totalAmount = "total_amount"
        case totalGallon = "total_gallon"
        case vehicleId = "vehicle_id"
        case note = "note"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        colorName = try? values?.decodeIfPresent(String.self, forKey: .colorName)
        completeOrderDateTime = try? values?.decodeIfPresent(String.self, forKey: .completeOrderDateTime)
        customerId = try? values?.decodeIfPresent(String.self, forKey: .customerId)
        date = try? values?.decodeIfPresent(String.self, forKey: .date)
        driverContactNumber = try? values?.decodeIfPresent(String.self, forKey: .driverContactNumber)
        driverContactNumberCode = try? values?.decodeIfPresent(String.self, forKey: .driverContactNumberCode)
        driverId = try? values?.decodeIfPresent(String.self, forKey: .driverId)
        finalAmount = try? values?.decodeIfPresent(String.self, forKey: .finalAmount)
        id = try? values?.decodeIfPresent(String.self, forKey: .id)
        invoiceNumber = try? values?.decodeIfPresent(String.self, forKey: .invoiceNumber)
        invoiceUrl = try? values?.decodeIfPresent(String.self, forKey: .invoiceUrl)
        latitude = try? values?.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try? values?.decodeIfPresent(String.self, forKey: .longitude)
        mainServiceName = try? values?.decodeIfPresent(String.self, forKey: .mainServiceName)
        makeName = try? values?.decodeIfPresent(String.self, forKey: .makeName)
        modelName = try? values?.decodeIfPresent(String.self, forKey: .modelName)
        statuslabel = try? values?.decodeIfPresent(String.self, forKey: .statuslabel)
        parkingLocation = try? values?.decodeIfPresent(String.self, forKey: .parkingLocation)
        plateNumber = try? values?.decodeIfPresent(String.self, forKey: .plateNumber)
        pricePerGallon = try? values?.decodeIfPresent(String.self, forKey: .pricePerGallon)
        rate = try? values?.decodeIfPresent(String.self, forKey: .rate)
        review = try? values?.decodeIfPresent(String.self, forKey: .review)
        serviceId = try? values?.decodeIfPresent(String.self, forKey: .serviceId)
        status = try? values?.decodeIfPresent(String.self, forKey: .status)
        subServiceId = try? values?.decodeIfPresent(String.self, forKey: .subServiceId)
        subServiceName = try? values?.decodeIfPresent(String.self, forKey: .subServiceName)
        time = try? values?.decodeIfPresent(String.self, forKey: .time)
        totalAmount = try? values?.decodeIfPresent(String.self, forKey: .totalAmount)
        totalGallon = try? values?.decodeIfPresent(String.self, forKey: .totalGallon)
        vehicleId = try? values?.decodeIfPresent(String.self, forKey: .vehicleId)
        note = try? values?.decodeIfPresent(String.self, forKey: .note)
    }
}
class bookingListReqModel: Encodable{
    var customer_id : String?
    var status : String?
    var page :String?
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case status = "status"
        case page = "page"
    }
    init(customerid:String,status:String,page:String){
        self.customer_id = customerid
        self.status = status
        self.page = page
    }
}
