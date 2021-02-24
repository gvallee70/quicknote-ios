//
//  SettingsBundleHelper.swift
//  QuickNote
//
//  Created by Théo Brouillé on 21/02/2021.
//

import Foundation

enum Environment: String {
    case production
    case development
    
    var url: String {
        switch self {
        case .development:
            return "http://localhost:8080"
        case .production:
            return "https://quicknote-app.herokuapp.com"
        }
    }
}

class SettingsBundleHelper {
    static let shared = SettingsBundleHelper()
    private init() {}
    
    var currentEnvironment: Environment {
        if let env = UserDefaults.standard.string(forKey: "current-environment") {
            return Environment(rawValue: env.lowercased()) ?? Environment.production
        }
        return Environment.production
    }
}
