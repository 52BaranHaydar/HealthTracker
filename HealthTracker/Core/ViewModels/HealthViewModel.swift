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
    @Published var savedMetrics: [HealthMetric] = []
    
    private let healthKitService = HealthKitService.shared
    private let databaseService = DatabaseService.shared
    
    init() {
        print("🚀 HealthViewModel init çalıştı")
            loadMockData()
            isAuthorized = true
            Task {
                print("📦 Task başladı")
                await syncToFirebase()
                await loadFromFirebase()
            }
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        steps = 7432
        heartRate = 72
        calories = 380
    }
    
    // MARK: - Firebase'e Kaydet
    func syncToFirebase() async {
        print("🔥 syncToFirebase çağrıldı - steps: \(steps)")
            await databaseService.saveDailyMetrics(
                steps: steps,
                heartRate: heartRate,
                calories: calories
            )
            print("✅ Firebase'e senkronize edildi")
    }
    
    // MARK: - Firebase'den Yükle
    func loadFromFirebase() async {
        isLoading = true
        do {
            savedMetrics = try await databaseService.fetchMetrics()
            print("✅ \(savedMetrics.count) kayıt yüklendi")
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: - Verileri Yenile
    func fetchAllData() async {
        loadMockData()
        await syncToFirebase()
        await loadFromFirebase()
    }
    
    // MARK: - Formatted
    var stepsFormatted: String { String(format: "%.0f", steps) }
    var heartRateFormatted: String { String(format: "%.0f BPM", heartRate) }
    var caloriesFormatted: String { String(format: "%.0f kcal", calories) }
    var stepsProgress: Double { min(steps / 10000, 1.0) }
}
