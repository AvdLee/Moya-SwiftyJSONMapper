import UIKit
import XCTest
import Moya_SwiftyJSONMapper
import Moya

@testable import Moya_SwiftyJSONMapper_Example

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCoreMappingObject(){
        let expectation = expectationWithDescription("This call call a Get API call and returns a GetResponse.")
        
        var getResponseObject:GetResponse?
        var errorValue:ErrorType?
        
        let cancellableRequest:Cancellable = provider.request(ExampleAPI.Get) { (result) -> () in
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
    
}
