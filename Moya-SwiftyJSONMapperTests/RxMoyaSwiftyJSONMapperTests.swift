//
//  Moya_SwiftyJSONMapperTests.swift
//  MoyaSwiftyJSONMapperTests
//
//  Created by hayato.iida on 2016/09/12.
//  Copyright © 2016年 hayato.iida. All rights reserved.
//

import XCTest
import RxSwift
@testable import RxMoyaSwiftyJSONMapper

class Moya_SwiftyJSONMapperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
     let x =  RXStubbedProvider.request(ExampleAPI.GetObject)
      x.mapObject(GetResponse).subscribe(onNext: { (response) -> Void in
        print(response)
        }, onError: { (error) -> Void in
          print(error)
      })

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
