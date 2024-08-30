//
//  LockScreenView.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import UIKit

import RxSwift

final class LockScreenView: UIView {
    let viewModel: LockScreenViewModel!
    
    let disposeBag = DisposeBag()
    
    let vibrator = UINotificationFeedbackGenerator().then {
        $0.prepare()
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .subtitleOn
        $0.font = .notoSans(width: .semiBold, size: 22)
    }
    
    let subtitleLabel = UILabel().then {
        $0.textColor = .subtitle
        $0.font = .notoSans(width: .semiBold, size: 13)
    }
    
    let warningImageView = UIImageView(image: UIImage(named: "icoWarning")).then {
        $0.isHidden = true
    }
    
    let passwordStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    let padWrapperStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    var padViews: [PadView] = []
    
    init(viewModel: LockScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .main1
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        [titleLabel,
         subtitleLabel,
         warningImageView,
         passwordStackView,
         padWrapperStackView].forEach(addSubview)
        
        setPasswordView()
        setPadView()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(150)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        warningImageView.snp.makeConstraints {
            $0.trailing.equalTo(subtitleLabel.snp.leading)
            $0.centerY.equalTo(subtitleLabel)
            $0.size.equalTo(24)
        }
        
        passwordStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(84)
            $0.height.equalTo(12)
        }
        
        padWrapperStackView.snp.makeConstraints {
            let mainBounds = UIScreen.main.bounds
            let height = max(mainBounds.width, mainBounds.height) * 0.4
            
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(height)
        }
    }
    
    private func bind() {
        let padPanGesture = UIPanGestureRecognizer()
        
        padWrapperStackView.addGestureRecognizer(padPanGesture)
        
        viewModel.output?.lockType
            .drive { [weak self] in self?.setLockType(type: $0) }
            .disposed(by: disposeBag)
        
        
        viewModel.output?.passwordCount
            .drive { [weak self] in self?.setPasswordView(passwordCount: $0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.passwordError
            .drive { [weak self] _ in self?.errorEmit() }
            .disposed(by: disposeBag)
    }
    
    private func setPasswordView() {
        (0...3).forEach { _ in
            let view = UIView()
            
            view.addCornerRadius(radius: 6)
            
            passwordStackView.addArrangedSubview(view)
        }
    }
    
    private func setPadView() {
        for row in viewModel.model.lockType.value.pads {
            let rowStackView = getRowStackView(pads: row)
            
            padWrapperStackView.addArrangedSubview(rowStackView)
        }
    }
    
    private func getRowStackView(pads: [PadView.PadType]) -> UIStackView {
        let rowStackView = UIStackView()
        
        rowStackView.distribution = .fillEqually
        
        for pad in pads {
            let padView = PadView(type: pad)
            
            padView.padButton.rx.tap
                .map { _ in pad }
                .bind(to: viewModel.input.padTap)
                .disposed(by: disposeBag)
            
            rowStackView.addArrangedSubview(padView)
            self.padViews.append(padView)
        }
        
        return rowStackView
    }
    
    private func setLockType(type: LockType) {
        titleLabel.text = type.title
        subtitleLabel.text = type.subtitle
        
    }
    
    private func setPasswordView(passwordCount: Int) {
        switch passwordCount {
        case 0:
            passwordStackView.arrangedSubviews.forEach {
                $0.backgroundColor = .subtitle
            }
        case 1...3:
            passwordStackView.arrangedSubviews[0...passwordCount].forEach {
                $0.backgroundColor = .subtitleOn
            }
            
            passwordStackView.arrangedSubviews[passwordCount...3].forEach {
                $0.backgroundColor = .subtitle
            }
        case 4:
            passwordStackView.arrangedSubviews.forEach {
                $0.backgroundColor = .subtitle
            }
        default: break
        }
    }
    
    private func errorEmit() {
        setErrorTitle()
        shakeAnimation()
    }
    
    private func setErrorTitle() {
        warningImageView.isHidden = false
        subtitleLabel.text = LockType.normal.invalidText
        subtitleLabel.textColor = .red
    }
    
    private func shakeAnimation() {
        [titleLabel,
         warningImageView,
         subtitleLabel,
         passwordStackView].forEach { $0.shakeAnimation() }
        
        vibrate()
    }
    
    public func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType = .error) {
        vibrator.notificationOccurred(type)
    }
}
