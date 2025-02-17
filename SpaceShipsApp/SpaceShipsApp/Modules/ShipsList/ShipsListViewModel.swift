//
//  ShipsTableViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipsListViewModel {
    private var networkingManager: Fetchable
    private var coreDaraManager: CoreDataManagable
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = BehaviorRelay(value: [CDShip]())
    
    init(networkManager: Fetchable = NetworkingManager(), coreDaraManager: CoreDataManagable = CoreDataManager()) {
        self.networkingManager = networkManager
        self.coreDaraManager = coreDaraManager
    }
    
    private func saveFetchedShips(_ data: Data) {
        guard let fetchedShips = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
        fetchedShips.filter {
            let fetchedShipId = $0["ship_id"] as! String
            return !coreDaraManager.storesShip(with: fetchedShipId)
        }.forEach {
            let insertedShip = coreDaraManager.insertShip($0)
            fetchShipImage(insertedShip!)
        }
    }
}

extension ShipsListViewModel {
    func fetchShips() {
        networkingManager.fetchData(with: base + subdirectory) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.saveFetchedShips(data)
                    guard let ships = self?.coreDaraManager.fetchShips() else { return }
                    self?.ships.accept(ships)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchShipImage(_ ship: CDShip) {
        guard let shipImageUrlString = ship.imageUrlString else { return }
        networkingManager.fetchData(with: shipImageUrlString) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.coreDaraManager.updateShip(ship, with: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteAllShips() {
        coreDaraManager.deleteAllShips()
    }
}
