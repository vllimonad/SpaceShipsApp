//
//  ViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ShipsListViewController: UIViewController {
    private let viewModel: ShipsListViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        return tableView
    }()
    
    private let bannerLabel = {
        let banner = UILabel()
        banner.text = "No internet connection. You’re in Offline mode."
        banner.textAlignment = .center
        banner.numberOfLines = 0
        banner.isHidden = true
        banner.backgroundColor = .systemGray4
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    init(viewModel: ShipsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBarButtons()
        //viewModel.deleteAllShips()
        viewModel.fetchShips()
    }
    
    override func viewWillLayoutSubviews() {
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        guard let navigationController = navigationController else { return }
        navigationController.view.addSubview(bannerLabel)
        NSLayoutConstraint.activate([
            bannerLabel.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor),
            bannerLabel.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            bannerLabel.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            bannerLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        viewModel.isConnectedToInternet.subscribe(onNext: { [weak self] isConnected in
            DispatchQueue.main.async {
                self?.bannerLabel.isHidden = isConnected
            }
        }).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CDShip>> { dataSource, tableView, indexPath, ship in
            let cell = tableView.dequeueReusableCell(withIdentifier: ShipTableViewCell.identifier, for: indexPath) as! ShipTableViewCell
            cell.setShip(ship)
            return cell
        } canEditRowAtIndexPath: { _, _ in
            true
        }
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] in
            guard let ship = self?.viewModel.ships.value[$0.section].items[$0.row] else { return }
            let shipDetailsViewController = ShipDetailsViewController(viewModel: ShipDetailsViewModel(ship))
            self?.present(UINavigationController(rootViewController: shipDetailsViewController), animated: true)
            self?.tableView.deselectRow(at: $0, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] in
            self?.viewModel.deleteShip($0)
        }).disposed(by: disposeBag)
        
        viewModel.ships.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupNavigationBarButtons() {
        let logoutButtonTitle = viewModel.isGuest ? "Exit" : "Log out"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: logoutButtonTitle, style: .done, target: self, action: #selector(logoutButtonPressed))
        navigationItem.hidesBackButton = true
    }
    
    @objc private func logoutButtonPressed() {
        viewModel.isGuest ? showGuestExitAlert() : navigateToLoginScreen()
    }
    
    private func showGuestExitAlert() {
        let alertController = UIAlertController(title: nil, message: "Thank you for trialing this app", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.navigateToLoginScreen()
        })
        present(alertController, animated: true)
    }
    
    private func navigateToLoginScreen() {
        navigationController?.popViewController(animated: true)
    }
}

extension ShipsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minimumRowHeight = CGFloat(150.0)
        let prefferedRowHeight = tableView.frame.height/4
        return max(minimumRowHeight, prefferedRowHeight)
    }
}
