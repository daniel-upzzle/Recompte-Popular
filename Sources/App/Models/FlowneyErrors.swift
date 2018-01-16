//
//  FlowneyErrors.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 16/1/18.
//

import  HTTP

enum FlowneyErrors: Swift.Error {
	
	case permissionDenied
	case serverError
	case databaseInconsistency
	case wrongParameters(expected: [String:String])
	case actionNotFound(id: Int)
	case userNotFound(id: String)
	
}



final class FlowneyErrorsMiddleware: Middleware {
	
	func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		
		let output : ResponseRepresentable
		let status : Status
		
		do {
			
			return try next.respond(to: request)
			
		} catch FlowneyErrors.actionNotFound(let id) {
			
			status = .noContent
			output = [ "Message" : "Action with id \(id) not found." ]

		} catch FlowneyErrors.userNotFound(let id) {
			
			status = .noContent
			output = [ "Message" : "User with id \(id) not found." ]
			
		} catch FlowneyErrors.permissionDenied {
			
			status = .forbidden
			output = [ "Message" : "Permission denied." ]
			
		} catch FlowneyErrors.wrongParameters(let expected) {
			
			status = .badRequest
			output = [ "Expected parameters" : expected ]
			
		}
		
		let errResponse : Response = try output.makeResponse()
		errResponse.status = status
		
		return errResponse
		
	}
}
