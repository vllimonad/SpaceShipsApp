//
//  BannerLabel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 20/02/2025.
//

import UIKit

class BannerVeiw: UIView {
    private let bannerLabel = {
        let banner = UILabel()
        banner.text = "No internet connection. You’re in Offline mode."
        banner.textAlignment = .center
        banner.numberOfLines = 0
        banner.backgroundColor = .systemGray4
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        backgroundColor = .systemGray4
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(bannerLabel)
        
        NSLayoutConstraint.activate([
            bannerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            bannerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
