//  UIButton.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 30/05/25.

import UIKit

extension UIButton {
    
    func effectButtonClicked() {
        self.alpha = 0.8
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
           self.alpha = 1.0
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        effectButtonClicked()
    }
}
