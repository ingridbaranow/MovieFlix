//  GradientImageView2.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 30/05/25.

import UIKit

class GradientImageView2: UIImageView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.1)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.frame = CGRect(x: 0, y: bounds.height * 0.7, width: bounds.width, height: bounds.height)
    }
}
