//
//  HealthViewModel.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation
import Combine

@MainActor
class HealthViewModel: ObservableObject {
    
    @Published var steps: Double = 0
    @Published var heartRate: Double = 0
    @Published var calories: Double = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAuthorized: Bool = false
    
    private let healthKitService = HealthKitService.shared
    
    init() {
        Task {
            await requestPermissions()
        }
    }
    
    func requestPermissions() async {
        #if targetEnvironment(simulator)
        // Simulator'da mock data kullan
        loadMockData()
        isAuthorized = true
        #else
        // Gerçek cihazda HealthKit kullan
        do {
            try await healthKitService.requestAuthorization()
            isAuthorized = true
            await fetchAllData()
        } catch {
            errorMessage = error.localizedDescription
            loadMockData()
        }
        #endif
    }
    
    func fetchAllData() async {
        #if targetEnvironment(simulator)
        loadMockData()
        #else
        isLoading = true
        errorMessage = nil
        
        async let stepsResult = healthKitService.fetchSteps(for: Date())
        async let heartRateResult = healthKitService.fetchHeartRate()
        async let caloriesResult = healthKitService.fetchCalories()
        
        do {
            let (s, h, c) = try await (stepsResult, heartRateResult, caloriesResult)
            steps = s
            heartRate = h
            calories = c
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        #endif
    }
    
    // MARK: - Mock Data (Simulator için)
    private func loadMockData() {
        steps = 7432
        heartRate = 72
        calories = 380
    }
    
    // MARK: - Formatted Values
    var stepsFormatted: String {
        String(format: "%.0f", steps)
    }
    
    var heartRateFormatted: String {
        heartRate == 0 ? "-- BPM" : String(format: "%.0f BPM", heartRate)
    }
    
    var caloriesFormatted: String {
        String(format: "%.0f kcal", calories)
    }
    
    var stepsProgress: Double {
        min(steps / 10000, 1.0)
    }
}
