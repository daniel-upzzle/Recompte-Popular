//
//  User+fluent.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 12/1/18.
//

import Vapor
import FluentProvider

extension User {
	
	static func find(id: Int) -> User? {
		
		do{
			guard let model = try UserModel.find(id) else{
				return nil
			}
			
			return model.data
			
		}catch{
			
			return nil
		}
		
	}
}


final class UserModel : Model {
	
	let storage = Storage()
	
	var data :User
	
	struct Keys {
		static let id = "id"
		static let name = "name"
		static let email = "email"
	}
	
	
	func makeRow() throws -> Row {
		
		var row = Row()
		
		try row.set("name", data.name)
		try row.set("email", data.email)
		
		return row
	}
	
	init(row: Row) throws {
		
		let name :String = try row.get(Keys.name)
		let email :String = try row.get(Keys.email)
		
		let id :Int = try row.get(Keys.id)
		
		data = User(id: id, name: name, email: email)
	}

}


extension UserModel: Preparation {
	
	static func prepare(_ database: Database) throws {
		print("preparing user model")
		try database.create(self) { builder in
			print("creating user model")
			builder.id()
			builder.string("name")
			builder.string("email")
		}
	}
	
	/// Undoes what was done in `prepare`
	static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}


