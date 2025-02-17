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
    private let viewModel: ShipsListViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: ShipsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        setupNavigationButtons()
        //viewModel?.deleteAll()
        viewModel.fetchShips()
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    private func setupBindings() {
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
    
    private func setupNavigationButtons() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.getLogoutButtonTitle(), style: .done, target: self, action: #selector(logoutButtonPressed))
    }
    
    @objc private func logoutButtonPressed() {
        viewModel.isGuest ? showExitAlert() : navigateToLoginScreen()
    }
    
    private func showExitAlert() {
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
        tableView.bounds.height/4
    }
}
