//
//  ErrorMessage.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 5.9.21.
//

import Foundation

enum DBError: String, Error {
    case invalidURL = "The page requested created an invalid request 🦥."
    case unableToRequest = "Unable to complete your request, check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data that was recieved from the server was invalid. Try again later."
    case unableToFavorite = "There was an error adding this user to the favorites. Please try again!"
    case alreadyInFavorites = "This user is already in the favorites list 🧐"
}
