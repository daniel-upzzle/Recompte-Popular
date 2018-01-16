//
//  User+Action.swift
//  RecomptePackageDescription
//
//  Created by Daniel Valls Estella on 16/1/18.
//

extension User{
	
	
	func canRead(action :Action) -> Bool {
		
		return action.sender.id == self.id || action.receiver.id == self.id
	}
	
	
	func receive(_ amount :Float, from sender :User, concept :String) -> Action {
		
		return Action(id: nil, sender: sender, receiver: self, date: Date(), concept: concept, amount: amount, status: .CreatedByReceiver)
		
	}
	
	
	func send(_ amount :Float, to receiver :User, concept :String) -> Action {
		
		return Action(id: nil, sender: self, receiver: receiver, date: Date(), concept: concept, amount: amount, status: .CreatedBySender)
		
	}
	
}
