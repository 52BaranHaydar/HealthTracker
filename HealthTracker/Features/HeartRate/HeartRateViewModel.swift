//
//  HeartRateViewModel.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation
import Combine

@MainActor
class HeartRateViewModel: ObservableObject {
    
    @Published var hourlyHeartRates: [HeartRateEntry] = []
    @Published var minHearhRate: Double = 0
    @Published var maxHeartRate: Double = 0
    @Published var averageHeartRate: Double = 0
    
    init(){
        loadMockData()
    }
    
    private func loadMockData(){
        let mockValues: [Double] = [65,68,72,75,80,78,72,70,68,72,75,71]
        let hours = ["08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]
        hourlyHeartRates = zip(hours, mockValues).map { hour, bpm in
            HeartRateEntry(hour: "\(hour):00", bpm: bpm)
        }
        
        minHearhRate = mockValues.min() ?? 0
        maxHeartRate = mockValues.max() ?? 0
        averageHeartRate = mockValues.reduce(0, +) / Double(mockValues.count)
    }
    
    var minFormatted: String {
        String(format: "%.0f", minHearhRate)
    }
    
    var maxFormatted: String {
        String(format: "%.0f", maxHeartRate)
    }
    
    var averageFormatted: String {
        String(format: "%.0f", averageHeartRate)
    }
    
    var maxBPM: Double {
        hourlyHeartRates.map { $0.bpm }.max() ?? 100
    }
    
    var heartRateStatus: String{
        switch averageHeartRate {
        case 0..<60: return "Düşük"
        case 60...100: return "Normal"
        case 101...140: return "Yüksek"
        default: return "Çok Yüksek"
        }
    }
    
    var heartRateStatusColor: String{
        switch averageHeartRate {
        case 0..<60: return "blue"
        case 60...100: return "green"
        case 101...140: return "orange"
        default: return "red"
        }
    }
    
    
}


struct HeartRateEntry: Identifiable {
    let id = UUID()
    let hour: String
    let bpm: Double
    
    var bpmFormatted: String {
        String(format: "%.0f", bpm)
    }
    
    var progress: Double {
        min(bpm / 200, 1.0)
    }
}
