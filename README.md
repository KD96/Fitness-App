# Fitness App Prototype

A modern iOS fitness tracking application built with SwiftUI and Firebase.

## Features (MVP)

- User Authentication
- Workout Tracking
- Health Data Integration (HealthKit)
- GPS Tracking
- Basic Analytics and Charts

## Technical Stack

- Frontend: SwiftUI
- Backend: Firebase
  - Authentication
  - Cloud Firestore
  - Storage
  - Cloud Functions
- HealthKit Integration
- CoreLocation

## Setup Instructions

1. Clone the repository
2. Install Xcode 14.0 or later
3. Install CocoaPods
4. Run `pod install` in the project directory
5. Open the `.xcworkspace` file in Xcode
6. Configure Firebase:
   - Add your `GoogleService-Info.plist` file
   - Enable required Firebase services in Firebase Console
7. Configure HealthKit capabilities in Xcode
8. Build and run the project

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+
- CocoaPods
- Firebase account 