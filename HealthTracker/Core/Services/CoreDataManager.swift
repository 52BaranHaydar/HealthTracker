//
//  CoreDataManager.swift
//  HealthTracker
//
//  Created by Baran on 12.04.2026.
//
import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HealthTrackerModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData yüklenemedi: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
            print("✅ CoreData kaydedildi")
        } catch {
            print("❌ CoreData kayıt hatası: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Water Log CRUD
    func saveWaterLog(amount: Double, time: Date) {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "WaterLogEntity",
            into: context
        )
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(amount, forKey: "amount")
        entity.setValue(time, forKey: "time")
        save()
        print("✅ Su kaydı eklendi: \(amount) ml")
    }
    
    func fetchWaterLogs(for date: Date) -> [WaterLog] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "WaterLogEntity")
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(
            format: "time >= %@ AND time < %@",
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { obj in
                guard
                    let amount = obj.value(forKey: "amount") as? Double,
                    let time = obj.value(forKey: "time") as? Date
                else { return nil }
                return WaterLog(amount: amount, time: time)
            }
        } catch {
            print("❌ Su kayıtları getirilemedi: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteLastWaterLog() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "WaterLogEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            if let last = results.first {
                context.delete(last)
                save()
                print("✅ Son su kaydı silindi")
            }
        } catch {
            print("❌ Silme hatası: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Health Metric CRUD
    func saveHealthMetric(type: String, value: Double, unit: String, date: Date) {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "HealthMetricEntity",
            into: context
        )
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(type, forKey: "type")
        entity.setValue(value, forKey: "value")
        entity.setValue(unit, forKey: "unit")
        entity.setValue(date, forKey: "date")
        save()
    }
    
    func fetchHealthMetrics(type: String, for date: Date) -> Double {
        let request = NSFetchRequest<NSManagedObject>(entityName: "HealthMetricEntity")
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(
            format: "type == %@ AND date >= %@ AND date < %@",
            type,
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first?.value(forKey: "value") as? Double ?? 0
        } catch {
            print("❌ Metrik getirilemedi: \(error.localizedDescription)")
            return 0
        }
    }
    
    // MARK: - User Profile CRUD
    func saveUserProfile(name: String, age: Int, weight: Double, height: Double,
                         stepGoal: Double, waterGoal: Double, calorieGoal: Double) {
        // Önce mevcut profili sil
        deleteUserProfile()
        
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "UserProfileEntity",
            into: context
        )
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(name, forKey: "name")
        entity.setValue(age, forKey: "age")
        entity.setValue(weight, forKey: "weight")
        entity.setValue(height, forKey: "height")
        entity.setValue(stepGoal, forKey: "dailyStepGoal")
        entity.setValue(waterGoal, forKey: "dailyWaterGoal")
        entity.setValue(calorieGoal, forKey: "dailyCalorieGoal")
        save()
        print("✅ Profil CoreData'ya kaydedildi")
    }
    
    func fetchUserProfile() -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "UserProfileEntity")
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Profil getirilemedi: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func deleteUserProfile() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "UserProfileEntity")
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            save()
        } catch {
            print("❌ Profil silinemedi: \(error.localizedDescription)")
        }
    }
}
