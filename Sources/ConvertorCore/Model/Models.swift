//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-20.
//

import Foundation

public struct Models:Codable{
    public struct SimpleResponse<T>:Codable where T : Codable {
        public var status : String?
        public var data : T?
        public init(status:String,data:T) {
            self.status = status
            self.data = data
        }
        
    }
    public struct serverErrorResponse:Codable {
        var type:String
        var message:String
    }
    public struct GetPrice:Codable{
        public var price:String
        public var timestamp:Double
        public init(price:String, timeStamp:Double){
            self.price = price
            self.timestamp = timeStamp
        }
    }
    
}
/*
 {
 "status": "success",
 "data": {
 "price": "24526.966522901377",
 "timestamp": 167687x6580
 }
 }
 */
/*
 {
 "status": "fail",
 "type": "COIN_NOT_FOUND",
 "message": "Coin not found"
 }
 */
