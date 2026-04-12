//
//  ProfileViewModel.swift
//  HealthTracker
//
//  Created by Baran on 11.04.2026.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject{
    
    @Published var name:String = "Baran Haydar"
    @Published var age: Int = 25
    @Published var weight: Double = 75
    @Published var height: Double = 100
    @Published var dailyStepGoal: Double = 10000
    @Published var dailyWaterGoal: Double = 2500
    @Published var dailyCalorieGoal: Double = 500
    
    var bmi : Double{
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    var bmiFormatted: String{
        String(format: "%.1f", bmi)
    }
    
    var bmiCategory: String{
        switch bmi {
        case 0..<18.5: return "Zayıf"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Fazla Kilolu"
        default: return "Obez"
        }
    }
    
    var bmiColor: String{
        switch bmi{
        case 0..<18.5: return "blue"
        case 18.5..<25: return "green"
        case 25..<30: return "orange"
        default: return "red"
        }
    }
    
    var idealWeight: String{
        let minWeight = 18.5 * (height / 100) * (height / 100)
        let maxWeight = 24.9 * (height / 100) * (height / 100)
        return String(format: "%.0f - %.0f kg", minWeight, maxWeight)
    }
    
    
    // Kaydet
    func saveProfile(){
        UserDefaults.standard.set(name, forKey: "profile_name")
        UserDefaults.standard.set(age, forKey: "profile_Age")
        UserDefaults.standard.set(weight, forKey: "profile_weight")
        UserDefaults.standard.set(height, forKey: "profile_height")
        UserDefaults.standard.set(dailyStepGoal, forKey: "profile_stepGoal")
        UserDefaults.standard.set(dailyWaterGoal, forKey: "profile_waterGoal")
        UserDefaults.standard.set(dailyCalorieGoal, forKey: "profile_calorieGoal")
        print("Profil Kaydedildi")
    }
    
    
    func loadProfile(){
        if let savedName = UserDefaults.standard.string(forKey: "profile_name"){
            name = savedName
        }
        let savedAge = UserDefaults.standard.integer(forKey: "profile_age")
        if savedAge > 0 { age = savedAge }
        
        let savedWeight = UserDefaults.standard.double(forKey: "profile_weight")
        if savedWeight > 0 { weight = savedWeight }
        
        
        let savedHeight = UserDefaults.standard.double(forKey: "profile_height")
        if savedHeight > 0{ height = savedHeight } else{
            height = 180
        }
        
        let savedStepGoal = UserDefaults.standard.double(forKey: "profile_stepGoal")
        if savedStepGoal > 0 { dailyStepGoal = savedStepGoal }
        
        let savedWaterGoal = UserDefaults.standard.double(forKey: "profile_waterGoal")
        if savedWaterGoal > 0 { dailyWaterGoal = savedWaterGoal }
        
        let savedCalorieGoal = UserDefaults.standard.double(forKey: "profile_calorieGoal")
        if savedCalorieGoal > 0 { dailyCalorieGoal = savedCalorieGoal }
        
    }
    
    
}
