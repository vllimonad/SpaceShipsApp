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
    func fetchShipImage(_ ship: CDShip)
    func deleteShip(_ indexPath: IndexPath)
    func deleteAllShips()
    func getShipDetailsViewModel(_ ship: CDShip) -> ShipDetailsViewModel
}

final class ShipsListViewModel: ShipsListViewModelProtocol {
    private let networkingManager: APIFetchable
    private let coreDaraManager: CoreDataManagable
    private let networkConnectionManager: NetworkConnectionManagable
    private let disposeBag = DisposeBag()
    
    private let base = "https://api.spacexdata.com/v3"
    private let subdirectory = "/ships"
    
    var ships = BehaviorRelay(value: [AnimatableSectionModel<String, CDShip>]())
    let isGuest: Bool
    
    init(isGuest: Bool, networkManager: APIFetchable = NetworkingManager(), coreDaraManager: CoreDataManagable = CoreDataManager(), networkConnectionManager: NetworkConnectionManagable) {
        self.isGuest = isGuest
        self.networkingManager = networkManager
        self.coreDaraManager = coreDaraManager
        self.networkConnectionManager = networkConnectionManager
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
            let fetchedShipId = $0["ship_id"] as! String
            return !coreDaraManager.storesShip(with: fetchedShipId)
        }.forEach {
            let insertedShip = coreDaraManager.insertShip($0)
            fetchShipImage(insertedShip!)
        }
    }
    
    private func fetchCDShips() {
        let fetchedCDShips = coreDaraManager.fetchShips()
        let sections = [AnimatableSectionModel(model: "", items: fetchedCDShips.filter { !$0.isRemoved })]
        self.ships.accept(sections)
    }
    
    func getShipDetailsViewModel(_ ship: CDShip) -> ShipDetailsViewModel {
        ShipDetailsViewModel(ship, networkConnectionManager: networkConnectionManager)
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
