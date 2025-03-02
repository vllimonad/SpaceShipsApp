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
    var shipDetailsRows: BehaviorRelay<[ShipDetailRow]> { get }
    var isConnectedToInternet: BehaviorRelay<Bool> { get }
}

final class ShipDetailsViewModel: ShipDetailsViewModelProtocol {
    private let networkConnectionManager: NetworkConnectionManagable
    private let disposeBag = DisposeBag()
    
    var shipImageData = BehaviorRelay<Data?>(value: nil)
    var shipDetailsRows = BehaviorRelay<[ShipDetailRow]>(value: [])
    var isConnectedToInternet = BehaviorRelay<Bool>(value: true)

    init(_ ship: Ship, networkConnectionManager: NetworkConnectionManagable) {
        self.networkConnectionManager = networkConnectionManager
        setupBindings()
        setDetailsRows(ship)
    }
    
    private func setupBindings() {
        networkConnectionManager.isConnected.bind(to: isConnectedToInternet).disposed(by: disposeBag)
    }
    
    private func setDetailsRows(_ ship: Ship) {
        var shipDetails = [ShipDetailRow]()
        let shipDetailsNames = ["Name", "Type", "Year", "Weight(kg)", "Home port", "Roles"]
        let valueAbsenceString = "Unknown"
        
        let type = ship.type ?? valueAbsenceString
        let year = ship.year == nil ? valueAbsenceString : "\(ship.year!)"
        let weight = ship.weight == nil ? valueAbsenceString : "\(ship.weight!)"
        let port = ship.port ?? valueAbsenceString
        let roles = ship.roles ?? [valueAbsenceString]
        let rolesString = roles.joined(separator: "\n")
        let shipDetailsValues = [ship.name, type, year, weight, port, rolesString]
        
        for (index, name) in shipDetailsNames.enumerated() {
            shipDetails.append(ShipDetailRow(name: name, value: shipDetailsValues[index]))
        }
        
        shipImageData.accept(ship.imageData)
        shipDetailsRows.accept(shipDetails)
    }
}
