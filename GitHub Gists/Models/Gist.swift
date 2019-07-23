//
//  Gist.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 7/23/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

// Chose struct over class because each individual Gist will not change.


struct Gist: Codable {
    // Nested struct because Owner are always and only part of the Gist struct
    struct Owner: Codable {
        var login: String
        var avatarURL: URL?

        // Match the JSON
        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }

    var id: String
    var gistDescription: String?
    var url: URL
    var owner: Gist.Owner?

    // Match the JSON
    enum CodingKeys: String, CodingKey {
        case id
        case gistDescription = "description"
        case url
        case owner
    }
}
