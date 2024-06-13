//
//  UITextField +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

public extension UITextField {
    func changePlaceholderTextColor(placeholderText: String, textColor: UIColor?) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: textColor ?? UIColor()])
    }
    
    func maxLength(maxSize: Int, complete: ((Int) -> ())? = nil) {
        guard let text else { return }
        if text.count > maxSize {
            self.text = String(text.prefix(maxSize))
            complete?(maxSize)
        }
    }
}

