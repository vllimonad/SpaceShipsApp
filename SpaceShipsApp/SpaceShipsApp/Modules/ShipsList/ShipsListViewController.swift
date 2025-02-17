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
    private var tableView: UITableView?
    
    private let viewModel: ShipsListViewModel
    private let disposeBag = DisposeBag()
    
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
        //viewModel?.deleteAll()
        viewModel.fetchShips()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView?.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        tableView?.rx.setDelegate(self).disposed(by: disposeBag)
        tableView?.frame = view.bounds
        view.addSubview(tableView!)
    }
    
    private func setupBindings() {
        viewModel.ships.bind(to: tableView!.rx.items(cellIdentifier: ShipTableViewCell.identifier, cellType: ShipTableViewCell.self)) { _, ship, cell in
            cell.setShip(ship)
        }.disposed(by: disposeBag)
        
        tableView?.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let ship = self?.viewModel.ships.value[indexPath.row] else { return }
            let shipDetailsViewController = ShipDetailsViewController()
            shipDetailsViewController.viewModel = ShipDetailsViewModel(ship)
            self?.present(UINavigationController(rootViewController: shipDetailsViewController), animated: true)
            self?.tableView?.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }
}

extension ShipsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height/4
    }
}
