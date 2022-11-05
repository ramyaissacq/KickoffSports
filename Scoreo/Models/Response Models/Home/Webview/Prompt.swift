//
//  Prompt.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on November 04, 2022
//
import Foundation
import SwiftyJSON

struct Prompt {

	let frequency: Int?
	let title: String?
	let message: String?

	init(_ json: JSON) {
		frequency = json["frequency"].intValue
		title = json["title"].stringValue
		message = json["message"].stringValue
	}

}