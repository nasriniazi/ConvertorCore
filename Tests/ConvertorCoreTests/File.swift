//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-28.
//

import Foundation
import OHHTTPStubs

class StubRequests {
    static let shared = StubRequests()
    private init() {}
    func stubJSONrespone (jsonObject: [String: Any], header: [String: String]?, statusCode: Int32, absoluteStringWord: String) {
    stub(condition: { (urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains(absoluteStringWord) ?? false
        }) { (_) -> HTTPStubsResponse in
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: statusCode, headers: header)
        }
    }
}
