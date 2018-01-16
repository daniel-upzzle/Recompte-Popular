//
//  Actions.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 16/1/18.
//

import Vapor


func actionsRoute( builder actions : RouteBuilder ){
	
	
	actions.get { req in
		
		return Action.list(user: req.user.id)
		
	}
	
	
	actions.get(Int.parameter) { req in
		
		let id = try req.parameters.next(Int.self)
		
		guard let action = Action.find(id: id) else {
			throw FlowneyErrors.actionNotFound(id: id)
		}
		
		if !req.user.canRead(action: action) {
			throw FlowneyErrors.permissionDenied
		}
		
		return action
		
	}
	
	
	actions.post("send"){ req in
		
		guard
			let amount = req.data["amount"]?.float,
			let concept = req.data["concept"]?.string,
			let receiver_id = req.data["to"]?.string
			else {
				throw FlowneyErrors.wrongParameters(expected: [
					"amount" : "float",
					"concept" : "string",
					"to" : "string"
					] )
		}
		
		guard let receiver = User.find(id: receiver_id) else {
			throw FlowneyErrors.userNotFound(id: receiver_id)
		}
		
		let newAction = req.user.send(amount, to: receiver, concept: concept)
		
		guard let savedAction = Action.post(newAction) else{
			throw FlowneyErrors.serverError
		}
		
		return savedAction
	}
	
	
	actions.post("receive"){ req in
		
		guard
			let amount = req.data["amount"]?.float,
			let concept = req.data["concept"]?.string,
			let sender_id = req.data["from"]?.string
			else {
				throw FlowneyErrors.wrongParameters(expected: [
					"amount" : "float",
					"concept" : "string",
					"from" : "string"
					] )
		}
		
		guard let sender = User.find(id: sender_id) else {
			throw FlowneyErrors.userNotFound(id: sender_id)
		}
		
		let newAction = req.user.receive(amount, from: sender, concept: concept)
		
		guard let savedAction = Action.post(newAction) else{
			throw FlowneyErrors.serverError
		}
		
		return savedAction
	}
	
}
