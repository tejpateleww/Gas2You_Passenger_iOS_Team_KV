//
//  AddLocationResModel.swift
//  Gas 2 You
//
//  Created by Harsh Dave on 03/12/21.
//

import Foundation

// MARK: - AddLocationResModel
class AddLocationResModel: Codable {
    let status: Bool
    let message: String
    let data: [AddLocationDatum]

    init(status: Bool, message: String, data: [AddLocationDatum]) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class AddLocationDatum: Codable {
    let id, location, latitude, longitude: String

    init(id: String, location: String, latitude: String, longitude: String) {
        self.id = id
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
}

class AddLocationReqModel: Encodable{
    var customer_id : String? = Singleton.sharedInstance.userId
    var location : String?
    var latitude : String?
    var longitude : String?
    
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
class LocationListReqModel: Encodable{
    var customer_id : String? = Singleton.sharedInstance.userId
    enum CodingKeys: String, CodingKey {
        case customer_id = "customer_id"
    }
}

