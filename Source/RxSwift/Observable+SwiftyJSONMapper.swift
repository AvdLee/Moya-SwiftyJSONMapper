//
//  Observable+SwiftyJSONMapper.swift
//
//  Created by Antoine van der Lee on 26/01/16.
//  Copyright © 2016 Antoine van der Lee. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {

    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: ALSwiftyJSONAble>(to type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.map(to: type))
        }
    }

    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: ALSwiftyJSONAble>(to type: [T.Type]) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.map(to: type))
        }
    }
}
