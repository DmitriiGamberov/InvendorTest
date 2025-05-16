//
//  NetworkMonitor.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Network

protocol NetworkStatusProvider {
    var isConnected: Bool { get }
}

final class NetworkMonitor: NetworkStatusProvider {
    private let monitor = NWPathMonitor()
    private(set) var isConnected = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
}
