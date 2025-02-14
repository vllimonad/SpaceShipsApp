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
    private var networkManager: Fetchable
    private var coreDaraManager: CoreDataManagable
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = PublishRelay<[CDShip]>()
    
    init(networkManager: Fetchable, coreDaraManager: CoreDataManagable) {
        self.networkManager = networkManager
        self.coreDaraManager = coreDaraManager
    }
    
    private func saveShips(_ data: Data) {
        guard let fetchedShips = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
        for fetchedShip in fetchedShips {
            let fetchedShipId = fetchedShip["ship_id"] as? String ?? ""
            guard let _ = coreDaraManager.fetchShipById(fetchedShipId) else {
                coreDaraManager.insertShip(fetchedShip)
                continue
            }
        }
    }
}

extension ShipsListViewModel {
    func fetchShips() {
        networkManager.fetchData(with: base + subdirectory) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.saveShips(data)
                    guard let ships = self?.coreDaraManager.fetchShips() else { return }
                    self?.ships.accept(ships)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
