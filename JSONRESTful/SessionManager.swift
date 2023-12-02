//
//  SessionManager.swift
//  JSONRESTful
//
//  Created by Leonardo Coaquira on 2/12/23.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()

    var usuario: Users?

    private init() {}
}
