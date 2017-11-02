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
import ReactiveSwift
import SwiftyJSON

let stubbedProvider =  MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.immediatelyStub)

enum ExampleAPI {
    case GetObject
    case GetArray
}

extension ExampleAPI: JSONMappableTargetType {
    var baseURL: URL { return URL(string: "https://httpbin.org")! }
    var path: String {
        switch self {
        case .GetObject:
            return "/get"
        case .GetArray:
            return "/getarray" // Does not really works, but will work for stubbed response
        }
    }
    var method: Moya.Method {
        return .get
    }
    var parameters: [String: Any]? {
        return nil
    }
    var sampleData: Data {
        switch self {
        case .GetObject:
            return stubbedResponseFromJSONFile(filename: "object_response")
        case .GetArray:
            return stubbedResponseFromJSONFile(filename: "array_response")   
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
    var task: Task {
        return .requestPlain
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    var headers: [String: String]? {
        return nil
    }
}

// Then add an additional request method
// Is not working:
//func requestType<T:ALSwiftyJSONAble>(target: ExampleAPI) -> SignalProducer<T, Moya.Error> {
//    return RCStubbedProvider.request(target).mapObject(target.responseType)
//}

// Works but has al the mapping logic in it, I don't want that!
func requestType<T:ALSwiftyJSONAble>(target: ExampleAPI) -> SignalProducer<T, MoyaError> {
    return stubbedProvider.reactive.request(target).flatMap(FlattenStrategy.latest, { (response) -> SignalProducer<T, MoyaError> in
        do {
            let jsonObject = try response.mapJSON()
            
            guard let mappedObject = T(jsonData: JSON(jsonObject)) else {
                throw MoyaError.jsonMapping(response)
            }
            
            return SignalProducer(value: mappedObject)
        } catch let error {
            return SignalProducer(error: MoyaError.underlying(error as NSError, response))
        }
    })
}

protocol JSONMappableTargetType: TargetType {
    var responseType: ALSwiftyJSONAble.Type { get }
}

private func stubbedResponseFromJSONFile(filename: String, inDirectory subpath: String = "", bundle:Bundle = Bundle.main ) -> Data {
    guard let path = bundle.path(forResource: filename, ofType: "json", inDirectory: subpath) else { return Data() }
    
    if let dataString = try? String(contentsOfFile: path), let data = dataString.data(using: String.Encoding.utf8){
        return data
    } else {
        return Data()
    }
}
