//
//  UITextView +.swift
//  Core
//
//  Created by chuchu on 11/13/23.
//

import UIKit

import SnapKit

public extension UITextView {
    var placeholder: UILabel? {
        subviews
            .filter { $0.tag == 100 }
            .compactMap { $0 as? UILabel }.first
    }
    
    func addPlaceholder(text: String?, color: UIColor?) {
        let placeholder = UILabel().then {
            $0.tag = 100
            $0.text = text
            $0.font = font
            $0.textColor = color
            $0.numberOfLines = 0
        }
        
        addSubview(placeholder)
        
        placeholder.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
}
