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
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .white
        setupLayout()
        setupBindings()
        setupNavigationBarButtons()
        //viewModel.deleteAllShips()
        viewModel.fetchShips()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupBindings() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CDShip>> { _, tableView, indexPath, ship in
            let cell = tableView.dequeueReusableCell(withIdentifier: ShipTableViewCell.identifier, for: indexPath) as! ShipTableViewCell
            cell.setShip(ship)
            return cell
        } canEditRowAtIndexPath: { _, _ in
            true
        }
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] in
            guard
                let ship = self?.viewModel.ships.value[$0.section].items[$0.row],
                let shipDetailsViewModel = self?.viewModel.getShipDetailsViewModel(ship)
            else { return }
            let shipDetailsViewController = ShipDetailsViewController(viewModel: shipDetailsViewModel)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restore ships", style: .plain, target: self, action: #selector(restoreButtonPressed))
        navigationItem.hidesBackButton = true
    }
    
    @objc private func logoutButtonPressed() {
        viewModel.isGuest ? showGuestExitAlert() : navigateToLoginScreen()
    }
    
    @objc private func restoreButtonPressed() {
        viewModel.restoreShips()
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
