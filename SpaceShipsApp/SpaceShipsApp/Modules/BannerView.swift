//
//  BannerView.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 18/02/2025.
//

import Foundation
import UIKit

final class BannerView: UIView {
    private let banner = {
        let banner = UILabel()
        banner.text = "No internet connection. You’re in Offline mode."
        banner.font = UIFont.boldSystemFont(ofSize: 16)
        banner.textAlignment = .center
        banner.numberOfLines = 0
        banner.isHidden = true
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(banner)
        banner.center = self.center
    }
}
