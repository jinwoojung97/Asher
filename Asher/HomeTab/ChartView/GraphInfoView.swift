//
//  GraphInfoView.swift
//  Asher
//
//  Created by chuchu on 7/15/24.
//

import UIKit

final class GraphInfoView: UIView {
    let data: DatabaseManager.ChartInfo?
    
    let shadowWrapperView = UIView().then {
        $0.addShadow(offset: CGSize(width: 0, height: 2))
    }
    
    let wrapperView = UIView().then {
        $0.backgroundColor = .border
        $0.addCornerRadius(radius: 4)
    }
    
    lazy var infoLabel = UILabel().then {
        $0.text = data?.day
        $0.textColor = .subtitleOn
        $0.font = .systemFont(ofSize: 12)
    }
    
    lazy var moodView = makeMoodView()
    
    init(data: DatabaseManager.ChartInfo?) {
        self.data = data
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
    }
    
    private func addComponent() {
        addSubview(shadowWrapperView)
        shadowWrapperView.addSubview(wrapperView)
        
        [infoLabel, moodView].forEach(wrapperView.addSubview)
    }
    
    private func setConstraints() {
        shadowWrapperView.snp.makeConstraints { $0.edges.equalToSuperview() }
        wrapperView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        infoLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
        
        moodView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(4)
            $0.bottom.centerX.equalToSuperview()
            $0.height.equalTo(30)

        }
    }
    
    private func makeMoodView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        
        let info = data?.moods.map(\.emoji) ?? []
        
        info
            .map(makeLabel)
            .forEach(stackView.addArrangedSubview)
        
        return stackView
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        return label
    }
}
