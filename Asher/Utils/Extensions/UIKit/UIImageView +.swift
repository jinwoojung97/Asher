//
//  UIImageView +.swift
//  Core
//
//  Created by chuchu on 2023/07/04.
//

import UIKit

public extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    func load(urlString: String?, placeHolder: UIImage? = nil) {
        guard let urlString,
              let url = URL(string: urlString)
        else {
            self.image = placeHolder
            return
        }
        
        load(url: url)
    }
}
