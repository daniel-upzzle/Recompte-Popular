//
//  Action+Fluent.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 12/1/18.
//

import Vapor
import FluentProvider

extension Action : ResponseRepresentable { }


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
	
	static func list(user :Id) -> [Action] {
		
		do{

			return  try ActionModel.makeQuery().or{ orGroup in
				
						try orGroup.filter("sender" == user)
						try orGroup.filter("receiver" == user)
				
				}.all().map{
					$0.data
				}
			
			
		} catch {
			print("Fluent Query Error info: \(error)")
		}
		
		return []
	}
}


final class ActionModel :Model{
	
	let storage = Storage()
	
	var data :Action
	
	
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
		
		let id :Int = try row.get(Keys.id)
		let sender_id :String = try row.get(Keys.sender)
		let receiver_id :String = try row.get(Keys.receiver)
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
			id: id,
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
		
		try row.set(Keys.sender, data.sender.id)
		try row.set(Keys.receiver, data.receiver.id)
		try row.set(Keys.date, data.date)
		try row.set(Keys.concept, data.concept)
		try row.set(Keys.amount, data.amount)
		try row.set(Keys.status, data.status.rawValue)
		
		return row
	}
}


extension ActionModel: Preparation {
	
	static func prepare(_ database: Database) throws {
		try database.create(self) { builder in
			builder.id()
			builder.string(Keys.concept)
			builder.float(Keys.amount)
			builder.string(Keys.sender)
			builder.string(Keys.receiver)
			builder.date(Keys.date)
			builder.string(Keys.status)
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
