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
    func fetchShips() -> [CDShip]
    func insertShip(_ fetchedShip: [String: Any]) -> CDShip?
    func storesShip(with id: String) -> Bool
    func updateShip(_ ship: CDShip, with imageData: Data)
}

final class CoreDataManager {
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let shipEntityName = "CDShip"
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension CoreDataManager: CoreDataManagable {
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
    
    func insertShip(_ fetchedShip: [String: Any]) -> CDShip? {
        guard let entity = NSEntityDescription.entity(forEntityName: shipEntityName, in: context) else { return nil }
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
        return ship
    }
    
    func storesShip(with id: String) -> Bool {
        let fetchRequest = CDShip.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let response = (try? context.fetch(fetchRequest)) ?? []
        return !response.isEmpty
    }
    
    func updateShip(_ ship: CDShip, with imageData: Data) {
        ship.imageData = NSData(data: imageData)
        saveContext()
    }
}
