import SwiftUI
import Charts

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTimeFrame: TimeFrame = .week
    
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back,")
                            .font(.title2)
                        Text(authViewModel.currentUser?.fullName ?? "User")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Quick Stats
                    HStack(spacing: 15) {
                        StatCard(title: "Workouts", value: "12", icon: "figure.run")
                        StatCard(title: "Calories", value: "2,450", icon: "flame.fill")
                        StatCard(title: "Minutes", value: "180", icon: "clock.fill")
                    }
                    .padding(.horizontal)
                    
                    // Activity Chart
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Activity Overview")
                            .font(.headline)
                        
                        Picker("Time Frame", selection: $selectedTimeFrame) {
                            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                                Text(timeFrame.rawValue).tag(timeFrame)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        // Placeholder Chart
                        Chart {
                            ForEach(0..<7) { index in
                                LineMark(
                                    x: .value("Day", "Day \(index + 1)"),
                                    y: .value("Activity", Double.random(in: 0...100))
                                )
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Recent Workouts
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Workouts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(0..<3) { _ in
                            WorkoutCard()
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct WorkoutCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Morning Run")
                    .font(.headline)
                Text("30 minutes • 3.5 km")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
} 