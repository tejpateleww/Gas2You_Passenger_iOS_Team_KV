//
//  CancelMemberConfirmResModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on February 11, 2022
//
import Foundation

struct CancelMemberConfirmResModel: Codable {

	let status: Bool?
	let isOpenModal: Bool?
	let message: String?

	private enum CodingKeys: String, CodingKey {
		case status = "status"
		case isOpenModal = "is_open_modal"
		case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		isOpenModal = try values.decodeIfPresent(Bool.self, forKey: .isOpenModal)
		message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
