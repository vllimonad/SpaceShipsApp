//
//  Ship.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 27/02/2025.
//

import Foundation
import RxDataSources

struct Ship {
    var id: String
    var name: String
    var port: String?
    var roles: [String]?
    var type: String?
    var weight: Int?
    var year: Int?
    var imageUrlString: String?
    var imageData: Data?
}

extension Ship: IdentifiableType, Equatable {
    public var identity: String {
        id
    }
    
    public typealias Identity = String
}
