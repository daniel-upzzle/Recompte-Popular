//
//  User+Auth.swift
//  RecomptePackageDescription
//
//  Created by Daniel Valls Estella on 15/1/18.
//

import AuthProvider
import JWT
import JWTProvider

/*
extension UserModel: TokenAuthenticatable {
	
	public typealias TokenType = UserModel
	
	static func authenticate(_ token: Token) throws -> User {
		let jwt = try JWT(token: token.string)
		try jwt.verifySignature(using: RS256(key: "TeK4tvRl8NwodQbMBY-xGRbgkgvdCW6yBg5AMsqXhFoQBCGGyXZc58-Ds1D9ttTj".makeBytes()))
		let time = ExpirationTimeClaim(date: Date())
		try jwt.verifyClaims([time])
		guard let userId = jwt.payload.object?[SubjectClaim.name]?.string else { throw AuthenticationError.invalidCredentials }
		guard let user = try UserModel.makeQuery().filter("id", userId).first() else { throw AuthenticationError.invalidCredentials }
		return user.data
	}
}
*/

class Claims: JSONInitializable {
	var subjectClaimValue : String
	var expirationTimeClaimValue : Double
	public required init(json: JSON) throws {
		guard let subjectClaimValue = try json.get(SubjectClaim.name) as String? else {
			throw AuthenticationError.invalidCredentials
		}
		self.subjectClaimValue = subjectClaimValue
		
		guard let expirationTimeClaimValue = try json.get(ExpirationTimeClaim.name) as String? else {
			throw AuthenticationError.invalidCredentials
		}
		self.expirationTimeClaimValue = Double(expirationTimeClaimValue)!
		
	}
}


extension UserModel: PayloadAuthenticatable {


	
	typealias PayloadType = Claims
	
	static func authenticate(_ payload: Claims) throws -> UserModel {
		if payload.expirationTimeClaimValue < Date().timeIntervalSince1970 {
			throw AuthenticationError.invalidCredentials
		}
		
		let userId = payload.subjectClaimValue
		guard let user = try UserModel.makeQuery()
			.filter(idKey, userId)
			.first()
			else {
				throw AuthenticationError.invalidCredentials
		}
		
		return user
	}
}


extension Request {
	
	// Must be called only on authorized requests
	var user: User {
		get {
			do{
				let model : UserModel = try auth.assertAuthenticated()
				return model.data
			}catch{
				print("ERROR getting user from unauthenticated request")
				return User(id: "0", name: "0", email: "0")
			}
		}
	}
	
	/*
	func user() -> User? {
		
		do{
			let model : UserModel = try auth.assertAuthenticated()
			return model.data
		}catch{
			return nil
		}
		
		
	}*/
}
