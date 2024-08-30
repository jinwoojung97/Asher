//
//  LockScreenViewModel.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import RxSwift
import RxRelay
import RxCocoa

final class LockScreenViewModel {
    struct Input {
        let padTap = PublishSubject<PadView.PadType>()
    }
    
    struct Model {
        let lockType = BehaviorRelay<LockType>(value: .normal)
        let password = BehaviorRelay<String>(value: "")
        let didUnlock = PublishSubject<Bool>()
        let pwEnterComplete = PublishSubject<Void>()
        let error = PublishSubject<Void>()
        let checkBiometricsAuth = PublishSubject<Void>()
    }
    
    struct Output {
        let lockType: Driver<LockType>
        let passwordCount: Driver<Int>
        let didUnlock: Driver<Bool>
        let passwordError: Driver<Void>
        let checkBiometricsAuth: Driver<Void>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    var tempPassword = ""
    
    init() {
        modelBind()
        input.padTap
            .bind { [weak self] in self?.padTap(type: $0) }
            .disposed(by: disposeBag)
        
        output = Output(
            lockType: model.lockType.asDriver(),
            passwordCount: model.password.map( { $0.count }).asDriverOnErrorEmpty(),
            didUnlock: model.didUnlock.asDriverOnErrorEmpty(),
            passwordError: model.error.asDriverOnErrorEmpty(),
            checkBiometricsAuth: model.checkBiometricsAuth.asDriverOnErrorEmpty())
    }
    
    private func modelBind() {
        model.pwEnterComplete
            .withLatestFrom(model.lockType) { ($1) }
            .bind { [weak self] in self?.setLockType(type: $0) }
            .disposed(by: disposeBag)
    }
    
    private func setLockType(type: LockType) {
        let password = model.password.value
        let devicePassword = UserDefaultsManager.shared.password
        
        switch type {
        case .normal, .enterLockScreen:
            let isCorrect = devicePassword == password
            isCorrect ? model.didUnlock.onNext(true): model.error.onNext(())
        case .newPassword, .changePassword:
            tempPassword = password
            
            model.lockType.accept(.checkPassword)
        case .checkPassword:
            let isCorrect = tempPassword == password
            if isCorrect {
                model.didUnlock.onNext(true)
                UserDefaultsManager.shared.password = password
            } else {
                model.error.onNext(())
            }
        }
        model.password.accept("")
    }
    
    private func padTap(type: PadView.PadType) {
        let currentPassword = model.password.value
        
        switch type {
        case .number(let num) where currentPassword.count < 4:
            let numString = String(num)
            model.password.accept(currentPassword.appending(numString))
            
            if currentPassword.count == 3 { model.pwEnterComplete.onNext(()) }
        case .cancel:
            model.didUnlock.onNext(false)
        case .biometricsAuth where UserDefaultsManager.shared.useBiometricsAuth:
            model.checkBiometricsAuth.onNext(())
        case .back where currentPassword.count > 0:
            var copyPassword = currentPassword
            
            copyPassword.removeLast()
            model.password.accept(copyPassword)
        default: break
        }
    }
}
