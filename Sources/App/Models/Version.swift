//
//  Version.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 16/1/18.
//

import HTTP

final class VersionMiddleware: Middleware {
	func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		let response = try next.respond(to: request)
		
		response.headers["Version"] = "API v0.1"
		
		return response
	}
}
