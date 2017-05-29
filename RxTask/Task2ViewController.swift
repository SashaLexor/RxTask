//
//  Task2ViewController.swift
//  RxTask
//
//  Created by Korzhenko, Alexander on 5/29/17.
//  Copyright © 2017 Korzhenko, Alexander. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Task2ViewController: UIViewController {
    
    @IBOutlet weak var argumentTextField: UITextField!
    @IBOutlet weak var performOperationButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var result2Label: UILabel!
    
    let result = Variable(0)
    let result2 = Variable(0)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task 2"
        
        performOperationButton.rx.tap.asObservable()
            .flatMapLatest { (_) -> Observable<Int> in
                return Observable.create({
                    observer -> Disposable in
                    if let text = self.argumentTextField.text, let arg = Int(text) {
                        observer.onNext(arg)
                    }
                    return Disposables.create {}
                })
            }
            .scan(0){$0 + $1}
            .bind(to: result)
            .addDisposableTo(disposeBag)
        
        result.asObservable()
            .map{"\($0)"}
            .bind(to: resultLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        
        argumentTextField.rx.text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filter({ (element) -> Bool in
                let intElement = Int(element)
                return intElement != nil
            })
            .map({ (element) -> Int in
                return Int(element)!
            })
            .sample(performOperationButton.rx.tap)
            .bind(to: result2)
            .addDisposableTo(disposeBag)
        
        result2.asObservable()
            .map{"\($0)"}
            .bind(to: result2Label.rx.text)
            .addDisposableTo(disposeBag)
    }
    
}
