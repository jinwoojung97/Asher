//
//  ChatInputVIewModel.swift
//  Asher
//
//  Created by chuchu on 11/11/24.
//

import Foundation

import RxSwift
import RxCocoa

struct ChatInputViewModel {
    
    var model = Model()
    var input: Input?
    var output: Output?
    var disposeBag = DisposeBag()
    
    struct Model {
        let isFrozen = BehaviorRelay<Bool>(value: false)
        let toastMessage = PublishSubject<String>()
        let sendMessage = PublishSubject<String>()
    }
    
    struct Input {
        var sendButtonTappedWithText: Observable<String?>
    }
    
    struct Output {
        var isFrozen: Driver<Bool>
    }
    
    init(input: Input) {
        input.sendButtonTappedWithText
            .bind { [self] text in
                print(text)
                self.getAPIKey()
            }
            .disposed(by: disposeBag)
        
        output = Output(isFrozen: model.isFrozen.asDriver())
    }
    
    private func getAPIKey() {
        guard let plistURL = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: plistURL),
        let apikey = dictionary["chatGPT"] else { return }
        
        print(apikey)
    }
}

