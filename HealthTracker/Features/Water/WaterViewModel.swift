//
//  WaterViewModel.swift
//  HealthTracker
//
//  Created by Baran on 11.04.2026.
//

import Foundation
import Combine

@MainActor
class WaterViewModel: ObservableObject {
    
    @Published var currentWater: Double = 0
    @Published var dailyGoal: Double = 2500
    @Published var waterLogs: [WaterLog] = []
    
    // Su Miktarları
    let waterAmounts: [Double] = [150,200,250,300,500]
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        waterLogs = [
            WaterLog(amount: 250, time: Date().addingTimeInterval(-7200)),
            WaterLog(amount: 350, time: Date().addingTimeInterval(-5400)),
            WaterLog(amount: 200, time: Date().addingTimeInterval(-3600))
        ]
        currentWater = waterLogs.map { $0.amount }.reduce(0, +)
    }
    
    
    func addWater(_ amount: Double) {
        let log = WaterLog(amount: amount, time: Date())
        waterLogs.append(log)
        currentWater += amount
        
        Task{
            await saveToFirebase(amount: amount)
        }
    }
    
    func removeLastLog(){
        guard let last = waterLogs.last else { return }
        waterLogs.removeLast()
        currentWater -= last.amount
    }
    
    private func saveToFirebase(amount: Double) async {
        let metric = HealthMetric(
            type: .water, value: amount, unit: "ml"
        )
        try? await DatabaseService.shared.saveMetric(metric)
    }
    
    var progress: Double{
        min(currentWater / dailyGoal, 1.0)
    }
    
    var progressFormatted: String {
        String(format: "%.0f%%", progress * 100)
    }
    
    var currentWaterFormatted: String {
        if currentWater >= 1000{
            return String(format: "%.1f L", currentWater / 1000)
        }
        return String(format: "%.0f ml", currentWater)
    }
    
    var dailyGoalFormatted: String {
            String(format: "%.1f L", dailyGoal / 1000)
        }
    
    var remaniningWater: Double{
        max(0, dailyGoal - currentWater)
    }
    
    var remainingFormatted: String {
        if remaniningWater >= 1000{
            return String(format: "%.1f L", remaniningWater / 1000)
        }
        return String(format: "%.0f ml", remaniningWater)
    }
    
    var statusMessage: String {
        switch progress {
        case 0..<0.25: return "Susadın! Su içme vakti 💧"
        case 0.25..<0.50: return "İyi başlangıç, devam et 👍"
        case 0.5..<0.75: return "Yarıyı geçtin, harika 🌊"
        case 0.75..<1.0: return "Neredeyse tamamladın! ⚡"
        default: return "Günlük hedefini tamamladın! 🎉"
        }
    }
}

struct WaterLog: Identifiable {
    let id: UUID
    let amount: Double
    let time: Date
    
    init(amount: Double, time: Date) {
        self.id = UUID()
        self.amount = amount
        self.time = time
    }
    
    var amountFormatted: String {
        String(format: "%.0f ml", amount)
    }
    
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}
