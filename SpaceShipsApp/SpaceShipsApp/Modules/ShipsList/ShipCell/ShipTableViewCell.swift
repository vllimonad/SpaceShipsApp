//
//  ShipTableViewCell.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ShipTableViewCell: UITableViewCell {
    static let identifier = "ShipCell"
    var viewModel: ShipCellViewModel?
    private let disposeBag = DisposeBag()
    
    private var shipImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var typeLabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var yearLabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(shipImageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(yearLabel)
        
        NSLayoutConstraint.activate([
            shipImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            shipImageView.heightAnchor.constraint(equalTo: shipImageView.widthAnchor),
            shipImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            shipImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            stackView.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: shipImageView.centerYAnchor)
        ])
    }
    
    func setupBindings() {
        viewModel?.imageData.asObservable().subscribe(onNext: { [weak self] data in
            guard let viewModel = self?.viewModel else { return }
            DispatchQueue.main.async {
                self?.shipImageView.image = UIImage(data: data)
                self?.nameLabel.text = viewModel.ship.name
                self?.typeLabel.text = viewModel.ship.type
                self?.yearLabel.text = String(describing: viewModel.ship.year)
            }
        }).disposed(by: disposeBag)
    }
}
