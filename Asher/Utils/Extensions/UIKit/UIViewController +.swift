//
//  UIViewController +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

public extension UIViewController {
    func presentAlertController(style: UIAlertController.Style = .alert,
                                title: String? = nil,
                                message: String? = nil,
                                options: (title: String, style: UIAlertAction.Style)...,
                                animated: Bool = true,
                                completion: ((String) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)
        
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option.title,
                                                    style: option.style,
                                                    handler: { _ in
                completion?(options[index].title)
            }))
        }
        
        present(alertController, animated: animated)
    }
}
