//
//  FontManager.swift
//  CoreInterface
//
//  Created by chuchu on 2023/04/26.
//

import UIKit
import SwiftUI


enum NotoSansKr {
    case black
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semiBold
    case thin
    
    var name: String {
        switch self {
        case .black: return "Black"
        case .bold: return "Bold"
        case .extraBold: return "ExtraBold"
        case .extraLight: return "ExtraLight"
        case .light: return "Light"
        case .medium: return "Medium"
        case .regular: return "Regular"
        case .semiBold: return "SemiBold"
        case .thin: return "Thin"
        }
    }
}

extension UIFont {
    static func notoSans(width: NotoSansKr, size: CGFloat) -> UIFont {
        let fontName = "NotoSansKR-"
        return UIFont(name: fontName + width.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension Font {
    static func notoSans(width: NotoSansKr, size: CGFloat) -> Font {
        let fontName = "NotoSansKR-"
        return .custom(fontName + width.name, size: size)
    }
}


