//
//  StepsViewModel.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//
import Combine
import Foundation

@MainActor
class StepsViewModel: ObservableObject {
    
    @Published var weeklySteps: [DailyStep] = []
    @Published var averageSteps: Double = 0
    @Published var bestDay: String = ""
    @Published var bestSteps: Double = 0
    
    init() {
        loadWeeklyMockData()
    }
    
    private func loadWeeklyMockData() {
        let mockValues: [Double] = [6200, 8900, 5400, 10200, 7800, 9100, 7432]
        let dayNames = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]
        
        weeklySteps = (0..<7).map { index in
            DailyStep(
                day: dayNames[index],
                steps: mockValues[index],
                isToday: index == 6
            )
        }
        
        averageSteps = weeklySteps.map { $0.steps }.reduce(0, +) / Double(weeklySteps.count)
        
        if let best = weeklySteps.max(by: { $0.steps < $1.steps }) {
            bestDay = best.day
            bestSteps = best.steps
        }
    }
    
    var maxSteps: Double {
        weeklySteps.map { $0.steps }.max() ?? 10000
    }
    
    var averageStepsFormatted: String {
        String(format: "%.0f", averageSteps)
    }
    
    var bestStepsFormatted: String {
        String(format: "%.0f", bestSteps)
    }
}

struct DailyStep: Identifiable {
    let id = UUID()
    let day: String
    let steps: Double
    let isToday: Bool
    
    var stepsFormatted: String {
        String(format: "%.0f", steps)
    }
    
    var progress: Double {
        min(steps / 10000, 1.0)
    }
}
