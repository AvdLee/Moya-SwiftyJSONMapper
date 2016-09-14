import UIKit
import XCTest
import Moya_SwiftyJSONMapper
import Moya

@testable import Moya_SwiftyJSONMapper_Example

class Tests: XCTestCase {

    func testCoreMappingObject() {
        let expectation = expectationWithDescription("This call call a Get API call and returns a GetResponse.")

        var getResponseObject: GetResponse?
        var errorValue: ErrorType?

        let cancellableRequest: Cancellable = stubbedProvider.request(ExampleAPI.GetObject) { (result) -> () in
            switch result {
            case let .Success(response):
                do {
                    getResponseObject = try response.mapObject(GetResponse)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            case let .Failure(error):
                errorValue = error
                expectation.fulfill()
            }
        }

        waitForExpectationsWithTimeout(10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseObject, "We should have a parsed getResponseObject")

            cancellableRequest.cancel()
        }
    }


    func testRxSwiftMappingObject() {
        let expectation = expectationWithDescription("This call call a Get API call and returns a GetResponse through a ReactiveCocoa signal.")

        var getResponseObject: GetResponse?
        var errorValue: ErrorType?

        let disposable = RXStubbedProvider.request(ExampleAPI.GetObject).mapObject(GetResponse).subscribe(onNext: { (response) -> Void in
            getResponseObject = response
        }, onError: { (error) -> Void in
            errorValue = error
            expectation.fulfill()
        }, onCompleted: { () -> Void in
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseObject, "We should have a parsed getResponseObject")

            disposable.dispose()
        }
    }

    func testCoreMappingArray() {
        let expectation = expectationWithDescription("This call call a Get API call and returns a GetResponse.")

        var getResponseArray: [GetResponse]?
        var errorValue: ErrorType?

        let cancellableRequest: Cancellable = stubbedProvider.request(ExampleAPI.GetArray) { (result) -> () in
            switch result {
            case let .Success(response):
                do {
                    getResponseArray = try response.mapArray(GetResponse)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            case let .Failure(error):
                errorValue = error
                expectation.fulfill()
            }
        }

        waitForExpectationsWithTimeout(10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseArray, "We should have a parsed getResponseObject")

            cancellableRequest.cancel()
        }
    }


    func testRxSwiftMappingArray() {
        let expectation = expectationWithDescription("This call call a Get API call and returns a GetResponse through a ReactiveCocoa signal.")

        var getResponseArray: [GetResponse]?
        var errorValue: ErrorType?

        let disposable = RXStubbedProvider.request(ExampleAPI.GetArray).mapArray(GetResponse).subscribe(onNext: { (response) -> Void in
            getResponseArray = response
        }, onError: { (error) -> Void in
            errorValue = error
            expectation.fulfill()
        }, onCompleted: { () -> Void in
            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseArray, "We should have a parsed getResponseObject")

            disposable.dispose()
        }
    }


}
