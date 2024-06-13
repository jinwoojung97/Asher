//
//  CACornerMask.swift
//  Features
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

public extension CACornerMask {
    static var allCorners: CACornerMask {
        return [.topLeft, .topRight, .bottomLeft, .bottomRight]
    }
    
    static var topLeft: CACornerMask {
        return .layerMinXMinYCorner
    }
    
    static var topRight: CACornerMask {
        return .layerMaxXMinYCorner
    }
    
    static var bottomLeft: CACornerMask {
        return .layerMinXMaxYCorner
    }
    
    static var bottomRight: CACornerMask {
        return .layerMaxXMaxYCorner
    }
}
