//
//  Action.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 11/1/18.
//

import Foundation


enum Currency: Int, Codable {
	case Euro
}


struct Action: Codable{
	
	
	enum Status: String, Codable {
		case CreatedBySender
		case CreatedByReceiver
		case Accepted
		case RejectedBySender
		case RejectedByReceiver
		case Accounted
		case Unknown
	}
	
	let sender: User
	let receiver: User
	let date: Date
	let concept: String
	let amount: Float
	let currency: Currency = .Euro
	let status: Status
	let counterPart: Id? = nil

	var isCompensation: Bool{
		return counterPart != nil
	}
	
	
}




