//
//  GitHubAPIManager.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 7/23/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation
import Alamofire

class GitHubAPIManager {
    // Only 1 GitHub API so it is okay to use a shared instance
    static let shared = GitHubAPIManager()

    func printPublicGists() {
        // TODO: implement
        Alamofire.request(GistRouter.getPublic)
            .responseString { (response) in
                if let receivedString = response.result.value {
                    print(receivedString)
                }
        }
    }
}
