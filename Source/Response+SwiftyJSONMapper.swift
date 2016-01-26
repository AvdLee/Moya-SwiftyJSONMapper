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
    public func mapObject<T: ALSwiftyJSONAble>(type:T.Type) throws -> T {
        let jsonObject = try mapJSON()
        
        guard let mappedObject = T(jsonData: JSON(jsonObject)) else {
            throw Error.JSONMapping(self)
        }
        
        return mappedObject
    }

    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol
    /// If the conversion fails, the signal errors.
    public func mapArray<T: ALSwiftyJSONAble>(type:T.Type) throws -> [T] {
        let jsonObject = try mapJSON()
        
        let mappedArray:JSON = JSON(jsonObject)
        let mappedObjectsArray = mappedArray.arrayValue
            .map({ T(jsonData: $0) }) // Map to T
            .filter({ $0 != nil }) // Filter out failed objects
            .map({ $0! }) // Cast to non optionals array
        
        return mappedObjectsArray
    }

}
