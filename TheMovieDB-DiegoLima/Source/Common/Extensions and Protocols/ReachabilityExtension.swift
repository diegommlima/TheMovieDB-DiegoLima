//
//  ReachabilityExtension.swift
//  TheMovieDB-DiegoLima
//
//  Created by Diego Marlon Medeiros Lima on 3/1/18.
//  Copyright © 2018 Diego Marlon Medeiros Lima. All rights reserved.
//

import Reachability

extension Reachability {
    // MARK: - Private Computed Properties
    private static let defaultHost = "www.google.com"
    private static var reachability = Reachability(hostname: defaultHost)
    
    // MARK: - Public Functions
    
    /// True value if there is a stable network connection
    static var isConnected: Bool {
        guard let reachability = Reachability.reachability else { return false }
        
        return reachability.connection != .none
    }
    
    /// Current network status based on enum NetworkStatus
    static var status: Connection {
        guard let reachability = Reachability.reachability else { return .none }
        
        return reachability.connection
    }
}
