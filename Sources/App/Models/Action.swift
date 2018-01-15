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



extension Action{

	
	static func userInvolved(action :Action) -> Bool {
	
		guard let me = getCurrentUser() else {
			return false
		}
		
		let userId = me.id
		
		return action.sender.id == userId || action.receiver.id == userId
	}
	
	
	/*static func list(){
		
		guard let me = getCurrentUser() else {
			return nil
		}
	}*/
	
	
	static func receive(_ amount :Float, from sender :User, concept :String) -> Action? {
		
		guard let me = getCurrentUser() else {
			return nil
		}
		
		return Action(sender: sender, receiver: me, date: Date(), concept: concept, amount: amount, status: .CreatedByReceiver)
		
	}


	static func send(_ amount :Float, to receiver :User, concept :String) -> Action? {
		
		guard let me = getCurrentUser() else {
			return nil
		}
		
		return Action(sender: me, receiver: receiver, date: Date(), concept: concept, amount: amount, status: .CreatedBySender)
		
	}
	
}


