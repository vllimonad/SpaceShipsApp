//
//  ShipsTableViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol ShipsListViewModelProtocol {
    var ships: BehaviorRelay<[AnimatableSectionModel<String, CDShip>]> { get }
    var isGuest: Bool { get }
    
    func fetchShips()
    func deleteShip(_ indexPath: IndexPath)
    func restoreShips()
    //func deleteAllShips()
    func getShipDetailsViewModel(_ ship: CDShip) -> ShipDetailsViewModel
}

final class ShipsListViewModel: ShipsListViewModelProtocol {
    private let networkingManager: APIFetchable
    private let coreDaraManager: CoreDataManagable
    private let networkConnectionManager: NetworkConnectionManagable
    private let disposeBag = DisposeBag()
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = BehaviorRelay<[AnimatableSectionModel<String, CDShip>]>(value: [])
    private let userEmail: String?
    let isGuest: Bool
    
    init(userEmail: String?, isGuest: Bool, networkManager: APIFetchable = NetworkingManager(), coreDaraManager: CoreDataManagable = CoreDataManager(), networkConnectionManager: NetworkConnectionManagable) {
        self.networkingManager = networkManager
        self.coreDaraManager = coreDaraManager
        self.networkConnectionManager = networkConnectionManager
        self.isGuest = isGuest
        self.userEmail = userEmail
        setupBindings()
    }
    
    private func setupBindings() {
        networkConnectionManager.isConnected.subscribe { [weak self] isConnected in
            guard isConnected else { return }
            self?.fetchShips()
        }.disposed(by: disposeBag)
    }
    
    private func saveAPIFetchedShips(_ data: Data) {
        guard let fetchedShips = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
        fetchedShips.filter {
            guard let fetchedShipId = $0["ship_id"] as? String else { return false }
            return !coreDaraManager.storesShip(with: fetchedShipId)
        }.forEach {
            guard let insertedShip = coreDaraManager.insertShip($0) else { return }
            fetchShipImage(insertedShip)
        }
    }
    
    private func fetchCDShips() {
        let fetchedShips = isGuest ? coreDaraManager.fetchShips() : coreDaraManager.fetchShipsForUser(with: userEmail!)
        let sections = [AnimatableSectionModel(model: "", items: fetchedShips)]
        ships.accept(sections)
    }
    
    private func fetchShipImage(_ ship: CDShip) {
        guard let shipImageUrlString = ship.imageUrlString else { return }
        networkingManager.fetchData(with: shipImageUrlString) { [weak self] result in
            guard let data = try? result.get() else { return }
            DispatchQueue.main.async {
                self?.coreDaraManager.updateShip(ship, with: data)
            }
        }
    }
}

extension ShipsListViewModel {
    func fetchShips() {
        networkingManager.fetchData(with: base + subdirectory) { [weak self] result in
            DispatchQueue.main.async {
                if let data = try? result.get() {
                    self?.saveAPIFetchedShips(data)
                }
                self?.fetchCDShips()
            }
        }
    }
    
//    func deleteAllShips() {
//        coreDaraManager.deleteAllShips()
//    }
    
    func deleteShip(_ indexPath: IndexPath) {
        var shipsSections = ships.value
        let shipToDelete = shipsSections[indexPath.section].items.remove(at: indexPath.row)
        self.ships.accept(shipsSections)
        
        guard !isGuest, let userEmail = userEmail else { return }
        coreDaraManager.deleteShip(shipToDelete, for: userEmail)
    }
    
    func restoreShips() {
        let fetchedShips: [CDShip]
        
        if isGuest {
            fetchedShips = coreDaraManager.fetchShips()
        } else {
            guard let userEmail = userEmail else { return }
            coreDaraManager.restoreShipsForUser(with: userEmail)
            fetchedShips = coreDaraManager.fetchShipsForUser(with: userEmail)
        }
        
        ships.accept([AnimatableSectionModel(model: "", items: fetchedShips)])
    }
    
    func getShipDetailsViewModel(_ ship: CDShip) -> ShipDetailsViewModel {
        ShipDetailsViewModel(ship, networkConnectionManager: networkConnectionManager)
    }
}
