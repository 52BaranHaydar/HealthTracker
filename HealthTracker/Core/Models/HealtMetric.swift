//
//  HealtMetric.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation

struct HealthMetric: Identifiable, Codable {
    let id: UUID
    let type: MetricType
    let value: Double
    let unit: String
    let date: Date
    
    init(id: UUID = UUID(), type: MetricType, value: Double, unit: String, date: Date = Date()) {
        self.id = id
        self.type = type
        self.value = value
        self.unit = unit
        self.date = date
    }
}

enum MetricType: String, Codable, CaseIterable {
    case steps = "Adım"
    case heartRate = "Kalp Atışı"
    case calories = "Kalori"
    case sleep = "Uyku"
    case water = "Su"
}
