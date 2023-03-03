//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-28.
//

import Foundation
class JSONMocking {
    static let shared = JSONMocking()
    private init() {}
    let fakeBitCoinPrice: [String: Any] = [
        "price": "24526.966522901377",
        "timestamp": 1677432780,
    ]
}

/*
{
    "status": "success",
    "data": {
        "price": "24526.966522901377",
        "timestamp": 1677432780
    }
}
*/
