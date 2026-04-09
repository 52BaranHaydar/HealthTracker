//
//  HealtMetric.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation

struct HealtMetric: Identifiable, Codable {
    let id: UUID
    let type: MetricType
    let value: Double
    let unit: String
    let date: Date
    
    init(id: UUID, type: MetricType, value: Double, unit: String, date: Date) {
        self.id = id
        self.type = type
        self.value = value
        self.unit = unit
        self.date = date
    }
}
enum MetricType: String, Codable, CaseIterable{
    case steps = "Adım"
    case heartRate = "Kalp Atışı"
    case calories = "Kalori"
    case sleep = "Uyku"
    case water = "Su"
}
