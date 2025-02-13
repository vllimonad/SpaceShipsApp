//
//  ShipsMapper.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation

protocol ShipsMappable {
    func map(_ data: Data) -> [Ship]
}

final class ShipsMapper: ShipsMappable {
    func map(_ data: Data) -> [Ship] {
        var ships: [Ship] = []
        guard let fetchedShips = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return ships }
        for fetchedShip in fetchedShips {
            let id = fetchedShip["ship_id"] as! String
            let image = fetchedShip["image"] as! String
            let name = fetchedShip["ship_name"] as! String
            let type = fetchedShip["ship_type"] as! String
            let year = fetchedShip["year_built"] as! Int
            let weight = fetchedShip["weight_kg"] as! Int
            let port = fetchedShip["home_port"] as! String
            let roles = fetchedShip["roles"] as! [String]
            let ship = Ship(id: id, image: image, name: name, type: type, year: year, weight: weight, port: port, roles: roles)
            ships.append(ship)
        }
        return ships
    }
}
