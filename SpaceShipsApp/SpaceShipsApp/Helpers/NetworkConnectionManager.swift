//
//  NetworkConnectionManager.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 18/02/2025.
//

import Foundation
import RxSwift
import RxCocoa
import Network

protocol NetworkConnectionManagable {
    var isConnected: BehaviorRelay<Bool> { get }
}

final class NetworkConnectionManager: NetworkConnectionManagable {
    private let monitor = NWPathMonitor()
    private let monitoringQueue = DispatchQueue(label: "Monitoring queue")
    
    let isConnected = BehaviorRelay<Bool>(value: true)
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected.accept(true)
            } else {
                self?.isConnected.accept(false)
            }
        }
        monitor.start(queue: monitoringQueue)
    }
}
