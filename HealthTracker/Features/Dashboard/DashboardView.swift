//
//  DashboardView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: HealthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:20){
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 4){
                            Text("Merhaba 👋")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Bügünkü Sağlık")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Text(Date().formatted(.dateTime.day().month(.wide)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Loading
                    if viewModel.isLoading {
                        ProgressView("Veriler yükleniyor...")
                            .padding()
                    }
                    
                    // Hata Mesajı
                    if let error = viewModel.errorMessage {
                        HStack{
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Metrik Kartlar
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        MetricCardView(
                            title: "Adım", value: viewModel.stepsFormatted, icon: "figure.walk", color: .blue, progress: viewModel.stepsProgress
                        )
                        MetricCardView(
                            title: "Kalp Atışı", value: viewModel.heartRateFormatted, icon: "heart.fill", color: .red
                        )
                        
                        MetricCardView(
                            title: "Kalori", value: viewModel.caloriesFormatted, icon:  "flame.fill", color: .orange
                        )
                        
                        MetricCardView(
                            title: "Hedef", value: "10.000", icon: "target", color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    Button{
                        Task{
                            await viewModel.fetchAllData()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "arrow.clockwise")
                            Text("Verileri Yenile")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("HealthTracker")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
    
    
}

#Preview {
    DashboardView()
        .environmentObject(HealthViewModel())
}
