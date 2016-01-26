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

  /// Maps data received from the signal into an object which implements the Mappable protocol.
  /// If the conversion fails, the signal errors.
  public func mapObject<T: Mappable>() throws -> T {
    guard let object = Mapper<T>().map(try mapJSON()) else {
      throw Error.JSONMapping(self)
    }
   return object
  }

  /// Maps data received from the signal into an array of objects which implement the Mappable
  /// protocol.
  /// If the conversion fails, the signal errors.
  public func mapArray<T: Mappable>() throws -> [T] {
    guard let objects = Mapper<T>().mapArray(try mapJSON()) else {
      throw Error.JSONMapping(self)
    }
    return objects
  }

}
