//
//  HealtKitService.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation
import HealthKit

class HealthKitService {
    
    static let shared = HealthKitService()
    private let healthStore = HKHealthStore()
    
    // İzin istenen Veri Tipleri
    private let readTypes: Set<HKObjectType> = [
        
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    ]
    
    // HealthKit Mevcut Mu
    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    // İzin iste
    func requestAuthorization() async throws{
        guard isAvailable else{
            throw HealthKitError.notAvailable
        }
        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
    }
    
    // Adım Sayısı
    func fetchSteps(for date: Date) async throws -> Double {
            let type = HKQuantityType(.stepCount)
            let predicate = HKQuery.predicateForSamples(
                withStart: Calendar.current.startOfDay(for: date),
                end: date
            )
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in _ = result }
            
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKStatisticsQuery(
                    quantityType: type,
                    quantitySamplePredicate: predicate,
                    options: .cumulativeSum
                ) { _, result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    continuation.resume(returning: steps)
                }
                healthStore.execute(query)
            }
        }
        
    // MARK: - Kalp Atışı
    func fetchHeartRate() async throws -> Double {
        let type = HKQuantityType(.heartRate)
        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.startOfDay(for: Date()), end: Date()
            )
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type, quantitySamplePredicate: predicate, options: .discreteAverage
                ) { _, result, error in
                if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let bpm = result?.averageQuantity()?.doubleValue(
                        for: HKUnit.count().unitDivided(by: .minute())
                    ) ?? 0
                    continuation.resume(returning: bpm)
            }
            healthStore.execute(query)
        }
    }
        
    // MARK: - Kalori
    func fetchCalories() async throws -> Double {
        let type = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date()
        )
        
        return try await withCheckedThrowingContinuation{ continuation in
            let query = HKStatisticsQuery(
                quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum
            ) {
                _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                let cal = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: cal)
            }
            healthStore.execute(query)
        }
        
    }

    // MARK: - Error
    
    
}

enum HealthKitError: Error, LocalizedError {
    case notAvailable
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit bu cihazda kullanılamıyor."
        }
    }
}
