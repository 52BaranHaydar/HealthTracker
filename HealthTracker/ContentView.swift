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
        TabView {
            DashboardView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "heart.fill")
                }
            
            StepsView()
                .tabItem {
                    Label("Adımlar", systemImage: "figure.walk")
                }
            
            HeartRateView()
                .tabItem {
                    Label("Kalp", systemImage: "waveform.path.ecg")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthViewModel())
}

