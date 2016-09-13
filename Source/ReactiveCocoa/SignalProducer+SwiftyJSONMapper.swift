//
//  SignalProducer+SwiftyJSONMapper.swift
//
//  Created by Antoine van der Lee on 26/01/16.
//  Copyright © 2016 Antoine van der Lee. All rights reserved.
//

import ReactiveCocoa
import ReactiveMoya
import SwiftyJSON

/// Extension for processing Responses into Mappable objects through ObjectMapper
extension SignalProducerType where Value == Response, Error == ReactiveMoya.Error {

    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: ALSwiftyJSONAble>(type: T.Type) -> SignalProducer<T, Error> {
        return producer.flatMap(.Latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.mapObject(T) }
        }
    }

    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    public func mapArray<T: ALSwiftyJSONAble>(type: T.Type) -> SignalProducer<[T], ReactiveMoya.Error> {
        return producer.flatMap(.Latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.mapArray(T) }
        }
    }
}

/// Maps throwable to SignalProducer
private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, ReactiveMoya.Error> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! Error)
    }
}
