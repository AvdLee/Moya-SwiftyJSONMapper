//
//  Observable+SwiftyJSONMapper.swift
//
//  Created by Antoine van der Lee on 26/01/16.
//  Copyright © 2016 Antoine van der Lee. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

public extension Response {

    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: ALSwiftyJSONAble>(type:T.Type, path: [JSONSubscriptType]) throws -> T {
        let jsonObject = try mapJSON()
        
        let jsonData = JSON(jsonObject)[path]
        guard let mappedObject = T(jsonData: jsonData) else {
            throw Moya.Error.jsonMapping(self)
        }
        
        return mappedObject
    }
    
    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol
    /// If the conversion fails, the signal errors.
    public func mapArray<T: ALSwiftyJSONAble>(type:T.Type, path: [JSONSubscriptType]) throws -> [T] {
        let jsonObject = try mapJSON()
        
        let mappedArray = JSON(jsonObject)[path]
        let mappedObjectsArray = mappedArray.arrayValue.flatMap { T(jsonData: $0) }
        
        return mappedObjectsArray
    }

}
