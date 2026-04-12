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
    
    // MARK: - Published Properties
    @Published var currentWater: Double = 0
    @Published var dailyGoal: Double = 2500
    @Published var waterLogs: [WaterLog] = []
    
    // MARK: - Su Miktarları (ml)
    let waterAmounts: [Double] = [150, 200, 250, 350, 500]
    
    init() {
        loadFromCoreData()
    }
    
    // MARK: - CoreData'dan Yükle
    func loadFromCoreData() {
        waterLogs = CoreDataManager.shared.fetchWaterLogs(for: Date())
        currentWater = waterLogs.map { $0.amount }.reduce(0, +)
        print("✅ \(waterLogs.count) su kaydı yüklendi")
    }
    
    // MARK: - Su Ekle
    func addWater(_ amount: Double) {
        let now = Date()
        CoreDataManager.shared.saveWaterLog(amount: amount, time: now)
        let log = WaterLog(amount: amount, time: now)
        waterLogs.append(log)
        currentWater += amount
        
        Task {
            await saveToFirebase(amount: amount)
        }
    }
    
    // MARK: - Son Kaydı Sil
    func removeLastLog() {
        guard let last = waterLogs.last else { return }
        CoreDataManager.shared.deleteLastWaterLog()
        waterLogs.removeLast()
        currentWater -= last.amount
    }
    
    // MARK: - Firebase'e Kaydet
    private func saveToFirebase(amount: Double) async {
        let metric = HealthMetric(
            type: .water,
            value: amount,
            unit: "ml"
        )
        try? await DatabaseService.shared.saveMetric(metric)
    }
    
    // MARK: - Progress
    var progress: Double {
        min(currentWater / dailyGoal, 1.0)
    }
    
    var progressFormatted: String {
        String(format: "%.0f%%", progress * 100)
    }
    
    var currentWaterFormatted: String {
        if currentWater >= 1000 {
            return String(format: "%.1f L", currentWater / 1000)
        }
        return String(format: "%.0f ml", currentWater)
    }
    
    var dailyGoalFormatted: String {
        String(format: "%.1f L", dailyGoal / 1000)
    }
    
    var remainingWater: Double {
        max(0, dailyGoal - currentWater)
    }
    
    var remainingFormatted: String {
        if remainingWater >= 1000 {
            return String(format: "%.1f L", remainingWater / 1000)
        }
        return String(format: "%.0f ml", remainingWater)
    }
    
    // MARK: - Durum Mesajı
    var statusMessage: String {
        switch progress {
        case 0..<0.25: return "Susadın! Su içme vakti 💧"
        case 0.25..<0.50: return "İyi başlangıç, devam et! 👍"
        case 0.50..<0.75: return "Yarıyı geçtin, harika! 🌊"
        case 0.75..<1.0: return "Neredeyse tamamladın! ⚡"
        default: return "Günlük hedefini tamamladın! 🎉"
        }
    }
}

// MARK: - WaterLog Model
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
