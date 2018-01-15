import Vapor
import Foundation
import AuthProvider


struct MyError: Error, ResponseRepresentable{
	
	let message:String
	
	func makeResponse() throws -> Response {
		return message.makeResponse()
	}
	
	static func databaseError() -> MyError{
		
		return MyError(message: "database error")
	}
}

/*

extension Encodable{
	
	func makeResponse() throws -> Response {
		let jsonEncoder = JSONEncoder()
		jsonEncoder.outputFormatting = .prettyPrinted
		return try jsonEncoder.encode(self).makeResponse()
	}
	
}*/

/*
extension Array where Element:ResponseRepresentable{

	func makeResponse() throws -> Response {
		
		self.reduce("[") { (result, element) -> String in
			element
			"\(result) "
		}
		let jsonEncoder = JSONEncoder()
		return try jsonEncoder.encode(self).makeResponse()
	}
}


extension Array: ResponseRepresentable{
	
}*/

/*extension Trust: ResponseRepresentable{
	
}*/

func encodableResponse<A:Encodable>(r: Request, f: (Request) -> A) throws -> ResponseRepresentable{
	return try makeResponse(encodable: f(r))
}

func makeResponse<A:Encodable>(encodable: A) throws -> ResponseRepresentable{
	//let jsonEncoder = JSONEncoder()
	//jsonEncoder.outputFormatting = .prettyPrinted
	//return try jsonEncoder.encode(encodable).makeResponse()
	
	return try ResponseJSONEncoder.encode(data: encodable).makeResponse()
}

class ResponseJSONEncoder{
	
	static let singleton = ResponseJSONEncoder()
	
	private let encoder: JSONEncoder
	
	private init(){
		encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
	}
	
	static func encode<A:Encodable>(data: A) throws -> Data{
		return try ResponseJSONEncoder.singleton.encoder.encode(data)
	}
}

enum Route {
	case xarxa2(responds: Trust)
	case xarxa3(responds: String, param2: Int)
}

/*
func dasds(dads:String, dsad:Int) -> Trust{
	
}


func bindRoute<B:Encodable>(route: Route){ //} -> ((Request) -> B?) {
	
	switch route {
		
	/*case .xarxa2:
		func a(req:Request) -> Trust?{
		
			guard let currentUser = getCurrentUser() else{
				return nil
			}
		
			return Trust(from: currentUser, to: "pepiot@dasds.com", recursive: 0)
		}
		return a
*/
		
	case .xarxa3(let responds, let dsad):
		dasds(dads: responds, dsad: dsad)
		
	default:
		return
		
	}
}
*/

extension Droplet {
	
	func bind<B:Encodable>(path: String, _ f: @escaping (Request) -> B? ){
		get(path){ req in
			guard let responseData = f(req) else{
				return "errorrrr".makeResponse()
			}
			return try makeResponse(encodable:responseData)
		}

	}

	
    func setupRoutes() throws {
		
		print("setting up routes")
		//let database = try self.mysql()
		
		/*let queries_handler :SQLCall = { query  in
			
			do {
				try database.raw(query)
			}catch{
				return
			}
			
			return
		}*/
		
		
		/// use this route group for protected routes
		let authed = grouped( TokenAuthenticationMiddleware( UserModel.self ) )
		
		
		get("users", Int.parameter) { req in
			
			let id = try req.parameters.next(Int.self)
			
			guard let user = User.find(id: id) else {
				throw Abort.notFound
			}
			
			
			
			return try makeResponse(encodable: user )
			
		}
		
		
		authed.get("actions") { req in
			
			guard let me = req.user() else {
				throw FlowneyErrors.permissionDenied
			}
			
			let actions = Action.list(user: me.id)
			
			return try makeResponse(encodable: actions )
			
		}
		
		
		
		
		
		
        get("actions", Int.parameter) { req in
			
			let id = try req.parameters.next(Int.self)
			
			guard let action = Action.find(id: id) else {
				throw Abort.notFound
			}
			
			if !Action.userInvolved(action: action) {
				throw FlowneyErrors.permissionDenied
			}
			
			return try makeResponse(encodable: action )
			
        }
		
		
		post("actions","send"){ req in
			
			guard
				let amount = req.data["amount"]?.float,
				let concept = req.data["concept"]?.string,
				let receiver_id = req.data["to"]?.int
			else {
				throw Abort.badRequest
			}
			
			guard let receiver = User.find(id: receiver_id) else {
				throw Abort.notFound
			}
			
			guard let newAction = Action.send(amount, to: receiver, concept: concept) else {
				throw FlowneyErrors.permissionDenied
			}
			
			guard let savedAction = Action.post(newAction) else{
				throw FlowneyErrors.serverError
			}
			
			return try makeResponse(encodable: savedAction)
		}
		
		
		post("actions","receive"){ req in
			
			guard
				let amount = req.data["amount"]?.float,
				let concept = req.data["concept"]?.string,
				let sender_id = req.data["from"]?.int
				else {
					throw Abort.badRequest
			}
			
			guard let sender = User.find(id: sender_id) else {
				throw Abort.notFound
			}
			
			guard let newAction = Action.receive(amount, from: sender, concept: concept) else {
				throw FlowneyErrors.permissionDenied
			}
			
			guard let savedAction = Action.post(newAction) else{
				throw FlowneyErrors.serverError
			}
			
			return try makeResponse(encodable: savedAction)
		}
		
		

        get("plaintext") { req in
			
			//req.method
			//req.uri.path
			guard let xarxa = try Xarxa.find(1) else {
				return MyError.databaseError()
			}
			
			let email = xarxa.trustedEmail
			//let param = try req.parameters.get("param1")
			print(email) // the name of the dog with id 42
			//let result = try database.raw("SELECT @@version")
            return "Recompte popular! \(email)"
        }
		
		get("xarxa") { req in
			
			//let xarxa = try Xarxa.all()
			guard let currentUser = getCurrentUser() else{
				return "not logged in"
			}
			
			let trust = Trust(from: currentUser, to: "pepiot@dasds.com", recursive: 0)
			
			return try makeResponse(encodable: trust)
			
			//let jsonEncoder = JSONEncoder()
			//let jsonData = try jsonEncoder.encode(xarxa)
			
			//return jsonData
		}
		
		bind(path:"xarxa2"){ req -> Trust? in
			
			guard let currentUser = getCurrentUser() else{
				return nil
			}
			
			return Trust(from: currentUser, to: "pepiot@dasds.com", recursive: 0)
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
