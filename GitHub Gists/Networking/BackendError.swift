//
//  BackendError.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/22/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case network(error: Error)
    case unexpectedResponse(reason: String)
    case parsing(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case missingRequiredInput(reason: String)
}
