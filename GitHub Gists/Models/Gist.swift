//
//  Gist.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/21/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

// Look at relevant .json file
struct Gist: Codable {

    // Owner structs are only part of Gist structs
    struct Owner: Codable {
        var login: String // If there is an owner, then there is a login
        var avatarURL: URL? // TODO: - Add more

        // Use CodingKeys to match JSON
        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url" // TODO: - Add more
        }
    }

    var url: URL
    var id: String
    var gistDescription: String? // These two values are optionals because when creating one, they wont exist yet.
    var owner: Gist.Owner?

    // Use CodingKeys to match JSON
    enum CodingKeys: String, CodingKey {
        case url
        case id
        case gistDescription = "description"
        case owner // TODO: - Add more
    }

}
