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
    var ships: BehaviorRelay<[AnimatableSectionModel<String, Ship>]> { get }
    
    func fetchShipsFromAPI()
    func deleteShip(_ indexPath: IndexPath)
    func restoreShips()
    func getShipDetailsViewModel(for ship: Ship) -> ShipDetailsViewModel
    func isGuest() -> Bool
}

final class ShipsListViewModel: ShipsListViewModelProtocol {
    private let networkingManager: APIFetchable
    private let coreDaraManager: CoreDataManagable
    private let networkConnectionManager: NetworkConnectionManagable
    private let shipMapper: ShipMappable
    private let userStatusManager: UserStatusManagable
    private let disposeBag = DisposeBag()
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = BehaviorRelay<[AnimatableSectionModel<String, Ship>]>(value: [])
    
    init(networkManager: APIFetchable = NetworkingManager(), coreDaraManager: CoreDataManagable = CoreDataManager(), networkConnectionManager: NetworkConnectionManagable, shipMapper: ShipMappable = ShipMapper(), userStatusManager: UserStatusManagable) {
        self.networkingManager = networkManager
        self.coreDaraManager = coreDaraManager
        self.networkConnectionManager = networkConnectionManager
        self.shipMapper = shipMapper
        self.userStatusManager = userStatusManager
        setupBindings()
    }
    
    private func setupBindings() {
        networkConnectionManager.isConnected.subscribe { [weak self] isConnected in
            guard isConnected else { return }
            self?.fetchShipsFromAPI()
        }.disposed(by: disposeBag)
    }
    
    private func saveAPIFetchedShips(_ data: Data) {
        guard let apiFetchedShips = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
        
        apiFetchedShips.filter {
            guard let fetchedShipId = $0["ship_id"] as? String else { return false }
            return !coreDaraManager.storesShip(with: fetchedShipId)
        }.forEach {
            guard let insertedShip = coreDaraManager.insertShip($0) else { return }
            fetchShipImage(insertedShip)
        }
    }
    
    private func fetchShipsFromCD() {
        var fetchedCDShips: [CDShip]
        
        if !userStatusManager.isGuest, let userEmail = userStatusManager.userEmail {
            fetchedCDShips = coreDaraManager.fetchShipsForUser(with: userEmail)
        } else {
            fetchedCDShips = coreDaraManager.fetchShips()
        }
        
        let fetchedShips = fetchedCDShips.map { shipMapper.map($0) }
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
    func fetchShipsFromAPI() {
        networkingManager.fetchData(with: base + subdirectory) { [weak self] result in
            DispatchQueue.main.async {
                if let data = try? result.get() {
                    self?.saveAPIFetchedShips(data)
                }
                self?.fetchShipsFromCD()
            }
        }
    }
    
    func deleteShip(_ indexPath: IndexPath) {
        var shipsSections = ships.value
        let shipToDelete = shipsSections[indexPath.section].items.remove(at: indexPath.row)
        ships.accept(shipsSections)
        
        guard !userStatusManager.isGuest, let userEmail = userStatusManager.userEmail else { return }
        coreDaraManager.deleteShip(with: shipToDelete.id, for: userEmail)
    }
    
    func restoreShips() {
        let fetchedCDShips: [CDShip]
        
        if !userStatusManager.isGuest, let userEmail = userStatusManager.userEmail {
            coreDaraManager.restoreShipsForUser(with: userEmail)
            fetchedCDShips = coreDaraManager.fetchShipsForUser(with: userEmail)
        } else {
            fetchedCDShips = coreDaraManager.fetchShips()
        }
        
        let fetchedShips = fetchedCDShips.map { shipMapper.map($0) }
        ships.accept([AnimatableSectionModel(model: "", items: fetchedShips)])
    }
    
    func getShipDetailsViewModel(for ship: Ship) -> ShipDetailsViewModel {
        ShipDetailsViewModel(ship, networkConnectionManager: networkConnectionManager)
    }
    
    func isGuest() -> Bool {
        userStatusManager.isGuest
    }
}
