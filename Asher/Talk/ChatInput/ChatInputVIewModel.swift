//
//  ChatInputVIewModel.swift
//  Asher
//
//  Created by chuchu on 11/11/24.
//

import Foundation

import RxSwift
import RxCocoa
import ChatGPTSwift

struct ChatInputViewModel {
    
    var model = Model()
    var input: Input?
    var output: Output?
    var disposeBag = DisposeBag()
    
    let chatGpt = ChatGPTAPI(apiKey: DataSource.gptKey)
    
    struct Model {
        let isFrozen = BehaviorRelay<Bool>(value: false)
        let toastMessage = PublishSubject<String>()
        let sendMessage = PublishSubject<String>()
        let updateTableView = PublishSubject<Void>()
    }
    
    struct Input {
        var sendButtonTappedWithText: Observable<String?>
    }
    
    struct Output {
        var isFrozen: Driver<Bool>
        var toastMessgae: Driver<String>
        var updateTableView: Driver<Void>
    }
    
    init(input: Input) {
        input.sendButtonTappedWithText
            .compactMap { $0 }
            .bind(onNext: sendMessage)
            .disposed(by: disposeBag)
        
        output = Output(isFrozen: model.isFrozen.asDriver(),
                        toastMessgae: model.toastMessage.asDriverOnErrorEmpty(),
                        updateTableView: model.updateTableView.asDriverOnErrorEmpty())
    }
    
    private func sendMessage(text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return model.toastMessage.onNext("메세지를 입력해 주세요!") }
        
        DataSource.messages.append(Message(content: text))
        requestAPI(text: text)
        model.updateTableView.onNext(())
    }
    
    private func requestAPI(text: String) {
        Task {
          do {
              let message = try await chatGpt.sendMessage(
                text: text,
                model: .gpt_hyphen_3_period_5_hyphen_turbo,
                systemText: DataSource.systemText
              )
              DataSource.messages.append(Message(content: message, isReply: true))
              model.updateTableView.onNext(())
          } catch {
            print(error.localizedDescription)
          }
        }
    }
}

extension Bundle {
    var apiDictinary: NSDictionary {
        guard let plistURL = Bundle.main.url(forResource: "Keys", withExtension: "plist"),
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
            case .chatGpt: "chatGpt"
            }
        }
    }
}
