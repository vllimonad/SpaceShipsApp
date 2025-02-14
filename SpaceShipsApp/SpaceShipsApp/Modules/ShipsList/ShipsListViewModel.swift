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
    private var mapper: ShipsMappable
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = PublishRelay<[Ship]>()
    
    init(networkManager: Fetchable, mapper: ShipsMappable) {
        self.networkManager = networkManager
        self.mapper = mapper
    }
}

extension ShipsListViewModel {
    func fetchShips() {
        networkManager.fetchData(with: base + subdirectory) { [weak self] result in
            switch result {
            case .success(let data):
                guard let fetchedShips = self?.mapper.map(data) else { return }
                self?.ships.accept(fetchedShips)
            case .failure(let error):
                print(error)
            }
        }
    }
}
