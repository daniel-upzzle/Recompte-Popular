//
//  User+Auth.swift
//  RecomptePackageDescription
//
//  Created by Daniel Valls Estella on 15/1/18.
//

import AuthProvider

extension UserModel: TokenAuthenticatable {
	public typealias TokenType = TokenModel
}


extension Request {
	func user() -> User? {
		
		do{
			let model : UserModel = try auth.assertAuthenticated()
			return model.data
		}catch{
			return nil
		}
		
		
	}
}
