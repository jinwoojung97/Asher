//
//  LockScreenViewController.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import UIKit

import RxSwift

public final class LockScreenViewController: UIViewController {
    var lockScreenView: LockScreenView!
    
    let type: LockType!
    let viewModel = LockScreenViewModel()
    public let auth = BiometricsAuthManager()
    let disposeBag = DisposeBag()
    
    public var unlockAction: ((Bool) -> ())? = nil
    
    public init(type: LockType) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        viewModel.model.lockType.accept(type)
        let lockScreenView = LockScreenView(viewModel: viewModel)
        
        self.lockScreenView = lockScreenView
        self.view = lockScreenView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setBiometricsAuth()
        bind()
    }
    
    private func setBiometricsAuth() {
        if type == .normal && UserDefaultsManager.shared.useBiometricsAuth {
            auth.delegate = self
            auth.execute()
        }
    }
    
    private func bind() {
        viewModel.output?.didUnlock
            .drive { [weak self] in
                self?.unlockAction?($0)
                self?.dismiss(animated: true) }
            .disposed(by: disposeBag)
        
        viewModel.output?.checkBiometricsAuth
            .drive { [weak self] _ in self?.auth.execute() }
            .disposed(by: disposeBag)
    }
    
    deinit { print(description, "deinit") }
}

extension LockScreenViewController: AuthenticateStateDelegate {
    public func didUpdateState(_ state: BiometricsAuthManager.AuthenticationState) {
        switch state {
        case .loggedIn:
            unlockAction?(true)
            dismiss(animated: true)
        case .fail(let error):
            print(error)
        }
    }
}
