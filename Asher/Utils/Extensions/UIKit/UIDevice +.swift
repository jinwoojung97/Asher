//
//  UIDevice +.swift
//  Core
//
//  Created by chuchu on 2023/07/13.
//

import UIKit

public extension UIDevice {
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
