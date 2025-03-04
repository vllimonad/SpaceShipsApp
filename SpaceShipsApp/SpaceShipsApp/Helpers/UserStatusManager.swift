//
//  UserStatusManager.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 01/03/2025.
//

import Foundation

protocol UserStatusManagable {
    var isGuest: Bool { get }
    var userEmail: String? { get }
}

final class UserStatusManager: UserStatusManagable {
    var isGuest: Bool
    var userEmail: String?
    
    init(isGuest: Bool, userEmail: String?) {
        self.isGuest = isGuest
        self.userEmail = userEmail
    }
}
