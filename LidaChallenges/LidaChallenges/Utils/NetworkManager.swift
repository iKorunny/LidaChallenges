//
//  NetworkManager.swift
//  LidaChallenges
//
//  Created by Лидия on 16.03.25.
//

import Network
import Foundation

extension Notification.Name {
    static let networkAvailabilityChanged = Notification.Name("NetworkMonitorNetworkAvailabilityChanged")
}

extension NWInterface.InterfaceType: @retroactive CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let queue = DispatchQueue(label: "NetworkConnectivityManager")
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false {
        didSet {
            if isConnected != oldValue {
                NotificationCenter.default.post(name: NSNotification.Name.networkAvailabilityChanged, object: nil)
            }
        }
    }
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
