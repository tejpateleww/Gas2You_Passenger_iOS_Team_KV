//
//  bookingDetailResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 27, 2021

import Foundation

// MARK: - BookingDetailResModel
class BookingDetailResModel: Codable {
    let status: Bool
    let message: String
    let data: BookingDetailDatum

    init(status: Bool, message: String, data: BookingDetailDatum) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class BookingDetailDatum: Codable {
    let id, customerID, driverID, serviceID: String
    let subServiceID, parkingLocation, latitude, longitude: String
    let date, time, vehicleID, status: String
    let mainServiceName, plateNumber, orderStatus, completeOrderDateTime: String
    let invoiceNumber, totalAmount, totalGallon, pricePerGallon: String
    let finalAmount, rate, review, subServiceName: String
    let makeName, modelName, colorName: String
    let invoiceURL: String
    let driverContactNumber, driverContactNumberCode: String
    let services: [Service]

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case driverID = "driver_id"
        case serviceID = "service_id"
        case subServiceID = "sub_service_id"
        case parkingLocation = "parking_location"
        case latitude, longitude, date, time
        case vehicleID = "vehicle_id"
        case status
        case mainServiceName = "main_service_name"
        case plateNumber = "plate_number"
        case orderStatus = "order_status"
        case completeOrderDateTime = "complete_order_date_time"
        case invoiceNumber = "invoice_number"
        case totalAmount = "total_amount"
        case totalGallon = "total_gallon"
        case pricePerGallon = "price_per_gallon"
        case finalAmount = "final_amount"
        case rate, review
        case subServiceName = "sub_service_name"
        case makeName = "make_name"
        case modelName = "model_name"
        case colorName = "color_name"
        case invoiceURL = "invoice_url"
        case driverContactNumber = "driver_contact_number"
        case driverContactNumberCode = "driver_contact_number_code"
        case services
    }

    init(id: String, customerID: String, driverID: String, serviceID: String, subServiceID: String, parkingLocation: String, latitude: String, longitude: String, date: String, time: String, vehicleID: String, status: String, mainServiceName: String, plateNumber: String, orderStatus: String, completeOrderDateTime: String, invoiceNumber: String, totalAmount: String, totalGallon: String, pricePerGallon: String, finalAmount: String, rate: String, review: String, subServiceName: String, makeName: String, modelName: String, colorName: String, invoiceURL: String, driverContactNumber: String, driverContactNumberCode: String, services: [Service]) {
        self.id = id
        self.customerID = customerID
        self.driverID = driverID
        self.serviceID = serviceID
        self.subServiceID = subServiceID
        self.parkingLocation = parkingLocation
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.time = time
        self.vehicleID = vehicleID
        self.status = status
        self.mainServiceName = mainServiceName
        self.plateNumber = plateNumber
        self.orderStatus = orderStatus
        self.completeOrderDateTime = completeOrderDateTime
        self.invoiceNumber = invoiceNumber
        self.totalAmount = totalAmount
        self.totalGallon = totalGallon
        self.pricePerGallon = pricePerGallon
        self.finalAmount = finalAmount
        self.rate = rate
        self.review = review
        self.subServiceName = subServiceName
        self.makeName = makeName
        self.modelName = modelName
        self.colorName = colorName
        self.invoiceURL = invoiceURL
        self.driverContactNumber = driverContactNumber
        self.driverContactNumberCode = driverContactNumberCode
        self.services = services
    }
}

// MARK: - Service
class Service: Codable {
    let title, price, serviceDescription: String

    enum CodingKeys: String, CodingKey {
        case title, price
        case serviceDescription = "description"
    }

    init(title: String, price: String, serviceDescription: String) {
        self.title = title
        self.price = price
        self.serviceDescription = serviceDescription
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
