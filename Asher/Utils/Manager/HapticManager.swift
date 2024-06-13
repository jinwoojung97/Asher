//
//  HapticManager.swift
//  Core
//
//  Created by chuchu on 2023/06/28.
//

import UIKit

import Then

public final class HapticManager {
    public static let shared = HapticManager()
    
    private let notification = UINotificationFeedbackGenerator().then {
        $0.prepare()
    }
    
    private var impact: UIImpactFeedbackGenerator?
    
    private let select = UISelectionFeedbackGenerator().then {
        $0.prepare()
    }
    
    public func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notification.notificationOccurred(type)
    }
    
    public func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.impact = UIImpactFeedbackGenerator(style: style)
        impact?.prepare()
        
        impact?.impactOccurred()
    }
    
    public func selection() {
        select.selectionChanged()
    }
}
