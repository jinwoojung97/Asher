//
//  UIScrollView +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit


public extension UIScrollView {
    func scrollsToBottom() {
        let y = contentSize.height - bounds.height + contentInset.bottom
        let bottomOffset = CGPoint(x: 0, y: max(y, 0))
        
        setContentOffset(bottomOffset, animated: true)
    }
}
