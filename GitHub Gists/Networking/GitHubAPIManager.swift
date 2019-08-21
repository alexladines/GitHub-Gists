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
}
