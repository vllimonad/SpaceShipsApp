//
//  ShipCellViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipCellViewModel {
    private var networkingManager: Fetchable
    
    var ship: CDShip
    var imageData = PublishRelay<Data>()
    
    init(ship: CDShip, networkingManager: NetworkingManager) {
        self.ship = ship
        self.networkingManager = networkingManager
    }
    
    func fetchImage() {
        networkingManager.fetchData(with: ship.imageUrlString ?? "") { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageData.accept(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

