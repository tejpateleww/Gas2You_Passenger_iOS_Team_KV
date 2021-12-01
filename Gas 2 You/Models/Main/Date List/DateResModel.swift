
//
//  resModel.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on November 19, 2021

import Foundation

struct DateResModel : Codable {
    
    let availableDates : [String]?
    let currentDate : String?
    let data : [String]?
    let message : String?
    let status : Bool?
    
    enum CodingKeys: String, CodingKey {
        case availableDates = "available_dates"
        case currentDate = "current_date"
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        availableDates = try? values?.decodeIfPresent([String].self, forKey: .availableDates)
        currentDate = try? values?.decodeIfPresent(String.self, forKey: .currentDate)
        data = try? values?.decodeIfPresent([String].self, forKey: .data)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        status = try? values?.decodeIfPresent(Bool.self, forKey: .status)
    }
    
}
