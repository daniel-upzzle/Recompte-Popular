//
//  Action+Fluent.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 12/1/18.
//

import Vapor
import FluentProvider


extension Action {
	
	
	static func post(_ data :Action) -> Action? {
	
		let model = ActionModel(data: data)
		
		do{
			try model.save()
		}catch{
			return nil
		}
		
		return model.data
	}
	
	
	static func find(id: Int) -> Action? {
		
		do{
			guard let model = try ActionModel.find(id) else{
				return nil
			}
			
			return model.data
			
		}catch{
			
			return nil
		}
		
	}
	
	static func list(user :Int) -> [Action] {
		
		do{

			return  try ActionModel.makeQuery().or{ orGroup in
				
						try orGroup.filter("sender" == user)
						try orGroup.filter("receiver" == user)
				
				}.all().map{
					$0.data
				}
			
			
		} catch {
			print("Error info: \(error)")
		}
		
		return []
	}
}


final class ActionModel :Model{
	
	let storage = Storage()
	
	var data :Action
	
	/*let description :[String:Any] = [
		"concept": \Action.concept,
		"amount": \Action.amount,
		]*/
	
	/// The column names for `id` and `content` in the database
	struct Keys {
		static let id = "id"
		static let sender = "sender"
		static let receiver = "receiver"
		static let date = "date"
		static let concept = "concept"
		static let amount = "amount"
		//static let currency = "currency"
		static let status = "status"
		//static let counterPart = "counter_part"
	}
	
	init(data: Action){
		self.data = data
	}
	

	init(row: Row) throws {
		
		let sender_id :Int = try row.get(Keys.sender)
		let receiver_id :Int = try row.get(Keys.receiver)
		let date :Date = try row.get(Keys.date)
		let concept :String = try row.get(Keys.concept)
		let amount :Float = try row.get(Keys.amount)
		//let currency :Currency = Currency( rawValue: try row.get(Keys.currency) ) ?? .Euro
		let status :Action.Status = Action.Status( rawValue: try row.get(Keys.status) ) ?? .Unknown
		//let counterPart :String = try row.get(Keys.counterPart)
		
		guard let sender = User.find(id: sender_id), let receiver = User.find(id: receiver_id) else {
			throw FlowneyErrors.databaseInconsistency
		}
		
		data = Action(
			sender: sender,
			receiver: receiver,
			date: date,
			concept: concept,
			amount: amount,
			status: status
		)
	}
	
	func makeRow() throws -> Row {
		
		var row = Row()
		
		try row.set("sender", data.sender.id)
		try row.set("receiver", data.receiver.id)
		try row.set("date", data.date)
		try row.set("concept", data.concept)
		try row.set("amount", data.amount)
		try row.set("status", data.status.rawValue)
		
		return row
	}
}


extension ActionModel: Preparation {
	
	static func prepare(_ database: Database) throws {
		print("preparing action model")
		try database.create(self) { builder in
			builder.id()
			builder.string("concept")
			builder.float("amount")
			builder.int("sender")
			builder.int("receiver")
			builder.date("date")
			builder.string("status")
		}
	}
	
	/// Undoes what was done in `prepare`
	static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}



/*
class CodableModel<A:Codable> :Model{

required init(row: Row) throws {

for (fieldName, keyPath) in getDescription() {

guard let kp = keyPath as? KeyPath<Any, Any> else{

}

data[keyPath: kp] = try row.get(fieldName)
//try row.set(fieldName, data[keyPath: keyPath])
}
}

let storage = Storage()

var data :A


func getDescription() -> [String:Any] {
return [:] as! [String:Any]
}

func makeRow() throws -> Row {

var row = Row()

for (fieldName, keyPath) in getDescription() {
guard let kp = keyPath as? KeyPath<Any, Any> else{

}
try row.set(fieldName, data[keyPath: kp])
}

return row
}



}*/
