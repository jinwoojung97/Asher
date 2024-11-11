//
//  ChatInputView.swift
//  Asher
//
//  Created by chuchu on 11/11/24.
//

import UIKit

import Foundation
import RxSwift
import RxCocoa

class ChatInputView: UIView {
    let disposeBag = DisposeBag()
    
    var viewModel: ChatInputViewModel!

    let containerView = UIView().then {
        $0.layer.cornerRadius = 6
    }
    
    var sendMessageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gear"), for: .normal)
    }
    
    var placeholder = UILabel().then {
        $0.text = "채팅 입력하기"
//        $0.font = .systemFont(ofSize: ., weight: <#T##UIFont.Weight#>)
        $0.tag = 1
        $0.textColor = .gray
    }
    
    lazy var textView = UITextView().then {
        $0.bounces = false
        $0.isScrollEnabled = false
        $0.tintColor = .black
        $0.textAlignment = .left
        $0.backgroundColor = .clear
        $0.textColor = .main1
//        $0.font = FontManager.shared.suit(.medium, 12)
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commoninit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        self.backgroundColor = .subtitleOn
        [containerView, sendMessageButton].forEach(addSubview)
        
        [textView].forEach(containerView.addSubview)
        
        textView.addSubview(placeholder)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(63)
            $0.height.lessThanOrEqualTo(100)
        }
        
        sendMessageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(4)
            $0.right.equalToSuperview()
            $0.size.equalTo(40)
            
        }
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.left.right.equalToSuperview().inset(5)
        }
        
        placeholder.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(3)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = ChatInputViewModel.Input(
            sendButtonTappedWithText: sendMessageButton.rx.tap.map { [weak self] in self?.textView.text }
        )
        viewModel = ChatInputViewModel(input: input)
        
        textView.rx.text
            .withUnretained(self)
            .bind { owner, text in
                owner.textView.isScrollEnabled = owner.textView.numberOfLine > 5
                owner.placeholder.isHidden = text?.isEmpty == false
            }.disposed(by: disposeBag)
    }
    
    deinit {
        textView.delegate = nil
    }
}

extension UITextView {
    var numberOfLine: Int {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font?.lineHeight ?? 12)) - 1
    }
}
