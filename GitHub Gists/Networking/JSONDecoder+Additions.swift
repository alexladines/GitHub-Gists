//
//  JSONDecoder+Additions.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/22/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation
import Alamofire

// Purpose: Decode any Codable objects
extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        // Check for error in getting data
        guard response.error == nil else {
            print(response.error!)
            return .failure(BackendError.network(error: response.error!)) // See BackendError.swift for errors
        }

        // Check for getting JSON dictionary
        guard let responseData = response.data else {
            print("Did not get any data from API")
            return .failure(BackendError.unexpectedResponse(reason: "Did not get data in response"))
        }

        // Check for API provided error which is in JSON form, not all APIs do this
        if let apiProvidedError = try? self.decode(APIProvidedError.self, from: responseData) {
            return .failure(BackendError.apiProvidedError(reason: apiProvidedError.message))
        }

        // Turn data into expected type
        do {
            let item = try self.decode(T.self, from: responseData)
            return .success(item)
        }
        catch {
            print("Error trying to decode response")
            print(error)
            return .failure(BackendError.parsing(error: error)) // See BackendError.swift for errors
        }

    }
}
