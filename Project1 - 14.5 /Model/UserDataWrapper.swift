//
//  UserDataWrapper.swift
//  Project1 - 14.5
//
//  Created by Donat Bajrami on 9.10.21.
//

import Foundation

struct UserDataWrapper <T: Codable>: Codable {
    let data: T
}
