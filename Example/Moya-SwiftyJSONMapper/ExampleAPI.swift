//
//  ExampleAPI.swift
//  Moya-SwiftyJSONMapper
//
//  Created by Antoine van der Lee on 25/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Moya

let provider: MoyaProvider<ExampleAPI>!

enum ExampleAPI {
    case Get
}

extension ExampleAPI: TargetType {
    var baseURL: NSURL { return NSURL(string: "http://httpbin.org")! }
    var path: String {
        switch self {
        case .Get:
            return "/get"
        }
    }
    var method: Moya.Method {
        return .GET
    }
    var parameters: [String: AnyObject]? {
        return nil
    }
    var sampleData: NSData {
        return NSData()
    }
}