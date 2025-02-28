//
//  ShipDetailsViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 15/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol ShipDetailsViewModelProtocol {
    var shipImageData: BehaviorRelay<Data?> { get }
    var shipDetailsValues: BehaviorRelay<[String]> { get }
    var shipDetailsNames: [String] { get }
    var isConnectedToInternet: BehaviorRelay<Bool> { get }
}

final class ShipDetailsViewModel: ShipDetailsViewModelProtocol {
    private let networkConnectionManager: NetworkConnectionManagable
    private let disposeBag = DisposeBag()
    
    var shipImageData = BehaviorRelay<Data?>(value: nil)
    var shipDetailsValues = BehaviorRelay<[String]>(value: [])
    let shipDetailsNames = ["Name", "Type", "Year", "Weight(kg)", "Home port", "Roles"]
    var isConnectedToInternet = BehaviorRelay<Bool>(value: true)

    init(_ ship: Ship, networkConnectionManager: NetworkConnectionManagable) {
        self.networkConnectionManager = networkConnectionManager
        setupBindings()
        setDetailsValues(ship)
    }
    
    private func setupBindings() {
        networkConnectionManager.isConnected.bind(to: isConnectedToInternet).disposed(by: disposeBag)
    }
    
    private func setDetailsValues(_ ship: Ship) {
        let valueAbcenceString = "Unknown"
        let type = ship.type ?? valueAbcenceString
        let year = ship.year == nil ? valueAbcenceString : "\(ship.year!)"
        let weight = ship.weight == nil ? valueAbcenceString : "\(ship.weight!)"
        let port = ship.port ?? valueAbcenceString
        let roles = ship.roles ?? [valueAbcenceString]
        let rolesString = roles.joined(separator: "\n")
        
        shipImageData.accept(ship.imageData)
        shipDetailsValues.accept([ship.name, type, year, weight, port, rolesString])
    }
}
