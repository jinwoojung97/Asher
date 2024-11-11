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
        var toastMessgae: Driver<String>
    }
    
    init(input: Input) {
        input.sendButtonTappedWithText
            .compactMap { $0 }
            .bind(onNext: sendMessage)
            .disposed(by: disposeBag)
        
        output = Output(isFrozen: model.isFrozen.asDriver(),
                        toastMessgae: model.toastMessage.asDriverOnErrorEmpty())
    }
    
    private func sendMessage(text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return model.toastMessage.onNext("안 보내짐") }
        print(trimmedText)
    }
    
    private func getAPIKey() {
        let key = Bundle.main.getValue(key: .chatGpt, as: String.self)
        
        print(key)
    }
}

extension Bundle {
    private var apiDictinary: NSDictionary {
        guard let plistURL = Bundle.main.url(forResource: "API", withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: plistURL)
        else { return [:] }
        
        return dictionary
    }
    
    func getValue<T>(key: APIKey, as type: T.Type) -> T? {
        return apiDictinary[key.key] as? T
    }
    
    enum APIKey {
        case chatGpt
        
        var key: String {
            switch self {
            case .chatGpt: "chatGPT"
            }
        }
    }
}
