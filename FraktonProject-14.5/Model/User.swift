//
//  User.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 3.9.21.
//

import Foundation

struct User: Codable, Hashable {
    var id: Int
    var email: String
    var firstName: String
    var lastName: String
    var avatar: String
    var fullName: String? {
      return "\(firstName) \(lastName)"
    }
}
