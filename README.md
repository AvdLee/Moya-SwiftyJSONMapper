# Moya-SwiftyJSONMapper

[![Version](https://img.shields.io/cocoapods/v/Moya-SwiftyJSONMapper.svg?style=flat)](http://cocoapods.org/pods/Moya-SwiftyJSONMapper)
[![License](https://img.shields.io/cocoapods/l/Moya-SwiftyJSONMapper.svg?style=flat)](http://cocoapods.org/pods/Moya-SwiftyJSONMapper)
[![Platform](https://img.shields.io/cocoapods/p/Moya-SwiftyJSONMapper.svg?style=flat)](http://cocoapods.org/pods/Moya-SwiftyJSONMapper)


## Installation

Moya-SwiftyJSONMapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Moya-SwiftyJSONMapper"
```

The subspec if you want to use the bindings over RxSwift.

```ruby
pod "Moya-SwiftyJSONMapper/RxSwift"
```

And the subspec if you want to use the bindings over ReactiveCocoa.

```ruby
pod "Moya-SwiftyJSONMapper/ReactiveCocoa"
```

## Usage

### Example project
To run the example project, clone the repo, and run `pod install` from the Example directory first. It includes sample code and unit tests.


### Model definitions
Create a `Class` or `Struct` which implements the `Mappable` protocol.

```swift
import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

final class GetResponse : ALSwiftyJSONAble {
    
    let url:NSURL?
    let origin:String
    let args:[String: String]?
    
    required init?(jsonData:JSON){
        self.url = jsonData["url"].URL
        self.origin = jsonData["origin"].stringValue
        self.args = jsonData["args"].object as? [String : String]
    }
    
}
```

### 1. Without RxSwift or ReactiveCocoa
```swift
stubbedProvider.request(ExampleAPI.GetObject) { (result) -> () in
    switch result {
    case let .Success(response):
        do {
            let getResponseObject = try response.mapObject(GetResponse)
            print(getResponseObject)
        } catch {
            print(error)
        }
    case let .Failure(error):
        print(error)
    }
}
```

### 2. With ReactiveCocoa
```swift
RCStubbedProvider.request(ExampleAPI.GetObject).mapObject(GetResponse).on(failed: { (error) -> () in
    print(error)
}) { (response) -> () in
    print(response)
}.start()
```

### 3. With RxSwift
```swift
let disposeBag = DisposeBag()

RXStubbedProvider.request(ExampleAPI.GetObject).mapObject(GetResponse).subscribe(onNext: { (response) -> Void in
    print(response)
}, onError: { (error) -> Void in
    print(error)
}).addDisposableTo(disposeBag)
```

## ObjectMapper
If you're using [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper), see [Moya-ObjectMapper](https://github.com/ivanbruel/Moya-ObjectMapper) which inspired me to create this one.

## Author

Antoine van der Lee 

Mail: [info@avanderlee.com](mailto:info@avanderlee.com)  
Home: [www.avanderlee.com](https://www.avanderlee.com)  
Twitter: [@twannl](https://www.twitter.com/twannl)
## License

Moya-SwiftyJSONMapper is available under the MIT license. See the LICENSE file for more info.
