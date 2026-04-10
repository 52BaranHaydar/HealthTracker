//
//  StepsView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import SwiftUI
import Charts

struct StepsView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    @StateObject private var stepsViewModel: StepsViewModel = {
        StepsViewModel()
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Ana Metrik
                    VStack(spacing: 8) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text(viewModel.stepsFormatted)
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("adım")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 20)
                        
                        Circle()
                            .trim(from: 0, to: viewModel.stepsProgress)
                            .stroke(
                                Color.blue,
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1), value: viewModel.stepsProgress)
                        
                        VStack {
                            Text("\(Int(viewModel.stepsProgress * 100))%")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("hedefe ulaşıldı")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 200, height: 200)
                    .padding()
                    
                    // MARK: - Hedef Bilgisi
                    HStack(spacing: 20) {
                        VStack {
                            Text("Günlük Hedef")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("10.000")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        VStack {
                            Text("Kalan Adım")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(max(0, Int(10000 - viewModel.steps)))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Motivasyon
                    HStack {
                        Image(systemName: viewModel.stepsProgress >= 1 ? "star.fill" : "flame.fill")
                            .foregroundColor(viewModel.stepsProgress >= 1 ? .yellow : .orange)
                        Text(motivationText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // MARK: - Haftalık Grafik
                    WeeklyStepsChart(weeklySteps: stepsViewModel.weeklySteps)
                        .padding(.horizontal)
                    
                    // MARK: - Haftalık İstatistikler
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text("Ortalama")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(stepsViewModel.averageStepsFormatted)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        VStack(spacing: 4) {
                            Text("En İyi Gün")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(stepsViewModel.bestDay)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text(stepsViewModel.bestStepsFormatted)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Adımlar")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    var motivationText: String {
        switch viewModel.stepsProgress {
        case 0..<0.25: return "Harika bir başlangıç! Devam et 💪"
        case 0.25..<0.50: return "İyi gidiyorsun! Yarıya yaklaştın 🏃"
        case 0.50..<0.75: return "Süper! Hedefe yaklaşıyorsun 🔥"
        case 0.75..<1.0: return "Neredeyse tamamladın! Son sprint! ⚡"
        default: return "Günlük hedefini tamamladın! 🎉"
        }
    }
}

#Preview {
    StepsView()
        .environmentObject(HealthViewModel())
}
