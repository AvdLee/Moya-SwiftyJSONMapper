import UIKit
import XCTest
import Moya_SwiftyJSONMapper
import Moya

@testable import Moya_SwiftyJSONMapper_Example

class Tests: XCTestCase {
    
    func testCoreMappingObject(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse.")
        
        var getResponseObject:GetResponse?
        var errorValue:Moya.Error?
        
        let cancellableRequest:Cancellable = stubbedProvider.request(ExampleAPI.GetObject) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    getResponseObject = try response.mapObject(type: GetResponse.self)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            case let .failure(error):
                errorValue = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseObject, "We should have a parsed getResponseObject")
            
            cancellableRequest.cancel()
        }
    }
    
    func testReactiveCocoaMappingObject(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse through a ReactiveCocoa signal.")
        
        var getResponseObject:GetResponse?
        var errorValue:Moya.Error?
        
        let disposable = RCStubbedProvider.request(token: ExampleAPI.GetObject).mapObject(type: GetResponse.self).on(value: { (response) in
            getResponseObject = response
        }, failed: { (error) in
            errorValue = error
        }, completed: {
            expectation.fulfill()
        }).start()
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseObject, "We should have a parsed getResponseObject")
            
            disposable.dispose()
        }
    }
    
    func testRxSwiftMappingObject(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse through a ReactiveCocoa signal.")
        
        var getResponseObject:GetResponse?
        var errorValue:Moya.Error?
        
        let disposable = RXStubbedProvider.request(ExampleAPI.GetObject).mapObject(type: GetResponse.self).do(onError: { (error) in
            if let error = error as? Moya.Error {
                errorValue = error
            }
        }).subscribe(onNext: { (response) -> Void in
            getResponseObject = response
        }, onCompleted: { () -> Void in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseObject, "We should have a parsed getResponseObject")
            
            disposable.dispose()
        }
    }
    
    func testCoreMappingArray(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse.")
        
        var getResponseArray:[GetResponse]?
        var errorValue:Moya.Error?
        
        let cancellableRequest:Cancellable = stubbedProvider.request(ExampleAPI.GetArray) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    getResponseArray = try response.mapArray(type: GetResponse.self)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            case let .failure(error):
                errorValue = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseArray, "We should have a parsed getResponseObject")
            
            cancellableRequest.cancel()
        }
    }
    
    func testReactiveCocoaMappingArray(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse through a ReactiveCocoa signal.")
        
        var getResponseArray:[GetResponse]?
        var errorValue:Moya.Error?
        
        let disposable = RCStubbedProvider.request(token: ExampleAPI.GetArray).mapArray(type: GetResponse.self)
            .on(value: { (response) in
                getResponseArray = response
            }, failed: { (error) in
                errorValue = error
            }, completed: {
                expectation.fulfill()
            }).start()
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseArray, "We should have a parsed getResponseObject")
            
            disposable.dispose()
        }
    }
    
    func testRxSwiftMappingArray(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse through a ReactiveCocoa signal.")
        
        var getResponseArray:[GetResponse]?
        var errorValue:Moya.Error?
        
        let disposable = RXStubbedProvider.request(ExampleAPI.GetArray).mapArray(type: GetResponse.self).do(onError: { (error) in
            if let error = error as? Moya.Error {
                errorValue = error
            }
        }).subscribe(onNext: { (response) in
            getResponseArray = response
        }, onCompleted: {
            expectation.fulfill()
        })
    
        
        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseArray, "We should have a parsed getResponseObject")
            
            disposable.dispose()
        }
    }
    
    
}
