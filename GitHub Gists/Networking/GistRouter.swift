//
//  GistRouter.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/21/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation
import Alamofire

enum GistRouter: URLRequestConvertible {

    static let baseURLString = "https://api.github.com/"

    // HTTP Cases
    case getAllPublic

    // Create URLRequest
    func asURLRequest() throws -> URLRequest {

        // HTTP Method
        var method: HTTPMethod {
            switch self {
            case .getAllPublic:
                return .get
            }
        }

        // Make endpoint
        let url: URL = {
            let relativePath: String
            switch self {
            case .getAllPublic:
                relativePath = "gists/public"
            }

            var url = URL(string: GistRouter.baseURLString)!
            url.appendPathComponent(relativePath)

            return url
        }()

        // No params for now since I just have a .get case

        // Make URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
