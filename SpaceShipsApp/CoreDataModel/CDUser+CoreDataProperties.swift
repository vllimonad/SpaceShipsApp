//
//  CDUser+CoreDataProperties.swift
//  
//
//  Created by Vlad Klunduk on 19/02/2025.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var ships: NSSet?

}

// MARK: Generated accessors for ships
extension CDUser {

    @objc(addShipsObject:)
    @NSManaged public func addToShips(_ value: CDShip)

    @objc(removeShipsObject:)
    @NSManaged public func removeFromShips(_ value: CDShip)

    @objc(addShips:)
    @NSManaged public func addToShips(_ values: NSSet)

    @objc(removeShips:)
    @NSManaged public func removeFromShips(_ values: NSSet)

}
