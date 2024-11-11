//
//  MessageCell.swift
//  Asher
//
//  Created by chuchu on 11/11/24.
//

import UIKit

final class TestCell: UITableViewCell {
    static let identifier = description()
    
    var message: Message?
    
    let testWrapperView = UIView().then {
        $0.addCornerRadius(radius: 16)
    }
    let testView = UILabel().then {
        $0.text = "text"
        $0.font = .notoSans(width: .regular, size: 16)
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        contentView.addSubview(testWrapperView)
        
        testWrapperView.addSubview(testView)
    }
    
    private func setConstraints() {
        testView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
    }
    
    private func bind() {
    }
    
    func configure(message: Message) {
        self.message = message
        
//        testView.textColor = message.isReply ? .yourChatFont: .
        testWrapperView.backgroundColor = message.isReply ? .yourChatBackground: .myChatBackground
        testView.text = message.content
        testView.textColor = message.isReply ? .yourChatFont: .white
        
        testWrapperView.snp.makeConstraints {
            let targetConstriant = message.isReply ? $0.left: $0.right
            
            $0.top.bottom.equalToSuperview().inset(8)
            $0.width.lessThanOrEqualToSuperview().dividedBy(1.5)
            targetConstriant.equalToSuperview().inset(16)
        }
    }
    
    func applyMask() {
        
        let holeRect = testWrapperView.frame
        
        // 전체 경로 (UIView 전체)
        let path = UIBezierPath(rect: bounds)
        
        // 구멍 경로 (구멍 부분을 반대로 추가)
        let holePath = UIBezierPath(rect: holeRect).reversing()
        
        // 전체 경로에 구멍 경로 추가
        path.append(holePath)
        
        // 마스크 레이어 설정
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.cornerRadius = 16
        // UIView에 마스크 적용
        
        layer.mask = message?.isReply == false ? maskLayer: nil
    }
}
    
