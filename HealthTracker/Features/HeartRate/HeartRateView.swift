//
//  HeartRateView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import SwiftUI

struct HeartRateView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Kalp Animasyonu
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 180, height: 180)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.red)
                            .scaleEffect(isAnimating ? 1.15 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                    .padding(.top, 20)
                    .onAppear { isAnimating = true }
                    
                    // MARK: - BPM Değeri
                    VStack(spacing: 4) {
                        Text(String(format: "%.0f", viewModel.heartRate))
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.primary)
                        Text("BPM")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    // MARK: - Durum Kartı
                    HStack {
                        Image(systemName: heartStatusIcon)
                            .foregroundColor(heartStatusColor)
                        Text(heartStatusText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(heartStatusColor)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(heartStatusColor.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // MARK: - Normal Aralık Bilgisi
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Normal Aralıklar")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            heartRangeRow(label: "Dinlenme", range: "60-100 BPM", color: .green)
                            heartRangeRow(label: "Hafif Egzersiz", range: "100-140 BPM", color: .orange)
                            heartRangeRow(label: "Yoğun Egzersiz", range: "140-170 BPM", color: .red)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Kalp Atışı")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func heartRangeRow(label: String, range: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
                .font(.subheadline)
            Spacer()
            Text(range)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    var heartStatusText: String {
        switch viewModel.heartRate {
        case 0..<60: return "Düşük — Doktora danışın"
        case 60...100: return "Normal — Harika durumdasın!"
        case 101...140: return "Yüksek — Dinlenmeyi deneyin"
        default: return "Çok Yüksek — Dikkat!"
        }
    }
    
    var heartStatusColor: Color {
        switch viewModel.heartRate {
        case 0..<60: return .blue
        case 60...100: return .green
        case 101...140: return .orange
        default: return .red
        }
    }
    
    var heartStatusIcon: String {
        switch viewModel.heartRate {
        case 60...100: return "checkmark.circle.fill"
        default: return "exclamationmark.triangle.fill"
        }
    }
}

#Preview {
    HeartRateView()
        .environmentObject(HealthViewModel())
}
