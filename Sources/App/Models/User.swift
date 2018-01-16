//
//  User.swift
//  Recompte
//
//  Created by Daniel Valls Estella on 12/1/18.
//

import Foundation

typealias Id = String
typealias Email = String

struct User: Codable{
	let id :Id
	let name :String
	let email :Email
}


