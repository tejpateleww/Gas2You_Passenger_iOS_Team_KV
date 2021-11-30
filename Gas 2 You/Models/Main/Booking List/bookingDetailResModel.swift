//
//  bookingDetailResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 27, 2021

import Foundation

struct bookingDetailResModel : Codable {
    
    let data : bookingDetailDatum?
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        data = try? values?.decodeIfPresent(bookingDetailDatum.self, forKey: .data)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}
struct bookingDetailDatum : Codable {
    
    let colorName : String?
    let completeOrderDateTime : String?
    let customerId : String?
    let date : String?
    let finalAmount : String?
    let id : String?
    let invoiceNumber : String?
    let latitude : String?
    let longitude : String?
    let mainServiceName : String?
    let makeName : String?
    let modelName : String?
    let orderStatus : String?
    let parkingLocation : String?
    let plateNumber : String?
    let pricePerGallon : String?
    let serviceId : String?
    let status : String?
    let subServiceId : String?
    let subServiceName : String?
    let time : String?
    let totalAmount : String?
    let totalGallon : String?
    let vehicleId : String?
    let rate : String?
    let review : String?
    let invoiceurl : String?
    
    enum CodingKeys: String, CodingKey {
        case colorName = "color_name"
        case completeOrderDateTime = "complete_order_date_time"
        case customerId = "customer_id"
        case date = "date"
        case finalAmount = "final_amount"
        case id = "id"
        case invoiceNumber = "invoice_number"
        case latitude = "latitude"
        case longitude = "longitude"
        case mainServiceName = "main_service_name"
        case makeName = "make_name"
        case modelName = "model_name"
        case orderStatus = "order_status"
        case parkingLocation = "parking_location"
        case plateNumber = "plate_number"
        case pricePerGallon = "price_per_gallon"
        case serviceId = "service_id"
        case status = "status"
        case subServiceId = "sub_service_id"
        case subServiceName = "sub_service_name"
        case time = "time"
        case totalAmount = "total_amount"
        case totalGallon = "total_gallon"
        case vehicleId = "vehicle_id"
        case rate = "rate"
        case review = "review"
        case invoiceurl = "invoice_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        colorName = try? values?.decodeIfPresent(String.self, forKey: .colorName)
        completeOrderDateTime = try? values?.decodeIfPresent(String.self, forKey: .completeOrderDateTime)
        customerId = try? values?.decodeIfPresent(String.self, forKey: .customerId)
        date = try? values?.decodeIfPresent(String.self, forKey: .date)
        finalAmount = try? values?.decodeIfPresent(String.self, forKey: .finalAmount)
        id = try? values?.decodeIfPresent(String.self, forKey: .id)
        invoiceNumber = try? values?.decodeIfPresent(String.self, forKey: .invoiceNumber)
        latitude = try? values?.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try? values?.decodeIfPresent(String.self, forKey: .longitude)
        mainServiceName = try? values?.decodeIfPresent(String.self, forKey: .mainServiceName)
        makeName = try? values?.decodeIfPresent(String.self, forKey: .makeName)
        modelName = try? values?.decodeIfPresent(String.self, forKey: .modelName)
        orderStatus = try? values?.decodeIfPresent(String.self, forKey: .orderStatus)
        parkingLocation = try? values?.decodeIfPresent(String.self, forKey: .parkingLocation)
        plateNumber = try? values?.decodeIfPresent(String.self, forKey: .plateNumber)
        pricePerGallon = try? values?.decodeIfPresent(String.self, forKey: .pricePerGallon)
        serviceId = try? values?.decodeIfPresent(String.self, forKey: .serviceId)
        status = try? values?.decodeIfPresent(String.self, forKey: .status)
        subServiceId = try? values?.decodeIfPresent(String.self, forKey: .subServiceId)
        subServiceName = try? values?.decodeIfPresent(String.self, forKey: .subServiceName)
        time = try? values?.decodeIfPresent(String.self, forKey: .time)
        totalAmount = try? values?.decodeIfPresent(String.self, forKey: .totalAmount)
        totalGallon = try? values?.decodeIfPresent(String.self, forKey: .totalGallon)
        vehicleId = try? values?.decodeIfPresent(String.self, forKey: .vehicleId)
        rate = try? values?.decodeIfPresent(String.self, forKey: .rate)
        review = try? values?.decodeIfPresent(String.self, forKey: .review)
        invoiceurl = try? values?.decodeIfPresent(String.self, forKey: .invoiceurl)
    }
    
}
class bookingDetailReqModel: Encodable{
    var customer_id : String?
    var order_id : String?
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case order_id = "order_id"
    }
    init(customerid:String,order_id:String){
        self.customer_id = customerid
        self.order_id = order_id
    }
}
