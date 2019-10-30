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
    case network(error: Error) //Add Documentation
    case unexpectedResponse(reason: String) //Add Documentation
    case parsing(error: Error) //Add Documentation
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String) //Add Documentation
    case authLost(reason: String) //Add Documentation
    case missingRequiredInput(reason: String) //Add Documentation
}

// If endpoint fails, the API provides an error message in JSON form, we have to check for that in JSONDecoder
struct APIProvidedError: Codable {
    let message: String
    // TODO: - Check documentation if there anymore 
}
