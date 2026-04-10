//
//  ContentView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    
    var body: some View {
        DashboardView()
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthViewModel())
}
