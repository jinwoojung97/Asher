//
//  UIApplication +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

//import Toast

public extension UIApplication {
    var safeAreaInset: UIEdgeInsets { window?.safeAreaInsets ?? .zero }
    
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    
    var isLandscape: Bool {
        window?.windowScene?.interfaceOrientation.isLandscape ?? false
    }
    
//    func makeToast(_ message: String?) {
//        guard let superview = window?.rootViewController?.view else { return }
//        let style = ToastStyle().defaultToastStyle()
//        let superviewSize = superview.bounds.size
//        let y = superview.bounds.size.height - (UIApplication.safeAreaInset.bottom + 100)
//        let point = isKeyboardPresented ?
//        CGPoint(x: superviewSize.width / 2.0, y: superviewSize.height / 2.0):
//        CGPoint(x: superviewSize.width / 2.0, y: y)
//        
//        
//        
//        window?.rootViewController?.view.makeToast(message,
//                                                   point: point,
//                                                   title: nil,
//                                                   image: nil,
//                                                   style: style,
//                                                   completion: nil)
//    }
    
//    private func defaultToastStyle() -> ToastStyle {
//        var style = ToastStyle()
//        
//        style.horizontalPadding = 16
//        
//        return style
//    }
//    
//    var tabBarHeight: CGFloat {
//        UIApplication.safeAreaInset.bottom + 78.0
//    }
}
