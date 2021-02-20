//
//  AppDelegate.swift
//  QuickNote
//
//  Created by Théo Brouillé on 06/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let noteListViewController = NoteListViewController()
        window.rootViewController = UINavigationController(rootViewController: noteListViewController)
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}
