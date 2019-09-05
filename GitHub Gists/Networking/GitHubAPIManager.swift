//
//  GitHubAPIManager.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/21/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation
import Alamofire

class GitHubAPIManager {
    static let shared = GitHubAPIManager()

    var isLoadingOAuthToken = false

    let clientID: String = "1234567890"
    let clientSecret: String = "abcdefghijkl"

    func clearCache() {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
    
    func printPublicGists() {
        Alamofire.request(GistRouter.getAllPublic)
            .responseString { (response) in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }

                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
    }

    func fetchPublicGists(pageToLoad: String?, completionHandler: @escaping (Result<[Gist]>, String?) -> Void) {
        if let urlString = pageToLoad {
            self.fetchPublicGistsHelper(GistRouter.getAtPath(urlString), completionHandler: completionHandler)
        }
        else {
            self.fetchPublicGistsHelper(GistRouter.getAllPublic, completionHandler: completionHandler)
        }
    }

    func fetchPublicGistsHelper(_ urlRequest: URLRequestConvertible, completionHandler: @escaping (Result<[Gist]>, String?) -> Void) {
        Alamofire.request(urlRequest)
            .responseData { (response) in
                let decoder = JSONDecoder()
                let result: Result<[Gist]> = decoder.decodeResponse(from: response)
                let nextPage = self.parseNextPageFromHeaders(response: response.response)
                completionHandler(result, nextPage)
        }
    }


    // Get image from each Gist
    func imageFrom(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        Alamofire.request(url)
            .responseData { (response) in
                guard let data = response.data else {
                    completionHandler(nil, response.error)
                    return
                }

                let image = UIImage(data: data)
                completionHandler(image, nil)
        }
    }

    // Get the next page header
    private func parseNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        guard let linkHeader = response?.allHeaderFields["Link"] as? String else {
            return nil
        }

        // looks like: <https://...?page=2>; rel="next", <https://...?page=6>; rel="last"
        // so split on ","

        let components = linkHeader.components(separatedBy: ",")

        // now we have separate lines like '<https://...?page=2>; rel="next"'

        for item in components {
            // see if it's next
            let rangeOfNext = item.range(of: "rel=\"next\"", options: [])

            guard rangeOfNext != nil else {
                continue
            }

            // this is the "next" item, extract the URL
            let rangeOfPaddedURL = item.range(of: "<(.*)>;", options: .regularExpression, range: nil, locale: nil)

            guard let range = rangeOfPaddedURL else {
                return nil
            }

            // strip off the < and >;
            let start = item.index(range.lowerBound, offsetBy: 1)
            let end = item.index(range.upperBound, offsetBy: -2)
            let trimmedSubstring = item[start..<end]
            return String(trimmedSubstring)
        }

        return nil
    }
}

// MARK: - Basic Auth
extension GitHubAPIManager {
    // Just to see the error I get with auth
    func printMyStarredGistsWithNoBasicAuth() {
        Alamofire.request(GistRouter.getMyStarred)
            .responseString { (response) in
                guard let receivedString = response.result.value else {
                    print("Didn't get a string in the response")
                    return
                }


                // Curious about the headers
                print(response.response.debugDescription)
                // See what error we get
                print(response.response?.allHeaderFields["Status"] as! String)

                print(receivedString)
        }
    }

    func printMyStarredGistsWithBasicAuth() {
        // TODO: implement
        
    }
}

// MARK: - OAuth
// 1. Redirect users to request GitHub access
// 2. GitHub redirects back to your site (app for us) with a code
// 3. Exchange the code for an access token
// 4. Use the access token to access the API
extension GitHubAPIManager {

    func hasOAuthToken() -> Bool {
        return false
    }

    func URLToStartOAuth2Login() -> URL? {
        // TODO: implement
        // TODO: get and print starred gists
        let authPath: String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(clientID)&scope=gist&state=TEST_STATE"
        return URL(string: authPath)
        return nil
    }

    func printMyStarredGistsWithOAuth2() {
        Alamofire.request(GistRouter.getMyStarred)
            .responseString { (response) in
                guard let receivedString = response.result.value else {
                    print(response.result.error!)
                    return
                }

                print(receivedString)
        }
    }
}
