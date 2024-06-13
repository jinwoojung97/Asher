//
//  UIView +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

public extension UIView {
    func addShadow(
        offset: CGSize,
        color: UIColor = .black,
        opacity: Float = 0.5,
        blur: CGFloat = 5.0) {
            
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
    }
    
    func addCornerRadius(radius: CGFloat,
                         _ maskedCorners: CACornerMask = .allCorners) {
        
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
    
    func fadeInOut(_ duration: TimeInterval = 0.25,
                   startAlpha: CGFloat = 1.0,
                   completion: (()->())? = nil) {
        UIView.animate(withDuration: duration) {
            self.alpha = abs(startAlpha - 1.0)
        } completion: { _ in
            completion?()
        }
    }
    
    func addBorder(color: UIColor?, width: CGFloat = 1) {
        layer.borderColor = color?.cgColor
        layer.borderWidth = width
    }
    
    func shakeAnimation(completion: (() -> ())? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        
        layer.add(animation, forKey: "shake")
        
        completion?()
    }
    
    func setBackgroundWithAnimation(color: UIColor?) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = color
        }
    }
}
