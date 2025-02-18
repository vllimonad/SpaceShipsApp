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
    var isConnectedToInternet: BehaviorRelay<Bool> { get }
    func fetchShips()
    func fetchShipImage(_ ship: CDShip)
    func deleteShip(_ indexPath: IndexPath)
    func deleteAllShips()
}

final class ShipsListViewModel: ShipsListViewModelProtocol {
    private let networkingManager: APIFetchable
    private let coreDaraManager: CoreDataManagable
    private let networkConnectionManager: NetworkConnectionManagable
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = BehaviorRelay(value: [AnimatableSectionModel<String, CDShip>]())
    let isGuest: Bool
    var isConnectedToInternet = BehaviorRelay<Bool>(value: true)
    
    init(isGuest: Bool, networkManager: APIFetchable = NetworkingManager(), coreDaraManager: CoreDataManagable = CoreDataManager(), networkConnectionManager: NetworkConnectionManagable = NetworkConnectionManager()) {
        self.isGuest = isGuest
        self.networkingManager = networkManager
        self.coreDaraManager = coreDaraManager
        self.networkConnectionManager = networkConnectionManager
        setupBindings()
    }
    
    private func setupBindings() {
        networkConnectionManager.isConnected.bind(to: isConnectedToInternet).disposed(by: DisposeBag())
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
                    self?.ships.accept([AnimatableSectionModel(model: "", items: ships.filter { !$0.isRemoved })])
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
    
    func deleteShip(_ indexPath: IndexPath) {
        let ship = ships.value[indexPath.section].items[indexPath.row]
        coreDaraManager.deleteShip(ship)
        let ships = coreDaraManager.fetchShips().filter { !$0.isRemoved }
        self.ships.accept([AnimatableSectionModel(model: "", items: ships)])
    }
}
