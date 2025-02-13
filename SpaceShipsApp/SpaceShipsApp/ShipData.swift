//
//  ShipData.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 13/02/2025.
//

import Foundation

struct ShipData: Decodable {
    var ship_id: String
    var image: String
    var ship_name: String
    var ship_type: String
    var year_built: Int
    var weight_kg: Int
    var home_port: String
    var roles: [String]
}
