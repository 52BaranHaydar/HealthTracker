//
//  NotificationService.swift
//  HealthTracker
//
//  Created by Baran on 12.04.2026.
//

import Foundation
import UserNotifications

class NotificationService{
    
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    
    // İzin İste
    func requestAuthorization() async throws{
        let granted = try await center.requestAuthorization(
            options: [.alert, .badge, .sound]
        )
        print(granted ? "✅ Bildirim izni verildi" : "❌ Bildirim izni reddedildi")
    }
    
    // Su hatırlatıcısı
    func scheduleWaterReminders(){
        center.removePendingNotificationRequests(
            withIdentifiers: (0..<24).map { "water_\($0)"}
        )
        
        let hours = [8,10,12,14,16,18,20,22]
        
        for hour in hours{
            let content = UNMutableNotificationContent()
            content.title = "💧 Su İçme Vakti!"
            content.body = "Günlük su hedefine ulaşmak için bir bardak su iç."
            content.sound = .default
            content.badge = 1
            
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents, repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "water_\(hour)", content: content, trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("❌ Su bildirimi hatası: \(error.localizedDescription)")
                }
            }
        }
        print("✅ Su hatırlatıcıları ayarlandı")
    }
    
    func scheduleStepReminder(currentSteps: Double, goal: Double) {
        
        center.removePendingNotificationRequests(withIdentifiers: ["step_reminder"])
        
        guard currentSteps < goal else { return }
        
        let content = UNMutableNotificationContent()
        let remaining = Int(goal - currentSteps)
        content.title = "🏃 Adım Hedefin Bekliyor!"
        content.body = "Hedefe ulaşmak için \(remaining)"
        content.sound = .default
        
        // Her gün 19.00'da hatırlar
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true
        )
        
        let requet = UNNotificationRequest(
            identifier: "step_reminder", content: content, trigger: trigger
        )
        
        center.add(requet){error in
            if let error = error {
                print("❌ Adım bildirimi hatası: \(error.localizedDescription)")
            }
        }
        print("✅ Adım hatırlatıcısı ayarlandı")
    }
    
    func scheduleDailySummary() {
        center.removePendingNotificationRequests(withIdentifiers: ["daily_summary"])
        
        let content = UNMutableNotificationContent()
        content.title = "📊 Günlük Sağlık Özeti"
        content.body = "Bugünkü sağlık verilerini görüntülemek için uygulamayı aç."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "daily_summary",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ Özet bildirimi hatası: \(error.localizedDescription)")
            }
        }
        print("✅ Günlük özet bildirimi ayarlandı")
    }
    
    func cancelAllNotifications(){
        center.removeAllPendingNotificationRequests()
        print("✅ Tüm bildirimler iptal edildi")
    }
    
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
}
