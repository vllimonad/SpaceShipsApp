//
//  ViewController.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import UIKit

final class ShipsTableViewController: UITableViewController {
    var viewModel = ShipsTableViewModel(networkManager: NetworkManager(), mapper: ShipsMapper())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }


}

extension ShipsTableViewController {
    func setupTableView() {
        tableView.rowHeight = 200
        tableView.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShipTableViewCell.identifier, for: indexPath) as! ShipTableViewCell
        
        return cell
    }
}
