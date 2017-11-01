import UIKit
import XCTest
import Moya_SwiftyJSONMapper
import Moya

@testable import Moya_SwiftyJSONMapper_Example

class Tests: XCTestCase {
    
    func testCoreMappingObject(){
        let expectation = self.expectation(description: "This call call a Get API call and returns a GetResponse.")
        
        var getResponseObject:GetResponse?
        var errorValue:MoyaError?
        
        let cancellableRequest:Cancellable = stubbedProvider.request(ExampleAPI.GetObject) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    getResponseObject = try response.map(to: GetResponse.self)
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
        var errorValue:MoyaError?
        
        let disposable = stubbedProvider.reactive.request(ExampleAPI.GetObject).map(to: GetResponse.self).on(failed: { (error) in
            errorValue = error
        }, completed: {
            expectation.fulfill()
        }, value: { (response) in
            getResponseObject = response
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
        var errorValue:MoyaError?
        
        let disposable = stubbedProvider.rx.request(ExampleAPI.GetObject)
            .map { respone in
                return try? respone.map(to: GetResponse.self)
            }
            .do(onError: { (error) in
                if let error = error as? MoyaError {
                errorValue = error
                }
            })
            .subscribe(onSuccess: { (response) -> Void in
                getResponseObject = response
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
        var errorValue:MoyaError?
        
        let cancellableRequest:Cancellable = stubbedProvider.request(ExampleAPI.GetArray) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    getResponseArray = try response.map(to: [GetResponse.self])
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
        var errorValue:MoyaError?
        
        let disposable = stubbedProvider.reactive.request(ExampleAPI.GetArray).map(to: [GetResponse.self])
            .on(failed: { (error) in
                errorValue = error
            }, completed: {
                expectation.fulfill()
            }, value: { (response) in
                getResponseArray = response
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
        var errorValue:MoyaError?

        let disposable = stubbedProvider.rx.request(ExampleAPI.GetArray)
            .map { respone in
                return try? respone.map(to: [GetResponse.self])
            }
            .do(onError: { (error) in
                if let error = error as? MoyaError {
                    errorValue = error
                }
            }).subscribe(onSuccess: { (response) in
                getResponseArray = response
                expectation.fulfill()
            })


        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(errorValue, "We have an unexpected error value")
            XCTAssertNotNil(getResponseArray, "We should have a parsed getResponseObject")

            disposable.dispose()
        }
    }
    
    
}
