//
//  ProfileView.swift
//  HealthTracker
//
//  Created by Baran on 11.04.2026.
//
import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var isEditing = false
    @State private var showingSaved = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Avatar
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 100, height: 100)
                            Text(profileViewModel.name.prefix(2).uppercased())
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        Text(profileViewModel.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(profileViewModel.age) yaş • \(Int(profileViewModel.height)) cm • \(Int(profileViewModel.weight)) kg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - BMI Kartı
                    VStack(spacing: 12) {
                        HStack {
                            Text("Vücut Kitle İndeksi")
                                .font(.headline)
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                Text(profileViewModel.bmiFormatted)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(bmiColor)
                                Text(profileViewModel.bmiCategory)
                                    .font(.subheadline)
                                    .foregroundColor(bmiColor)
                            }
                            Divider()
                                .frame(height: 60)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("İdeal Kilo")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(profileViewModel.idealWeight)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            Spacer()
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .green, .orange, .red],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 8)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 16, height: 16)
                                    .shadow(radius: 2)
                                    .offset(x: bmiIndicatorOffset(width: geo.size.width))
                            }
                        }
                        .frame(height: 16)
                        
                        HStack {
                            Text("Zayıf")
                            Spacer()
                            Text("Normal")
                            Spacer()
                            Text("Fazla")
                            Spacer()
                            Text("Obez")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.15), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // MARK: - Kişisel Bilgiler
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Kişisel Bilgiler")
                            .font(.headline)
                        
                        ProfileRow(
                            title: "Ad Soyad",
                            value: $profileViewModel.name,
                            isEditing: isEditing
                        )
                        
                        HStack {
                            Text("Yaş")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            if isEditing {
                                Stepper("\(profileViewModel.age)", value: $profileViewModel.age, in: 10...100)
                                    .fixedSize()
                            } else {
                                Text("\(profileViewModel.age) yaş")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        SliderRow(
                            title: "Boy",
                            value: $profileViewModel.height,
                            range: 140...220,
                            unit: "cm",
                            isEditing: isEditing
                        )
                        
                        SliderRow(
                            title: "Kilo",
                            value: $profileViewModel.weight,
                            range: 40...150,
                            unit: "kg",
                            isEditing: isEditing
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // MARK: - Günlük Hedefler
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Günlük Hedefler")
                            .font(.headline)
                        
                        GoalRow(
                            title: "Adım Hedefi",
                            value: $profileViewModel.dailyStepGoal,
                            range: 1000...30000,
                            step: 500,
                            unit: "adım",
                            icon: "figure.walk",
                            color: .blue,
                            isEditing: isEditing
                        )
                        
                        GoalRow(
                            title: "Su Hedefi",
                            value: $profileViewModel.dailyWaterGoal,
                            range: 500...5000,
                            step: 250,
                            unit: "ml",
                            icon: "drop.fill",
                            color: .cyan,
                            isEditing: isEditing
                        )
                        
                        GoalRow(
                            title: "Kalori Hedefi",
                            value: $profileViewModel.dailyCalorieGoal,
                            range: 100...2000,
                            step: 50,
                            unit: "kcal",
                            icon: "flame.fill",
                            color: .orange,
                            isEditing: isEditing
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // MARK: - Bildirim Ayarları
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Bildirim Ayarları")
                            .font(.headline)
                        
                        NotificationToggleRow(
                            title: "Su Hatırlatıcısı",
                            subtitle: "Her 2 saatte bir hatırlat",
                            icon: "drop.fill",
                            color: .cyan,
                            action: {
                                Task {
                                    try? await NotificationService.shared.requestAuthorization()
                                    NotificationService.shared.scheduleWaterReminders()
                                }
                            }
                        )
                        
                        NotificationToggleRow(
                            title: "Adım Hatırlatıcısı",
                            subtitle: "Her gün 19:00'da hatırlat",
                            icon: "figure.walk",
                            color: .blue,
                            action: {
                                Task {
                                    try? await NotificationService.shared.requestAuthorization()
                                    NotificationService.shared.scheduleStepReminder(
                                        currentSteps: 0,
                                        goal: 10000
                                    )
                                }
                            }
                        )
                        
                        NotificationToggleRow(
                            title: "Günlük Özet",
                            subtitle: "Her gün 21:00'da özet gönder",
                            icon: "chart.bar.fill",
                            color: .purple,
                            action: {
                                Task {
                                    try? await NotificationService.shared.requestAuthorization()
                                    NotificationService.shared.scheduleDailySummary()
                                }
                            }
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Kaydet" : "Düzenle") {
                        if isEditing {
                            profileViewModel.saveProfile()
                            showingSaved = true
                        }
                        isEditing.toggle()
                    }
                    .fontWeight(.medium)
                }
            }
            .alert("Kaydedildi! ✅", isPresented: $showingSaved) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text("Profil bilgileriniz güncellendi.")
            }
            .onAppear {
                profileViewModel.loadProfile()
            }
        }
    }
    
    var bmiColor: Color {
        switch profileViewModel.bmi {
        case 0..<18.5: return .blue
        case 18.5..<25: return .green
        case 25..<30: return .orange
        default: return .red
        }
    }
    
    func bmiIndicatorOffset(width: Double) -> Double {
        let bmi = profileViewModel.bmi
        let minBMI = 15.0
        let maxBMI = 40.0
        let clampedBMI = min(max(bmi, minBMI), maxBMI)
        let ratio = (clampedBMI - minBMI) / (maxBMI - minBMI)
        return ratio * (width - 16)
    }
}

// MARK: - Profile Row
struct ProfileRow: View {
    let title: String
    @Binding var value: String
    let isEditing: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Spacer()
            if isEditing {
                TextField(title, text: $value)
                    .multilineTextAlignment(.trailing)
                    .font(.subheadline)
                    .fontWeight(.medium)
            } else {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Slider Row
struct SliderRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    let isEditing: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            if isEditing {
                Slider(value: $value, in: range, step: 1)
                    .tint(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Goal Row
struct GoalRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let icon: String
    let color: Color
    let isEditing: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            if isEditing {
                Slider(value: $value, in: range, step: step)
                    .tint(color)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Notification Toggle Row
struct NotificationToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isEnabled = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .tint(color)
                .onChange(of: isEnabled) { _, newValue in
                    if newValue {
                        action()
                    } else {
                        NotificationService.shared.cancelAllNotifications()
                    }
                }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
}
