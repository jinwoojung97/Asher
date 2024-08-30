//
//  LockType.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import Foundation

public enum LockType {
    case normal
    case newPassword  // 비밀 번호 입력해주세요.
    case checkPassword  // 2번 확인
    case changePassword  // 비밃 번호 바꾸기
    case enterLockScreen
    
    var title: String {
        switch self {
        case .normal, .newPassword, .checkPassword, .enterLockScreen:
            return I18N.enterPassword
        case .changePassword:
            return I18N.enterNewPassword
        }
    }
    
    var subtitle: String {
        switch self {
        case .normal, .newPassword, .enterLockScreen:
            return I18N.enterPasswordSubtitle
        case .changePassword:
            return I18N.enterNewPasswordSubtitle
        case .checkPassword:
            return I18N.enterPasswordAgain
        }
    }
    
    var invalidText: String { I18N.passwordErrorSubtitle }
    
    var pads: [[PadView.PadType]] {
        return [[.number(1), .number(2), .number(3)],
                [.number(4), .number(5), .number(6)],
                [.number(7), .number(8), .number(9)],
                [leftBottomPad, .number(0), .back]]
    }
    
    private var leftBottomPad: PadView.PadType {
        switch self {
        case .normal: return .biometricsAuth
        case .newPassword, .changePassword, .checkPassword, .enterLockScreen: return .cancel
        }
    }
}
