//
//  Confiances.swift
//  App
//
//  Created by Daniel Valls Estella on 14/12/17.
//

struct Trust: Encodable{
	let from: User
	let to: Email
	let recursive: Int
}





func addTrustedAccount(email :String, to user :User, recursive :Int = 0) throws{
	
	let newTrust = Xarxa(trustedEmail: email, recursive: recursive)
	try newTrust.save()
}

func addTrustedAccount(email :String, recursive :Int = 0) throws{
	guard let user = getCurrentUser() else{
		print("Error no current user")
		return
	}
	
	try addTrustedAccount(email: email, to: user, recursive: recursive)
}
