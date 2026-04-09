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
    
    // Published Properties
    @Published var steps: Double = 0
    @Published var heartRate: Double = 0
    @Published var calories: Double = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAuthorized: Bool = false
    
    // Service
    
    private let healthKitService =  HealthKitService.shared
    
    // Init
    init(){
        Task{
            await requestPermission()
        }
    }
    
    // İzin İste
    func requestPermission() async {
        do{
            try await healthKitService.requestPermission()
            isAuthorized = true
            await fetchAllData()
        } catch{
            errorMessage = error.localizedDescription
        }
    }
    
    // Tüm veriyi Çek
    func fetchAllData() async {
        isLoading = true
        errorMessage = nil
        
        async let stepsResult = healthKitService.fetchSteps(for: Date())
        async let heartRateResult = healthKitService.fetchHeartRate()
        async let caloriesResult = healthKitService.fetchCalories()
        
        do{
            let (s,h,c) = try await (stepsResult, heartRateResult, caloriesResult)
            steps = s
            heartRate = h
            calories = c
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    var stepsFormatted: String {
        String(format: "%.0f", steps)
    }
    
    var heartRateFormatted: String {
        String(format: "%.0f BPM", heartRate)
    }
    
    var caloriesFormatted: String {
        String(format: "%.0f kcal", calories)
    }
    
    // Progres (hedef: 10.000 adım)
    
    var stepsProgress: Double {
        min(steps / 10000, 1.0)
    }
    
    
    
    
}
