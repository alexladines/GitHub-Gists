//
//  BackendError.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/22/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

// MARK: - Possible Errors
enum BackendError: Error {
    // TODO: - Check documentation if there anymore 
    case network(error: Error) 
    case unexpectedResponse(reason: String)
    case parsing(error: Error) // TODO: - Check documentation if there anymore 
    case apiProvidedError(reason: String) // TODO: - Check documentation if there anymore 
    case authCouldNot(reason: String) // TODO: - Check documentation if there anymore 
    case authLost(reason: String) // TODO: - Check documentation if there anymore 
    case missingRequiredInput(reason: String) // TODO: - Check documentation if there anymore 
}

// If endpoint fails, the API provides an error message in JSON form, we have to check for that in JSONDecoder
struct APIProvidedError: Codable {
    let message: String
    // TODO: - Check documentation if there anymore 
}
