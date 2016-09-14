//
//  ViewController.swift
//  Moya-SwiftyJSONMapper
//
//  Created by Antoine van der Lee on 01/26/2016.
//  Copyright (c) 2016 Antoine van der Lee. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        coreObjectMapping()
        rxSwiftObjectMapping()
    }


    func coreObjectMapping() {
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
    }


    func rxSwiftObjectMapping() {
        let disposeBag = DisposeBag()
        RXStubbedProvider.request(ExampleAPI.GetObject).mapObject(GetResponse).subscribe(onNext: { (response) -> Void in
            print(response)
        }, onError: { (error) -> Void in
            print(error)
        }).addDisposableTo(disposeBag)
    }
}
