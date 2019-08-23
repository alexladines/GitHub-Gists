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

    func fetchPublicGists(completionHandler: @escaping (Result<[Gist]>) -> Void) {
        Alamofire.request(GistRouter.getAllPublic)
            .responseData { (response) in
                let decoder = JSONDecoder()
                let results: Result<[Gist]> = decoder.decodeResponse(from: response)

                // TODO: finish
                completionHandler(results)
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
}
