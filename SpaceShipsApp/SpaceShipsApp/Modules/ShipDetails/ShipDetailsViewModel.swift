//
//  ShipDetailsViewModel.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 15/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class ShipDetailsViewModel {
    var imageData = ReplayRelay<NSData?>.create(bufferSize: 1)
    var detailsValues = ReplayRelay<[String]>.create(bufferSize: 1)
    let detailsNames = ["Name", "Type", "Year", "Weight(kg)", "Home port", "Roles"]
    
    init(_ ship: CDShip) {
        updateShipData(ship)
    }
    
    private func updateShipData(_ ship: CDShip) {
        let name = ship.name ?? ""
        let type = ship.type ?? ""
        let year = ship.year == nil ? "Unknown" : "\(ship.year!)"
        let weight = ship.weight == nil ? "Unknown" : "\(ship.weight!)"
        let port = ship.port ?? ""
        let roles = ship.roles ?? []
        let rolesString = roles.joined(separator: "\n")
        imageData.accept(ship.imageData)
        detailsValues.accept([name, type, year, weight, port, rolesString])
    }
}
