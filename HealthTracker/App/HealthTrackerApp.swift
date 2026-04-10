//
//  HealthTrackerApp.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import SwiftUI
import Firebase

@main
struct HealthTrackerApp: App {
    @StateObject private var healthViewModel = HealthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthViewModel)
        }
    }
}
