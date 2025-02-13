//
//  ShipsTableViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipsTableViewModel {
    private var networkManager: ShipsFetchable
    private var mapper: ShipsMappable
    
    private var ships = PublishRelay<[Ship]>()
    
    init(networkManager: ShipsFetchable, mapper: ShipsMappable) {
        self.networkManager = networkManager
        self.mapper = mapper
    }
}

extension ShipsTableViewModel {
    func fetchShips() {
        networkManager.fetchShipsData { [weak self] result in
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
