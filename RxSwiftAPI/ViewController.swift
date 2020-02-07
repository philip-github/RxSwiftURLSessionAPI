//
//  ViewController.swift
//  RxSwiftAPI
//
//  Created by Philip Twal on 2/7/20.
//  Copyright © 2020 Philip Twal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        callAPI().subscribe(onNext: { (itemModel) in
            print(itemModel.first?.body)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
        }.disposed(by: disposeBag)
    }

    // function for URLSession tasks
    public func callAPI() -> Observable<[ItemModel]>{
        
        Observable<[ItemModel]>.create { (observer) in
        
            URLSession.shared.dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/posts")!) { (data, response, error) in
                
                do{
                    let model = try JSONDecoder.init().decode([ItemModel].self, from: data!)
                    observer.onNext(model)
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
            }.resume()
            let disposable = Disposables.create()
            return disposable
        }
    }
}
