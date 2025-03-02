//
//  ShipMapper.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 27/02/2025.
//

import Foundation

protocol ShipMappable {
    func map(_ cdShip: CDShip) -> Ship
}

struct ShipMapper: ShipMappable {
    func map(_ cdShip: CDShip) -> Ship {
        let id = cdShip.id ?? ""
        let name = cdShip.name ?? ""
        let type = cdShip.type
        let year = cdShip.year as? Int
        let port = cdShip.port
        let weight = cdShip.weight as? Int
        let roles = cdShip.roles
        let imageUrlString = cdShip.imageUrlString
        let imageData = cdShip.imageData as? Data
        return Ship(id: id, name: name, port: port, roles: roles, type: type, weight: weight, year: year, imageUrlString: imageUrlString, imageData: imageData )
    }
}
