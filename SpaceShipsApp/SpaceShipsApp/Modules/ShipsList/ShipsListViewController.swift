//
//  ViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ShipsListViewController: UIViewController {
    private let viewModel: ShipsListViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        return tableView
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
        viewModel.fetchShips()
    }
    
    override func viewWillLayoutSubviews() {
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func setupBindings() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.ships.bind(to: tableView.rx.items(cellIdentifier: ShipTableViewCell.identifier, cellType: ShipTableViewCell.self)) { _, ship, cell in
            cell.setShip(ship)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let ship = self?.viewModel.ships.value[indexPath.row] else { return }
            let shipDetailsViewController = ShipDetailsViewController(viewModel: ShipDetailsViewModel(ship))
            self?.present(UINavigationController(rootViewController: shipDetailsViewController), animated: true)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
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
