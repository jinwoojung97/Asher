//
//  IndicatorManager.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

import SnapKit

public final class IndicatorManager {
    public static let shared = IndicatorManager()
    private var indicatorView: UIActivityIndicatorView?
    
    private func setIndicatorView(superView: UIView? = nil) {
        guard indicatorView == nil else { return }
        let indicatorView = UIActivityIndicatorView()
        let targetView = superView == nil ?
        UIApplication.shared.window?.rootViewController?.view:
        superView
        
        indicatorView.style = .large
        
        self.indicatorView = indicatorView
        
        targetView?.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func startAnimation(superView: UIView? = nil) {
        DispatchQueue.main.async {
            self.setIndicatorView(superView: superView)
            self.indicatorView?.startAnimating()
        }
    }
    
    public func stopAnimation() {
        DispatchQueue.main.async {
            self.indicatorView?.stopAnimating()
            self.indicatorView?.removeFromSuperview()
            self.indicatorView = nil
        }
    }
}
