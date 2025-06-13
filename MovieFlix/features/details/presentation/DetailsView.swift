//  DetailsView.swift
//  MovieFlix
//
//  Created by Ingrid Baranow on 05/06/25.

import UIKit
import SnapKit

class DetailsView: UIView {
    
    //MARK: - Components
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var imageHeaderView: ImageHeaderView = {
        let headerView = ImageHeaderView()
        headerView.layer.cornerRadius = 8
        return headerView
    }()
    
    lazy var detailsContentView: DetailsContentView = {
        let content = DetailsContentView()
        return content
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        addSubview(scrollView)
        scrollView.addSubview(imageHeaderView)
        scrollView.addSubview(detailsContentView)
    }
    
    //MARK: - Setup Constraints
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(360)
            make.width.equalTo(360)
        }
        detailsContentView.snp.makeConstraints { make in
            make.top.equalTo(imageHeaderView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(360)
            make.bottom.equalToSuperview()
        }
    }
}

