//
//  BiometricsAuthManager.swift
//  Core
//
//  Created by chuchu on 2023/06/08.
//

import LocalAuthentication

public protocol AuthenticateStateDelegate: AnyObject {
    /// loggedIn상태인지 loggedOut 상태인지 표출
    func didUpdateState(_ state: BiometricsAuthManager.AuthenticationState)
}

public final class BiometricsAuthManager {
    
    public static func biometricType() -> LABiometryType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        case .opticID:
            if #available(iOS 17.0, *) { return .opticID }
            else { return .faceID }
        @unknown default:
            fatalError()
        }
    }
    
    public enum AuthenticationState {
        case loggedIn
        case fail(AuthError)
    }
    
    public enum AuthError {
        case userDenied
        case unkowned(String)
    }
    
    public weak var delegate: AuthenticateStateDelegate?
    private var context = LAContext()
    
    public init() {
        configure()
    }
    
    private func configure() {
        /// 생체 인증이 실패한 경우, Username/Password를 입력하여 인증할 수 있는 버튼에 표출되는 문구
    }
    
    public func execute() {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your account"
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason) { [weak self] isSuccess, error in
                    DispatchQueue.main.async {
                        if isSuccess {
                            self?.delegate?.didUpdateState(.loggedIn)
                        } else {
                            self?.emitError(error: error as? NSError)
                        }
                    }
                }
        } else {
            emitError(error: error)
        }
    }
    
    private func emitError(error: NSError?)  {
        switch error?.code {
        case -6: delegate?.didUpdateState(.fail(.userDenied))
        default:
            let errorMsg = error?.localizedDescription ?? "Failed to authenticate"
            delegate?.didUpdateState(.fail(.unkowned(errorMsg)))
        }
        
        print(#function, error)
    }
}
