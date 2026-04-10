//
//  DatabaseService.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation
import FirebaseFirestore

class DatabaseService {
    
    static let shared = DatabaseService()
    private let db = Firestore.firestore()
    
    // Koleksiyon adı
    private let collection = "healthMetrics"
    
    // Veri Kaydet
    func saveMetric(_ metric: HealthMetric) async throws {
        let data: [String: Any] = [
            "id": metric.id.uuidString,
            "type": metric.type.rawValue,
            "value" : metric.value,
            "unit": metric.unit,
            "date": Timestamp(date: metric.date)
        ]
        
        try await db
            .collection(collection)
            .document(metric.id.uuidString)
            .setData(data)
        
        print("Firestore'a kaydedildi: \(metric.type.rawValue) - \(metric.value)")
    }
    
    // Verileri Getir
    func fetchMetrics() async throws -> [HealthMetric] {
        
        let snapshot = try await db
            .collection(collection)
            .order(by: "date", descending: true)
            .limit(to: 50)
            .getDocuments()
        
        return snapshot.documents.compactMap{ doc -> HealthMetric? in
        
            let data = doc.data()
            guard
                let idString = data["id"] as? String,
                let id = UUID(uuidString: idString),
                let typeRaw = data["type"] as? String,
                let type = MetricType(rawValue: typeRaw),
                let value = data["value"] as? Double,
                let unit = data["unit"] as? String,
                let timestamp = data["date"] as? Timestamp
            else { return nil }
            
            return HealthMetric(
                id: id, type: type, value: value, unit: unit, date: timestamp.dateValue()
            )
            
        }
        
    }
    
    func saveDailyMetrics(steps: Double, heartRate: Double, calories: Double) async {
        let metrics = [
            HealthMetric(id: UUID(), type: .steps,value: steps, unit: "adım", date: Date()),
            HealthMetric(id: UUID(), type: .heartRate, value: heartRate, unit: "BPM", date: Date()),
            HealthMetric(id: UUID(), type: .calories, value: calories, unit: "kcal", date: Date())
        ]
            
        for metric in metrics {
            do {
                try await saveMetric(metric)
            } catch {
                print("❌ Kayıt hatası: \(error.localizedDescription)")
            }
        }
    }

    
}
