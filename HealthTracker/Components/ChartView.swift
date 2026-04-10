//
//  ChartView.swift
//  HealthTracker
//
//  Created by Baran on 9.04.2026.
//
import SwiftUI
import Charts

// MARK: - Haftalık Adım Grafiği
struct WeeklyStepsChart: View {
    let weeklySteps: [DailyStep]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Haftalık Adımlar")
                .font(.headline)
                .padding(.horizontal)
            
            Chart(weeklySteps) { step in
                BarMark(
                    x: .value("Gün", step.day),
                    y: .value("Adım", step.steps)
                )
                .foregroundStyle(step.isToday ? Color.blue : Color.blue.opacity(0.4))
                .cornerRadius(6)
                .annotation(position: .top) {
                    if step.isToday {
                        Text(step.stepsFormatted)
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let steps = value.as(Double.self) {
                            Text("\(Int(steps/1000))k")
                                .font(.caption2)
                        }
                    }
                    AxisGridLine()
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .font(.caption2)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .blue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Kalp Atışı Grafiği
struct HeartRateChart: View {
    let entries: [HeartRateEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Günlük Kalp Atışı")
                .font(.headline)
                .padding(.horizontal)
            
            Chart(entries) { entry in
                LineMark(
                    x: .value("Saat", entry.hour),
                    y: .value("BPM", entry.bpm)
                )
                .foregroundStyle(Color.red.opacity(0.8))
                .lineStyle(StrokeStyle(lineWidth: 2.5))
                
                AreaMark(
                    x: .value("Saat", entry.hour),
                    y: .value("BPM", entry.bpm)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.red.opacity(0.3), Color.red.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                PointMark(
                    x: .value("Saat", entry.hour),
                    y: .value("BPM", entry.bpm)
                )
                .foregroundStyle(Color.red)
                .symbolSize(30)
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel()
                        .font(.caption2)
                    AxisGridLine()
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: 3)) { value in
                    AxisValueLabel()
                        .font(.caption2)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .red.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            WeeklyStepsChart(weeklySteps: [
                DailyStep(day: "Pzt", steps: 6200, isToday: false),
                DailyStep(day: "Sal", steps: 8900, isToday: false),
                DailyStep(day: "Çar", steps: 5400, isToday: false),
                DailyStep(day: "Per", steps: 10200, isToday: false),
                DailyStep(day: "Cum", steps: 7800, isToday: false),
                DailyStep(day: "Cmt", steps: 9100, isToday: false),
                DailyStep(day: "Paz", steps: 7432, isToday: true)
            ])
            
            HeartRateChart(entries: [
                HeartRateEntry(hour: "08:00", bpm: 65),
                HeartRateEntry(hour: "10:00", bpm: 72),
                HeartRateEntry(hour: "12:00", bpm: 80),
                HeartRateEntry(hour: "14:00", bpm: 75),
                HeartRateEntry(hour: "16:00", bpm: 70),
                HeartRateEntry(hour: "18:00", bpm: 72)
            ])
        }
        .padding()
    }
}
