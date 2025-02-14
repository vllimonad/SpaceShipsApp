//
//  CoreDataManager.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 14/02/2025.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataManagable {
    func saveContext()
    func fetchShips() -> [CDShip]
    func insertShip(_ fetchedShip: [String: Any])
    func fetchShipById(_ id: String) -> CDShip?
}

final class CoreDataManager {
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let shipEntityName = "CDShip"
}

extension CoreDataManager: CoreDataManagable {
    func saveContext() {
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchShips() -> [CDShip] {
        var cdShips = [CDShip]()
        let fetchRequest = CDShip.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            cdShips = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return cdShips
    }
    
    func insertShip(_ fetchedShip: [String: Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: shipEntityName, in: context) else { return }
        let ship = CDShip(entity: entity, insertInto: context)
        ship.id = fetchedShip["ship_id"] as? String
        ship.name = fetchedShip["ship_name"] as? String
        ship.type = fetchedShip["ship_type"] as? String
        ship.year = fetchedShip["year_built"] as? NSNumber
        ship.weight = fetchedShip["weight_kg"] as? NSNumber
        ship.port = fetchedShip["home_port"] as? String
        ship.roles = fetchedShip["roles"] as? [String]
        ship.imageUrlString = fetchedShip["image"] as? String
        ship.isRemoved = false
        saveContext()
    }
    
    func fetchShipById(_ id: String) -> CDShip? {
        let fetchRequest = CDShip.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return try? context.fetch(fetchRequest).first
    }
}
