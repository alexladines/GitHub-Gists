//
//  GistRouter.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/21/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation
import Alamofire

// This enum creates the url with HTTP request and any parameters
enum GistRouter: URLRequestConvertible {

    static let baseURLString = "https://api.github.com/" // Found of API guide

    // HTTP Cases
    case getAllPublic
    case getAtPath(String)
    case getMyStarred

    // Create URLRequest
    func asURLRequest() throws -> URLRequest {

        // HTTP Method
        var method: HTTPMethod {
            switch self {
            case .getAllPublic, .getAtPath, .getMyStarred: // Some of these require OAUTH, look at documentation
                return .get
            }
        }

        // Make endpoint
        let url: URL = {
            let relativePath: String
            switch self {
            case .getAllPublic:
                relativePath = "gists/public"
            case .getAtPath(let path):
                // Already have full path so return it
                return URL(string: path)!
            case .getMyStarred:
                relativePath = "gists/starred"
            }

            var url = URL(string: GistRouter.baseURLString)!
            url.appendPathComponent(relativePath)

            return url
        }()

        // Check URL
        print(url)
        
        // No params for now since I just have a .get case

        // Make URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        return urlRequest

    }
}
