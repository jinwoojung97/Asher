//
//  RootViewController.swift
//  Asher
//
//  Created by chuchu on 6/10/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import SwiftUI

final class MainNavigationViewController: UINavigationController {
    let rootViewController = RootViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        setViewControllers([rootViewController], animated: false)
    }
}

public final class RootViewController: UITabBarController {
    let firstVc = UIHostingController(rootView: HomeView())
    let secondVc = TestNavigationViewController(color: .green)
    let thirdVc = TestNavigationViewController(color: .yellow)
    
    let disposeBag = DisposeBag()
    
    var customTabBar: CustomTabBar!
    
    public override func loadView() {
        super.loadView()
        
        tabBar.isHidden = true
        setViewControllers([firstVc, secondVc, thirdVc], animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    private func commonInit() {
        setTabbar()
        setTabbarBind()
        setUIViewAppearance()
    }
    
    private func setTabbar() {
        self.customTabBar = CustomTabBar()
        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints {
            let bottomInset = UIApplication.shared.safeAreaInset.bottom
            
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(bottomInset + 75)
        }
    }
    
    private func setTabbarBind() {
        customTabBar.tabbarStackView.arrangedSubviews.enumerated().forEach { index, subview in
            let tapGesture = UITapGestureRecognizer()
            
            subview.addGestureRecognizer(tapGesture)
            
            tapGesture.rx.event
                .do { [weak self] _ in self?.updateOrientations(selectedIndex: index) }
                .withUnretainedOnly(self)
                .map { $0.customTabBar.selectTab(index: index) }
                .bind(to: rx.selectedIndex)
                .disposed(by: disposeBag)
        }
    }
    
    private func setUIViewAppearance() {
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    private func updateOrientations(selectedIndex: Int) {
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    private func makeBackButton(title: String) -> UIBarButtonItem {
        let backButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: nil,
            action: nil)
        
//        backButtonItem.setTitleTextAttributes(
//            [.font: FontManager.shared.pretendard(weight: .semiBold, size: 18)],
//            for: .normal)
        
        return backButtonItem
    }
}

enum Features {
    case home
    case chatting
    case setting
    
    var selectedIndex: Int {
        switch self {
        case .home: return 0
        case .chatting: return 1
        case .setting: return 2
        }
    }
}


class TestNavigationViewController: UIViewController {
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainNavigationViewController {
        return MainNavigationViewController()
    }
    
    func updateUIViewController(_ uiViewController: MainNavigationViewController, context: Context) {
        // 필요 시 UIViewController 업데이트
    }
}
