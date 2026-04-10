//
//  WaterView.swift
//  HealthTracker
//
//  Created by Baran on 11.04.2026.
//

import SwiftUI

struct WaterView: View {
    
    @StateObject private var waterViewModel = WaterViewModel()
    @State private var selectedAmount: Double = 250
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:24){
                    
                    // Su Dalgası Animasyonu
                    ZStack{
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 3)
                            .frame(width: 200,height: 200)
                        
                        // Doluluk göstergesi
                        Circle()
                            .trim(from: 0, to: waterViewModel.progress)
                            .stroke(Color.blue,
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 200,height: 200)
                            .animation(.easeInOut(duration: 0.8), value: waterViewModel.progress)
                        
                        VStack(spacing: 4){
                            Text("💧")
                                .font(.system(size: 40))
                            Text(waterViewModel.currentWaterFormatted)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                            Text("/ \(waterViewModel.dailyGoalFormatted)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top,20)
                    
                    // Durum Mesajı
                    Text(waterViewModel.statusMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    
                    HStack(spacing:16) {
                        VStack(spacing:4) {
                            Text("İçilen")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(waterViewModel.currentWaterFormatted)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        
                        VStack(spacing: 4) {
                            Text("Kalan")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(waterViewModel.remainingFormatted)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        VStack(spacing: 4) {
                            Text("Hedef")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(waterViewModel.dailyGoalFormatted)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Miktar Seçici
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ne kadar içtin?")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing:10) {
                            ForEach(waterViewModel.waterAmounts, id: \.self) { amount in
                                
                                Button{
                                    selectedAmount = amount
                                } label: {
                                    VStack(spacing:4){
                                        Text("💧")
                                            .font(.title3)
                                        Text("\(Int(amount))")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                        Text("ml")
                                            .font(.caption2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical,12)
                                    .background(
                                        selectedAmount == amount ? Color.blue : Color(.systemGray6)
                                    )
                                    .foregroundColor(
                                        selectedAmount == amount ? .white : .primary
                                    )
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Button{
                        waterViewModel.addWater(selectedAmount)
                    } label: {
                        HStack{
                            Image(systemName: "plus.circle.fill")
                            Text("\(Int(selectedAmount)) ml Ekle")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    
                    // Günlük Log
                    if !waterViewModel.waterLogs.isEmpty {
                        VStack(alignment: .leading){
                            HStack{
                                Text("Bügünkü Kayıtlar")
                                    .font(.headline)
                                Spacer()
                                Button{
                                    waterViewModel.removeLastLog()
                                } label: {
                                    Text("Son Kaydı Sil")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal)
                            
                            ForEach(waterViewModel.waterLogs.reversed()) { log in
                                HStack{
                                    Text("💧")
                                    Text(log.amountFormatted)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text(log.timeFormatted)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom,20)
            }
            .navigationTitle("Su Takibi")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
#Preview {
    WaterView()
}
