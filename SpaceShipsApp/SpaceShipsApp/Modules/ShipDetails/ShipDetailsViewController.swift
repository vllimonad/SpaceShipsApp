//
//  ShipDetailsViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 15/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ShipDetailsViewController: UIViewController, UIScrollViewDelegate {
    var viewModel: ShipDetailsViewModel?
    private var disposeBag = DisposeBag()
    
    private var shipImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0.3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = tableView.backgroundColor
        setupLayout()
        setupTableView()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel?.imageData.subscribe(onNext: { [weak self] shipImageNSData in
            if let shipImageNSData = shipImageNSData {
                let shipImageData = Data(referencing: shipImageNSData)
                self?.shipImageView.image = UIImage(data: shipImageData)
            } else {
                self?.shipImageView.image = UIImage(named: "ImageAbsence")
            }
        }).disposed(by: disposeBag)
        
        viewModel?.detailsValues.bind(to: tableView.rx.items(cellIdentifier: ShipDetailsTableViewCell.identifier, cellType: ShipDetailsTableViewCell.self)) { [weak self] row, value, cell in
            guard let fieldName = self?.viewModel?.detailsNames[row] else { return }
            cell.setLabelsText(with: fieldName, and: value)
        }.disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.addSubview(shipImageView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            shipImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            shipImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shipImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shipImageView.heightAnchor.constraint(equalTo: shipImageView.widthAnchor),

            tableView.topAnchor.constraint(equalTo: shipImageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(ShipDetailsTableViewCell.self, forCellReuseIdentifier: ShipDetailsTableViewCell.identifier)
    }
}
