//
//  Task1ViewController.swift
//  RxTask
//
//  Created by Korzhenko, Alexander on 5/29/17.
//  Copyright © 2017 Korzhenko, Alexander. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Task1ViewController: UIViewController {
    
    @IBOutlet weak var argument1TextField: UITextField!
    @IBOutlet weak var argument2TextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let result = Variable(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Task 1"
        
        let argument1 = argument1TextField.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (element) -> Bool in
                let intElement = Int(element)
                return intElement != nil
            })
            .map({ (element) -> Int in
                return Int(element)!
            })
        
        
        let argument2 = argument2TextField.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (element) -> Bool in
                let intElement = Int(element)
                return intElement != nil
            })
            .map({ (element) -> Int in
                return Int(element)!
            })
        
        
        Observable.combineLatest(argument1, argument2){
            (arg1, arg2) -> Int in
            return arg1 + arg2
            }
            .bind(to: result)
            .addDisposableTo(disposeBag)
        
        result.asObservable()
            .map{"\($0)"}
            .bind(to: resultLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

}
