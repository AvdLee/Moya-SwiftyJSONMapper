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
import ReactiveSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        exampleRequestDirectMapping()
        coreObjectMapping()
        reactiveCocoaObjectMapping()
        rxSwiftObjectMapping()
    }
    
    func exampleRequestDirectMapping(){
        // This instead works, with type definition
        let producer:SignalProducer<GetResponse, MoyaError> = requestType(target: ExampleAPI.GetObject).on(value: { (response) in
            print("Example origin \(response.origin)")
        })
        producer.start()
    }
    
    func coreObjectMapping(){
        stubbedProvider.request(ExampleAPI.GetObject) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let getResponseObject = try response.map(to: GetResponse.self)
                    print(getResponseObject)
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func reactiveCocoaObjectMapping(){
        stubbedProvider.reactive.request(ExampleAPI.GetObject)
            .map(to: GetResponse.self)
            .on(failed: { (error) -> () in
                print(error)
            }) { (response) -> () in
                print(response)
            }.start()
    }
    
    func rxSwiftObjectMapping(){
        let disposeBag = DisposeBag()
        stubbedProvider.rx.request(ExampleAPI.GetObject)
            .map { response in
                return try? response.map(to: GetResponse.self)
            }
            .subscribe(onSuccess: { response in
                print(response ?? "")
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

