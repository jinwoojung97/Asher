//
//  UILabel +.swift
//  Core
//
//  Created by chuchu on 11/13/23.
//

import UIKit

public extension UILabel {
    func textColorChange(text: String, color: UIColor?, range: String){
        guard let color else { return }
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }
    
    func textFontChange(text: String, font: UIFont, range: String){
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }
    
    var textSize: CGSize {
        guard let text,
              let font = font,
              case let nsText = text as NSString
        else { return .zero }
        
        return nsText.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func setLineHeight(_ spacing: CGFloat){
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))
        attributedText = attributedString
    }
}
