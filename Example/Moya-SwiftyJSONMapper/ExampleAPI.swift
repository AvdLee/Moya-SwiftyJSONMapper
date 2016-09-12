//
//  ExampleAPI.swift
//  Moya-SwiftyJSONMapper
//
//  Created by Antoine van der Lee on 25/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Moya
import Moya_SwiftyJSONMapper
import ReactiveCocoa
import SwiftyJSON

let stubbedProvider =  MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
let RCStubbedProvider = ReactiveCocoaMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
let RXStubbedProvider = RxMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)

enum ExampleAPI {
    case GetObject
    case GetArray
}

extension ExampleAPI: JSONMappableTargetType {
    var baseURL: NSURL { return NSURL(string: "https://httpbin.org")! }
    var path: String {
        switch self {
        case .GetObject:
            return "/get"
        case .GetArray:
            return "/getarray" // Does not really works, but will work for stubbed response
        }
    }
    var method: Moya.Method {
        return .GET
    }
    var parameters: [String: AnyObject]? {
        return nil
    }
    var sampleData: NSData {
        switch self {
        case .GetObject:
            return stubbedResponseFromJSONFile("object_response")
        case .GetArray:
            return stubbedResponseFromJSONFile("array_response")
        }
    }
    var responseType: ALSwiftyJSONAble.Type {
        switch self {
        case .GetObject:
            return GetResponse.self
        case .GetArray:
            return GetResponse.self
        }
    }
  var multipartBody: [MultipartFormData]? {
    return nil
  }
}

// Then add an additional request method
// Is not working:
//func requestType<T:ALSwiftyJSONAble>(target: ExampleAPI) -> SignalProducer<T, Moya.Error> {
//    return RCStubbedProvider.request(target).mapObject(target.responseType)
//}

// Works but has al the mapping logic in it, I don't want that!
func requestType<T: ALSwiftyJSONAble>(target: ExampleAPI) -> SignalProducer<T, Moya.Error> {
    return RCStubbedProvider.request(target).flatMap(FlattenStrategy.Latest, transform: { (response) -> SignalProducer<T, Moya.Error> in
        do {
            let jsonObject = try response.mapJSON()

            guard let mappedObject = T(jsonData: JSON(jsonObject)) else {
                throw Error.JSONMapping(response)
            }

            return SignalProducer(value: mappedObject)
        } catch let error {
            return SignalProducer(error: Moya.Error.Underlying(error as NSError))
        }
    })
}

protocol JSONMappableTargetType: TargetType {
    var responseType: ALSwiftyJSONAble.Type { get }
}

private func stubbedResponseFromJSONFile(filename: String, inDirectory subpath: String = "", bundle: NSBundle = NSBundle.mainBundle() ) -> NSData {
    guard let path = bundle.pathForResource(filename, ofType: "json", inDirectory: subpath) else { return NSData() }
    return NSData(contentsOfFile: path) ?? NSData()
}
