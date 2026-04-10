//
//  DashboardViewModel.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var greeting: String = ""
    @Published var currentDate: String = ""
    
    private let healthViewModel: HealthViewModel
    
    init(healthViewModel: HealthViewModel){
        self.healthViewModel = healthViewModel
        setupGreeting()
        setupDate()
    }
    
    private func setupGreeting(){
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
            case 6..<12:
                greeting = "Günaydın ☀️"
            case 12..<17:
                greeting = "İyi Öğlenler 🌤"
            case 17..<21:
                greeting = "İyi Akşamlar 🌆"
            default:
                greeting = "İyi Geceler 🌙"
        }
    }
    
    // Tarih Formatı
    private func setupDate(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        currentDate = formatter.string(from: Date())
    }
    
    // Özet Mesajı
    var summaryMessage: String {
        let steps = healthViewModel.steps
        switch steps{
        case 0..<3000:
            return "Bügün daha az hareket ettin 🛋"
        case 3000..<7000:
            return "Harika gidiyorsun 👟"
        case 7000..<10000:
            return "Harika gidiyorsun 🏃"
        default:
            return "Günlük hedefi geçtin ! 🏆"
        }
    
    }
    
    
    
    
    
}
