# HealthTracker

A modern iOS health tracking app built with SwiftUI and HealthKit.

![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-yellow)
![iOS](https://img.shields.io/badge/iOS-17+-lightgrey)

## Features
- Dashboard with daily health metrics
- Step counter with progress circle
- Heart rate monitoring with status
- Calorie tracking
- Cloud sync via Firebase Firestore
- HealthKit integration

## Tech Stack
- UI: SwiftUI
- Architecture: MVVM
- Health Data: HealthKit
- Database: Firebase Firestore
- Version Control: Git + GitHub
- Minimum iOS: iOS 17+

## Architecture MVVM
- App: HealthTrackerApp
- Core/Models: HealthMetric
- Core/ViewModels: HealthViewModel
- Core/Services: HealthKitService, DatabaseService
- Features/Dashboard: DashboardView, DashboardViewModel
- Features/Steps: StepsView, StepsViewModel
- Features/HeartRate: HeartRateView, HeartRateViewModel
- Components: MetricCardView, ChartView

## Setup
1. Clone the repo
2. Open HealthTracker.xcodeproj
3. Add your GoogleService-Info.plist from Firebase Console
4. Run on iOS 17+

## Author
Baran Haydar
GitHub: https://github.com/52BaranHaydar
