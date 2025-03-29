import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var workouts: [Workout] = []
    @State private var showAddWorkout = false
    
    var body: some View {
        NavigationView {
            VStack {
                if workouts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Bienvenido \(viewModel.currentUser?.username ?? "usuario")")
                            .font(.headline)
                        
                        Text("No tienes ejercicios registrados")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            showAddWorkout = true
                        }) {
                            Text("Añadir ejercicio")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                    }
                } else {
                    List {
                        ForEach(workouts) { workout in
                            VStack(alignment: .leading) {
                                Text(workout.name)
                                    .font(.headline)
                                
                                Text(workout.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("\(workout.exercises.count) ejercicios")
                                    .font(.caption)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Fitness App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddWorkout = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.signOut()
                    }) {
                        Text("Salir")
                    }
                }
            }
            .sheet(isPresented: $showAddWorkout) {
                AddWorkoutView { newWorkout in
                    workouts.append(newWorkout)
                }
                .environmentObject(viewModel)
            }
            .onAppear {
                loadWorkouts()
            }
        }
    }
    
    func loadWorkouts() {
        guard let userId = viewModel.currentUser?.id else { return }
        
        Firestore.firestore().collection("workouts")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading workouts: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    self.workouts = documents.compactMap { try? $0.data(as: Workout.self) }
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthViewModel.shared)
    }
} 