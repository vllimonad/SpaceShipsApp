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
    func fetchShipsForUser(with email: String) -> [CDShip]
    func fetchShips() -> [CDShip]
    func insertShip(_ fetchedShip: [String: Any]) -> CDShip?
    func storesShip(with shipID: String) -> Bool
    func updateShip(_ ship: CDShip, with imageData: Data)
    func deleteShip(with shipID: String, for userEmail: String)
    func restoreShipsForUser(with email: String)
}

final class CoreDataManager {
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let shipEntityName = "CDShip"
    private let userEntityName = "CDUser"
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fetchShip(with id: String) -> CDShip? {
        let fetchRequest = CDShip.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        let ship = try? context.fetch(fetchRequest).first
        return ship
    }
    
    private func fetchUsers() -> [CDUser] {
        var users = [CDUser]()
        let fetchRequest = CDUser.fetchRequest()
        
        do {
            users = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return users
    }
    
    private func fetchUser(with email: String) -> CDUser? {
        let fetchRequest = CDUser.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        let user = try? context.fetch(fetchRequest).first
        return user
    }
    
    func insertUser(with email: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: userEntityName, in: context) else { return }
        let user = CDUser(entity: entityDescription, insertInto: context)
        let ships = fetchShips()
        user.email = email
        user.addToShips(NSSet(array: ships))
        saveContext()
    }
}

extension CoreDataManager: CoreDataManagable {
    func fetchShips() -> [CDShip] {
        var ships = [CDShip]()
        let fetchRequest = CDShip.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            ships = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ships
    }
    
    func fetchShipsForUser(with email: String) -> [CDShip] {
        var ships = fetchShips()
        guard let user = fetchUser(with: email) else { return [] }
        ships = ships.filter { $0.users?.contains(user) ?? false }
        return ships
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
        
        let users = fetchUsers()
        ship.addToUsers(NSSet(array: users))
        saveContext()
        return ship
    }
    
    func storesShip(with shipID: String) -> Bool {
        let fetchRequest = CDShip.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", shipID)
        let response = (try? context.fetch(fetchRequest)) ?? []
        return !response.isEmpty
    }
    
    func updateShip(_ ship: CDShip, with imageData: Data) {
        ship.imageData = NSData(data: imageData)
        saveContext()
    }
    
    func deleteShip(with shipID: String, for userEmail: String) {
        guard 
            let user = fetchUser(with: userEmail),
            let ship = fetchShip(with: shipID)
        else { return }
        
        user.removeFromShips(ship)
        saveContext()
    }
    
    func restoreShipsForUser(with email: String) {
        guard let user = fetchUser(with: email) else { return }
        let ships = fetchShips()
        user.ships = NSSet(array: ships)
        saveContext()
    }
}
