//  DefaultOutlineButton.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 02/06/25.

import UIKit
import SnapKit

class DefaultOutlineButton: UIButton {
    
    lazy var buttonLabel: UILabel = {
        let buttonLabel = UILabel()
        buttonLabel.textColor = .primary
        buttonLabel.font = UIFont(name: .bold, size: .body3)
        buttonLabel.textAlignment = .center
        buttonLabel.isUserInteractionEnabled = false
        return buttonLabel
    }()
    
    lazy var socialImage: UIImageView = {
        let socialImage = UIImageView()
        socialImage.contentMode = .scaleAspectFit
        socialImage.isUserInteractionEnabled = false
        return socialImage
    }()
    
    lazy var socialStack: UIStackView = {
        let socialStack = UIStackView(arrangedSubviews: [socialImage, buttonLabel])
        socialStack.isUserInteractionEnabled = false
        socialStack.axis = .horizontal
        socialStack.alignment = .center
        socialStack.spacing = 15
        return socialStack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.addSubview(socialStack)
    }
    
    func setupButton(title: String, imageName: String) {
        buttonLabel.text = title
        socialImage.image = UIImage(systemName: imageName)
        socialImage.tintColor = .primary
        self.backgroundColor = .backgroundDark.withAlphaComponent(0.6)
        self.layer.borderColor = UIColor.primary.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    func setupConstrains() {
        socialStack.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(60)
            make.height.equalTo(48)
            make.center.equalToSuperview()
        }
        socialImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
    }
}
