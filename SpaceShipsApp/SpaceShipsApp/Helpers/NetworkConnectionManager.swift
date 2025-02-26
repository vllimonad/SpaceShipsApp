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
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let monitoringQueue = DispatchQueue(label: "Monitoring queue")
    
    var isConnected = BehaviorRelay<Bool>(value: false)
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected.accept(isConnected)
        }
        
        monitor.start(queue: monitoringQueue)
    }
    
    deinit {
        monitor.cancel()
    }
}
