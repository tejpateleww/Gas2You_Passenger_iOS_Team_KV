//
//  yearcolorstateListResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 19, 2021

import Foundation

struct yearcolorstateListResModel : Codable {

        let data : [yearcolorstateListDatum]?
        let message : String?
        let stateList : [StateList]?
        let status : Bool?
        let yearList : [String]?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case stateList = "state_list"
                case status = "status"
                case yearList = "year_list"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([yearcolorstateListDatum].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                stateList = try values.decodeIfPresent([StateList].self, forKey: .stateList)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
                yearList = try values.decodeIfPresent([String].self, forKey: .yearList)
        }

}
struct yearcolorstateListDatum : Codable {

        let color : String?
        let id : String?

        enum CodingKeys: String, CodingKey {
                case color = "color"
                case id = "id"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                color = try values.decodeIfPresent(String.self, forKey: .color)
                id = try values.decodeIfPresent(String.self, forKey: .id)
        }

}
struct StateList : Codable {

        let id : String?
        let stateCode : String?
        let stateName : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case stateCode = "state_code"
                case stateName = "state_name"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                stateCode = try values.decodeIfPresent(String.self, forKey: .stateCode)
                stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
        }

}
