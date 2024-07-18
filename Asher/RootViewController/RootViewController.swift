//
//  RootViewController.swift
//  Asher
//
//  Created by chuchu on 6/10/24.
//

import UIKit
import SwiftUI
import Combine

import Then
import SnapKit
import RxSwift
import RxCocoa

final class MainNavigationViewController: UINavigationController {
    private var cancellables: Set<AnyCancellable> = []
    
    let rootViewController = RootViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        navigationBar.isHidden = true
        setViewControllers([rootViewController], animated: false)
    }
    
    private func bind() {
        NavigationManager.shared.$currentView
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] view in
                        if let view = view {
                            let hostingController = UIHostingController(rootView: view)
                            self?.pushViewController(hostingController, animated: true)
                        } else {
                            self?.popViewController(animated: true)
                        }
                    }
                    .store(in: &cancellables)
        
        NavigationManager.shared.$selectedTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                let index = index ?? 0
                self?.rootViewController.selectedIndex = index
                self?.rootViewController.customTabBar.selectTab(index: index)
            }
            .store(in: &cancellables)
    }
}

public final class RootViewController: UITabBarController {
    let firstVc = UIHostingController(rootView: HomeView())
    let secondVc = UIHostingController(rootView: TalkListView())
    let thirdVc = UIHostingController(rootView: SettingView())
    
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

struct RootViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainNavigationViewController {
        return MainNavigationViewController()
    }
    
    func updateUIViewController(_ uiViewController: MainNavigationViewController, context: Context) {
        // 필요 시 UIViewController 업데이트
    }
}

