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
    var tableView: UITableView?
    
    var viewModel = ShipsListViewModel(networkManager: NetworkingManager(), mapper: ShipsMapper())
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.fetchShips()
    }
}

extension ShipsListViewController: UITableViewDelegate {
    func setupTableView() {
        tableView = UITableView()
        tableView!.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        tableView!.rx.setDelegate(self).disposed(by: disposeBag)
        tableView!.frame = view.bounds
        view.addSubview(tableView!)
    }
    
    func setupBindings() {
        viewModel.ships.bind(to: tableView!.rx.items(cellIdentifier: ShipTableViewCell.identifier, cellType: ShipTableViewCell.self)) { row, item, cell in
            cell.viewModel = ShipCellViewModel(ship: item, networkingManager: NetworkingManager())
            cell.setupBindings()
            cell.viewModel?.fetchImage()
        }.disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
