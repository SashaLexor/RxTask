//
//  Task3ViewController.swift
//  RxTask
//
//  Created by Korzhenko, Alexander on 5/29/17.
//  Copyright © 2017 Korzhenko, Alexander. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Task3ViewController: UIViewController {
    
    @IBOutlet weak var startArgumenttextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    let intervalCurrentValue = Variable(0)
    let result = Variable(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task 3"
        
        startArgumenttextField.rx.text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filter({ (element) -> Bool in
                let intElement = Int(element)
                return intElement != nil
            })
            .map({ (element) -> Int in
                return Int(element)!
            })
            .do(onNext: {
                [weak self] (_) in
                self?.intervalCurrentValue.value = 0
            })
            .flatMapLatest { (_) -> Observable<Int> in
                return Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            }
            .subscribe(onNext: {
                [weak self] (element) in
                self?.intervalCurrentValue.value = element
            })
            .addDisposableTo(disposeBag)
        
        let argument = startArgumenttextField.rx.text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filter({ (element) -> Bool in
                let intElement = Int(element)
                return intElement != nil
            })
            .map({ (element) -> Int in
                return Int(element)!
            })
        
        
        Observable.combineLatest(argument, intervalCurrentValue.asObservable()) { (element, interval) -> Int in
            return element + interval
            }
            .bind(to: result)
            .addDisposableTo(disposeBag)
        
        result.asObservable()
            .map{"\($0)"}
            .bind(to: resultLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
}
