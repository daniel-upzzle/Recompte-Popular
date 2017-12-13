//
//  User.swift
//  RecomptePackageDescription
//
//  Created by Daniel Valls Estella on 13/12/17.
//

import Vapor
import FluentProvider

final class Xarxa: Model {
	
	var trustedEmail: String
	
	let storage = Storage()
	
	init(row: Row) throws {
		trustedEmail = try row.get("trusted_email")
	}
	
	init(trustedEmail: String) {
		self.trustedEmail = trustedEmail
	}
	
	func makeRow() throws -> Row {
		var row = Row()
		try row.set("trusted_email", trustedEmail)
		return row
	}
	
	
	
}
