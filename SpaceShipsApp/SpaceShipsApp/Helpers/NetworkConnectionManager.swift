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
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected.accept(path.status == .satisfied)
        }
        monitor.start(queue: monitoringQueue)
    }
}
