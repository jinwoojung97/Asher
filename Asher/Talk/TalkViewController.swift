//
//  TalkViewController.swift
//  Asher
//
//  Created by chuchu on 7/18/24.
//

import UIKit

final class TalkViewController: UIViewController {
    override func loadView() {
        view = TalkView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

import SnapKit
import Then
import RxSwift

final class TalkView: UIView {
    var messages = DataSource.messages
    
    let disposeBag = DisposeBag()
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.allowsSelection = false
        $0.separatorColor = .clear
        $0.backgroundColor = .clear

        
        $0.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
    }
    
    let textField = UITextView().then {
        $0.backgroundColor = .black
    }
    
    let testButton = UIButton().then {
        $0.backgroundColor = .purple
        $0.setTitle("테스트", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 217/255, green: 122/255, blue: 132/255, alpha: 1).cgColor, // Dark Pastel Pink
            UIColor(red: 143/255, green: 122/255, blue: 174/255, alpha: 1).cgColor, // Dark Pastel Purple
            UIColor(red: 118/255, green: 154/255, blue: 177/255, alpha: 1).cgColor, // Dark Pastel Blue
            UIColor(red: 90/255, green: 147/255, blue: 179/255, alpha: 1).cgColor  // Dark Pastel Sky Blue
        ]
        
        gradientLayer.frame = bounds
        let backgroundView = UIView(frame: bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    private func bind() {
        testButton.rx.tap
            .bind { print("wow") }
            .disposed(by: disposeBag)
    }
}

extension TalkView: UITableViewDelegate {
    
}

extension TalkView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        getTableViewCell(tableView: tableView, cellForRowAt: indexPath)
    }
    
    private func getTableViewCell(
        tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TestCell.identifier,
            for: indexPath
        ) as? TestCell,
              let message = messages[safe: indexPath.row]
        else { return UITableViewCell() }
        
        cell.backgroundColor = .white
        cell.configure(message: message)
        
        return cell
    }
}

final class TestCell: UITableViewCell {
    static let identifier = description()
    
    var message: Message?
    
    let testWrapperView = UIView().then {
        $0.backgroundColor = .black
        $0.addCornerRadius(radius: 16)
    }
    let testView = UILabel().then {
        $0.text = "text"
        $0.numberOfLines = 0
        $0.textColor = .white
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
        
        applyMask()
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        contentView.addSubview(testWrapperView)
        let test = UIView().then {
            $0.backgroundColor = .red
        }
        contentView.addSubview(test)
        
        test.snp.makeConstraints {
            $0.center.equalTo(testWrapperView)
            $0.size.equalTo(50)
        }
        
        testWrapperView.addSubview(testView)
    }
    
    private func setConstraints() {
        testView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
    }
    
    private func bind() {
    }
    
    func configure(message: Message) {
        self.message = message
        
        testView.text = message.content
        
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
    
