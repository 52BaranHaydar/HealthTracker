//
//  StepsView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import SwiftUI

struct StepsView : View {
    
    @EnvironmentObject var viewModel : HealthViewModel
    
    var body: some View {
        NavigationStack{
            
            ScrollView{
                VStack(spacing:24){
                    
                    // Ana Metrik
                    VStack(spacing:8){
                        Image(systemName: "figure.walk")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        
                        Text(viewModel.stepsFormatted)
                            .font(.system(size: 72, weight: .bold))
                            .foregroundStyle(.primary)
                        
                        Text("adım")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top,20)
                    
                    // Progress Circle
                    
                    ZStack{
                        Circle()
                            .stroke(Color.blue.opacity(0.2))
                        
                        Circle()
                            .trim(from: 0, to: viewModel.stepsProgress)
                            .stroke(
                                Color.blue
                                ,style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1), value: viewModel.stepsProgress)
                        
                        VStack{
                            Text("\(Int(viewModel.stepsProgress * 100))%")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Hedefe ulaşıldı")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 200, height: 200)
                    .padding()
                    
                    
                    
                    // Hedef Bilgisi
                    HStack(spacing: 20){
                        VStack{
                            Text("Günlük Hedef")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("10.000")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        
                        VStack{
                            
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
                    
                    
                    HStack{
                        Image(systemName: viewModel.stepsProgress >= 1 ? "star.fill" : "flame.fill")
                        
                        Text(motivationText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
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
