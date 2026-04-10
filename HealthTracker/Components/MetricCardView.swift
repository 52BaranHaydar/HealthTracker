//
//  MetricCardView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//

import SwiftUI

struct MetricCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var progress:Double? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Spacer()
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            
            if let progress = progress {
                VStack(alignment: .leading, spacing: 4){
                    ProgressView(value: progress)
                        .tint(color)
                    
                    Text("\(Int(progress * 100))% hedefe ulaşıldı")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: color.opacity(0.15),radius: 8,x: 0,y: 4)
        )
        
        
    }
}

#Preview {
    VStack(spacing: 16) {
        MetricCardView(
            title: "Adım",
            value: "8,432",
            icon: "figure.walk",
            color: .blue,
            progress: 0.84
        )
        MetricCardView(
            title: "Kalp Atışı",
            value: "72 BPM",
            icon: "heart.fill",
            color: .red
        )
        MetricCardView(
            title: "Kalori",
            value: "480 kcal",
            icon: "flame.fill",
            color: .orange
        )
    }
    .padding()
}
