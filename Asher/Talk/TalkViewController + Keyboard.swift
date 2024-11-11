//
//  TalkViewController + Keyboard.swift
//  Asher
//
//  Created by chuchu on 11/11/24.
//

import UIKit

import SnapKit

extension TalkView {
    
    @objc
    func adjustOnKeyboard(notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              chatInputView.textView.isFirstResponder else { return }
        let keyboardHeight = self.safeAreaInsets.bottom - keyboardRect.height
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            setInputViewConstraints(height: keyboardHeight)
            
        case UIResponder.keyboardWillHideNotification:
            setInputViewConstraints()
        default: break
        }
    }
    
    private func setInputViewConstraints(height: CGFloat = 0) {
        scrollToBottom()
    }
}
