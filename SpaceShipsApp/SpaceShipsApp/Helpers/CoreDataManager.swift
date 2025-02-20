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
    func storesShip(with id: String) -> Bool
    func updateShip(_ ship: CDShip, with imageData: Data)
    func deleteShip(_ ship: CDShip, for userEmail: String)
    func deleteAllShips()
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
    
    private func fetchUsers() -> [CDUser] {
        var cdUsers = [CDUser]()
        let fetchRequest = CDUser.fetchRequest()
        do {
            cdUsers = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return cdUsers
    }
    
    func insertUser(with email: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: userEntityName, in: context) else { return }
        let user = CDUser(entity: entityDescription, insertInto: context)
        let ships = fetchShips()
        user.email = email
        user.addToShips(NSSet(array: ships)) 
        saveContext()
    }
    
    private func fetchUser(with email: String) -> CDUser? {
        let fetchRequest = CDUser.fetchRequest()
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        return try? context.fetch(fetchRequest).first
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
    
    func fetchShipsForUser(with email: String) -> [CDShip] {
//        let ships = fetchShips()
//        let filtred = ships.filter({
//            $0.users?.contains(T##anObject: Any##Any)
//        })
        guard
            let cdUser = fetchUser(with: email),
            let cdShips = cdUser.ships?.allObjects as? [CDShip]
        else { return [] }
        return cdShips.sorted(by: { $0.name! < $1.name! })
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
        ship.users = NSSet(array: users)
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
    
    func deleteShip(_ ship: CDShip, for userEmail: String) {
        guard let cdUser = fetchUser(with: userEmail) else { return }
        cdUser.removeFromShips(ship)
        saveContext()
    }
    
    func deleteAllShips() {
        let ships = fetchShips()
        for ship in ships {
            context.delete(ship)
        }
        let users = fetchUsers()
        for user in users {
            context.delete(user)
        }
        saveContext()
    }
}
