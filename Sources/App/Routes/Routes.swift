import Vapor

extension Droplet {
    func setupRoutes() throws {
		
		let mysqlDriver = try self.mysql()
		
        get("hello") { req in
            var json = JSON()
            try json.set("RRecompte", "Popular")
            return json
        }

        get("plaintext") { req in
			
			guard let xarxa = try Xarxa.find(1) else {
				throw Abort.notFound
			}
			
			let email = xarxa.trustedEmail
			print(email) // the name of the dog with id 42
			//let result = try mysqlDriver.raw("SELECT @@version")
            return "Recompte popular! \(email)"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
