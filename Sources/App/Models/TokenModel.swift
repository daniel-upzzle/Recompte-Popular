//
//  TokenModel.swift
//  RecomptePackageDescription
//
//  Created by Daniel Valls Estella on 15/1/18.
//

import Vapor
import FluentProvider

final class TokenModel: Model {
	let token: String
	let userId: Identifier
	
	var user: Parent<TokenModel, UserModel> {
		return parent(id: userId)
	}
	
	let storage = Storage()
	
	
	struct Keys {
		static let id = "id"
		static let token = "token"
		static let userId = "user_model_id"
	}
	
	
	func makeRow() throws -> Row {
		
		var row = Row()
		
		try row.set(Keys.token, token)
		try row.set(Keys.userId, userId)
		
		return row
	}
	
	init(row: Row) throws {
		
		token = try row.get(Keys.token)
		userId = try row.get(Keys.userId)
		
	}
	
}

extension TokenModel: Preparation {
	
	
	static func prepare(_ database: Database) throws {
		try database.create(self) { builder in
			builder.id()
			builder.string(Keys.token)
			builder.integer(Keys.userId)
		}
	}
	
	/// Undoes what was done in `prepare`
	static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}
