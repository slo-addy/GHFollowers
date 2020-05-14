//
//  GFError.swift
//  GHFollowers
//
//  Created by Addison Francisco on 5/7/20.
//  Copyright © 2020 Addman Corp. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "Could not favorite this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
}

