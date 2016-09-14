//
//  ExampleAPI.swift
//  Moya-SwiftyJSONMapper
//
//  Created by Antoine van der Lee on 25/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftyJSON
import RxMoya
@testable import RxMoyaSwiftyJSONMapper

let RXStubbedProvider = RxMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)

enum ExampleAPI: JSONMappableTargetType {
  case GetObject
  case GetArray

  var baseURL: NSURL { return NSURL(string: "https://httpbin.org")! }
  var path: String {
    switch self {
    case .GetObject:
      return "/get"
    case .GetArray:
      return "/getarray" // Does not really works, but will work for stubbed response
    }
  }
  var method: RxMoya.Method {
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



protocol JSONMappableTargetType: TargetType {
  var responseType: ALSwiftyJSONAble.Type { get }
}

private func stubbedResponseFromJSONFile(filename: String, inDirectory subpath: String = "", bundle: NSBundle = NSBundle.mainBundle() ) -> NSData {
  guard let path = bundle.pathForResource(filename, ofType: "json", inDirectory: subpath) else { return NSData() }
  return NSData(contentsOfFile: path) ?? NSData()
}
