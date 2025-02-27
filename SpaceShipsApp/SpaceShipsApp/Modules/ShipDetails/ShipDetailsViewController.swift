//
//  ShipDetailsViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 15/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ShipDetailsViewController: UIViewController, UITableViewDelegate {
    private let viewModel: ShipDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let shipImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0.3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.register(ShipDetailsTableViewCell.self, forCellReuseIdentifier: ShipDetailsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannerView = {
        let view = BannerVeiw()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: ShipDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = tableView.backgroundColor
        setupLayout()
        setupBindings()
        setupBackButton()
    }
    
    private func setupBindings() {
        viewModel.shipImageData.subscribe(onNext: { [weak self] shipImageNSData in
            if let shipImageNSData = shipImageNSData {
                let shipImageData = Data(referencing: shipImageNSData)
                self?.shipImageView.image = UIImage(data: shipImageData)
            } else {
                self?.shipImageView.image = UIImage(named: "ImageAbsence")
            }
        }).disposed(by: disposeBag)
        
        viewModel.shipDetailsValues.bind(to: tableView.rx.items(cellIdentifier: ShipDetailsTableViewCell.identifier, cellType: ShipDetailsTableViewCell.self)) { [weak self] row, value, cell in
            guard let fieldName = self?.viewModel.shipDetailsNames[row] else { return }
            cell.setLabels(with: fieldName, and: value)
        }.disposed(by: disposeBag)
        
        viewModel.isConnectedToInternet.bind(to: bannerView.rx.isHidden).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        guard let navigationController = navigationController else { return }
        navigationController.view.addSubview(bannerView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([shipImageView, tableView])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            shipImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            shipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            shipImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            shipImageView.heightAnchor.constraint(equalTo: shipImageView.widthAnchor),
            
            tableView.topAnchor.constraint(equalTo: shipImageView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 320),
            
            bannerView.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor),
            bannerView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBackButton() {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: action)
    }
}
