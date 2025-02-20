//
//  CDShip+CoreDataProperties.swift
//  
//
//  Created by Vlad Klunduk on 14/02/2025.
//
//

import Foundation
import CoreData
import RxDataSources


extension CDShip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDShip> {
        return NSFetchRequest<CDShip>(entityName: "CDShip")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var port: String?
    @NSManaged public var roles: [String]?
    @NSManaged public var type: String?
    @NSManaged public var weight: NSNumber?
    @NSManaged public var year: NSNumber?
    @NSManaged public var isRemoved: Bool
    @NSManaged public var imageUrlString: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension CDShip {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: CDUser)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: CDUser)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension CDShip: IdentifiableType {
    public var identity: String {
        id ?? ""
    }
    
    public typealias Identity = String
}
