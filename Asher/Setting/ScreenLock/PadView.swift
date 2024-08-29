//
//  PadView.swift
//  Asher
//
//  Created by chuchu on 8/28/24.
//

import UIKit

final class PadView: UIView {
    let type: PadType!
    
    lazy var padButton = UIButton().then {
        let fontSize: CGFloat = type == .cancel ? 18.0: 22.0
        
        $0.setTitle(type.title, for: .normal)
        $0.setTitleColor(.subtitleOn, for: .normal)
        $0.titleLabel?.font = .notoSans(width: .medium, size: fontSize)
    }
    
    lazy var padImageView = UIImageView(image: type.image)
    
    var isPlaying: Bool = false
    
    init(type: PadType) {
        self.type = type
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
        [padButton, padImageView].forEach(addSubview)
    }
    
    private func setConstraints() {
        padButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        padImageView.snp.makeConstraints {
            let size = type == .biometricsAuth ?
            CGSize(width: 24, height: 24):
            CGSize(width: 26, height: 20)
            
            $0.center.equalToSuperview()
            $0.size.equalTo(size)
        }
    }
}



extension PadView {
    enum PadType: Equatable {
        case number(Int)
        case cancel
        case biometricsAuth
        case back
        
        var title: String? {
            switch self {
            case .number(let number): return String(number)
            case .cancel: return I18N.cancel
            default: return nil
            }
        }
        
        var image: UIImage? {
            switch self {
            case .biometricsAuth: return getBiometricsImage()
            case .back: return UIImage(named: "icoCancle")
            default: return nil
            }
        }
        
        private func getBiometricsImage() -> UIImage? {
            let type = BiometricsAuthManager.biometricType()
            let color = UIColor.subtitleOn
            let imageString = type == .faceID ? "faceid": "touchid"
            let image = UIImage(systemName: imageString) ?? UIImage()
            
            switch type {
            case _ where !UserDefaultsManager.shared.useBiometricsAuth:
                return nil
            case .faceID:
                return image.withTintColor(color, renderingMode: .alwaysOriginal)
            case .touchID:
                return image.withTintColor(color, renderingMode: .alwaysOriginal)
            default: return nil
            }
        }
    }
}


