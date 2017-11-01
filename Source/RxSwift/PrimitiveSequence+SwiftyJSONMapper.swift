//
//  PrimitiveSequence+SwiftyJSONMapper.swift
//  Alamofire
//
//  Created by Akshay Bharath on 11/1/17.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/// Extension for processing Responses into Mappable objects through ObjectMapper
extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: ALSwiftyJSONAble>(to type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.map(to: type))
        }
    }
    
    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func map<T: ALSwiftyJSONAble>(to type: [T.Type]) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.map(to: type))
        }
    }
}
