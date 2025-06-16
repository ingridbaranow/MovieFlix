//  DefaultSearchBar.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 02/06/25.

import UIKit
import SnapKit

class DefaultSearchBar: UIView {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .backgroundLightDark
        searchBar.layer.cornerRadius = 10
        searchBar.returnKeyType = .search
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.autocapitalizationType = .words
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupTextField()
        setupIcon()
        setupCancelButton()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.addSubview(searchBar)
    }
    
    // MARK: - Setups
    
    func setupTextField() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .primaryText
            textField.font = UIFont(name: .regular, size: .body3)
            textField.attributedPlaceholder = NSAttributedString(string: "Search movies", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primary])
            
            for subview in textField.subviews {
                if subview.description.contains("Background") {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    func setupIcon() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
           let leftIcon = textField.leftView as? UIImageView {
            leftIcon.tintColor = .primary
        }
    }
    
    func setupCancelButton() {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitleColor(.primary, for: .normal)
            cancelButton.titleLabel?.font = UIFont(name: .regular, size: .body3)
            cancelButton.setTitle("Cancel", for: .normal)
        }
    }
    
    func setupConstrains() {
        searchBar.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 361, height: 40))
        }
    }
}
