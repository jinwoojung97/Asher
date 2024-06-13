//
//  CustomTabbar.swift
//  Asher
//
//  Created by chuchu on 6/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class CustomTabBar: UIView {
    let disposeBag = DisposeBag()
    
    let tabbarStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }
    
    let vibrator = UISelectionFeedbackGenerator().then { $0.prepare() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .main1
        addBorder(color: .border)
        
        addComponent()
        setConstraints()
        selectItem(tab: .home)
    }
    
    private func addComponent() {
        addSubview(tabbarStackView)
        addTabViews()
        
    }
    
    private func setConstraints() {
        tabbarStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(75)
        }
    }
    
    private func addTabViews() {
        Tab.allCases.forEach { tab in
            let view = UIView()
            let imageView = UIImageView()
            let label = UILabel()
            
            imageView.image = tab.offImage
            imageView.tag = tab.imageTag
            
            label.text = tab.title
            label.textColor = .subtitle
            label.font = .notoSans(width: .medium, size: 11)
            label.tag = tab.labelTag
            
            [imageView, label].forEach(view.addSubview(_:))
            
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(24)
            }
            
            label.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
            }
            
            tabbarStackView.addArrangedSubview(view)
        }
    }
    
    @discardableResult
    func selectTab(index: Int) -> Int {
        resetSelectedItem()
        selectItem(tab: Tab(index: index))
        vibrator.selectionChanged()
        
        return index
    }
    
    private func getTabSubView(index: Int) -> UIView? {
        return tabbarStackView.arrangedSubviews[safe: index]
    }
    
    private func resetSelectedItem() {
        Tab.allCases.forEach { tab in
            let subview = getTabSubView(index: tab.index)
            let imageView = subview?.viewWithTag(tab.imageTag) as? UIImageView
            let label = subview?.viewWithTag(tab.labelTag) as? UILabel
            
            imageView?.image = tab.offImage
            label?.textColor = .subtitle
        }
    }
    
    private func selectItem(tab: Tab) {
        let subview = getTabSubView(index: tab.index)
        let imageView = subview?.viewWithTag(tab.imageTag) as? UIImageView
        let label = subview?.viewWithTag(tab.labelTag) as? UILabel
        
        UIView.animate(withDuration: 0.5) {
            imageView?.image = tab.onImage
            label?.textColor = .subtitleOn
        }
    }
}
