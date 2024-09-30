//
//  NetworkMonitor.swift
//  CWK2Template
//
//  Created by Chamika Sakalasuriya on 2024-01-06.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    @Published var isActive = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
