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
    var shipImageData: ReplayRelay<NSData?> { get }
    var shipDetailsValues: ReplayRelay<[String]> { get }
    var shipDetailsNames : [String] { get }
}

final class ShipDetailsViewModel: ShipDetailsViewModelProtocol {
    var shipImageData = ReplayRelay<NSData?>.create(bufferSize: 1)
    var shipDetailsValues = ReplayRelay<[String]>.create(bufferSize: 1)
    let shipDetailsNames = ["Name", "Type", "Year", "Weight(kg)", "Home port", "Roles"]
    
    init(_ ship: CDShip) {
        updateShipData(ship)
    }
    
    private func updateShipData(_ ship: CDShip) {
        let valueAbcenceString = "Unknown"
        let name = ship.name ?? valueAbcenceString
        let type = ship.type ?? valueAbcenceString
        let year = ship.year == nil ? valueAbcenceString : "\(ship.year!)"
        let weight = ship.weight == nil ? valueAbcenceString : "\(ship.weight!)"
        let port = ship.port ?? valueAbcenceString
        let roles = ship.roles ?? [valueAbcenceString]
        let rolesString = roles.joined(separator: "\n")
        shipImageData.accept(ship.imageData)
        shipDetailsValues.accept([name, type, year, weight, port, rolesString])
    }
}
