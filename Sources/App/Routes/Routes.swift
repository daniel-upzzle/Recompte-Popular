import Vapor
import Foundation
import AuthProvider
import JWT
import JWTProvider




extension Droplet {

	
    func setupRoutes() throws {
		

		/// use this route group for protected routes
		let tokenMiddleware = PayloadAuthenticationMiddleware<UserModel>(config.jwksURL!)
		let authed = grouped( tokenMiddleware ) //TokenAuthenticationMiddleware( UserModel.self ) )
		
		
		/*get("users", String.parameter) { req in
			
			let id : String = try req.parameters.next(String.self)
			
			guard let user = User.find(id: id) else {
				throw Abort.notFound
			}
			
			return try makeResponseRespresentable(encodable: user )
			
		}*/
		
		authed.get("user","data") { req in
			
			return req.user
		}
		
		actionsRoute(builder: authed.grouped("actions") )

    }
}
