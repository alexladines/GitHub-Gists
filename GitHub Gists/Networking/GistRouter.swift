//
//  GistRouter.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 7/23/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

// This router class is responsible for creating the URL requests and stop our API manager from getting too crazy.
import Foundation
import Alamofire

enum GistRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com/"

    case getPublic

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getPublic:
                return .get
            }
        }

        let url: URL = {
            let relativePath: String
            switch self {
            case .getPublic:
                relativePath = "gists/public"
            }

            var url = URL(string: GistRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()

        // no params to send with this request so ignore them for now

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
