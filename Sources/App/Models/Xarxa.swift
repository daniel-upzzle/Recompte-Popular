import Vapor
import FluentProvider
import HTTP

final class Xarxa: Model {
	
	var trustedEmail: String
	var recursive: Int
	
	let storage = Storage()
	
	/// The column names for `id` and `content` in the database
	struct Keys {
		static let id = "id"
		static let trustedEmail = "trusted_email"
		static let recursive = "recursive"
	}
	
	init(row: Row) throws {
		trustedEmail = try row.get(Keys.trustedEmail)
		recursive = try row.get(Keys.recursive)
	}
	
	init(trustedEmail: String, recursive: Int) {
		self.trustedEmail = trustedEmail
		self.recursive = recursive
	}
	
	func makeRow() throws -> Row {
		var row = Row()
		try row.set(Keys.trustedEmail, trustedEmail)
		try row.set(Keys.recursive, recursive)
		return row
	}
	
	
	
}


// MARK: Fluent Preparation

extension Xarxa: Preparation {
	/// Prepares a table/collection in the database
	/// for storing Posts
	static func prepare(_ database: Database) throws {
		try database.create(self) { builder in
			builder.id()
			builder.string(Xarxa.Keys.trustedEmail)
			builder.int(Xarxa.Keys.recursive)
		}
	}
	
	/// Undoes what was done in `prepare`
	static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}
