import SwiftUI
import FirebaseCore

struct AddWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var workoutName = ""
    @State private var exercises: [String] = [""]
    @State private var isLoading = false
    
    var onSave: (Workout) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información")) {
                    TextField("Nombre del ejercicio", text: $workoutName)
                }
                
                Section(header: Text("Ejercicios")) {
                    ForEach(exercises.indices, id: \.self) { index in
                        TextField("Ejercicio \(index + 1)", text: $exercises[index])
                    }
                    
                    Button("Añadir otro ejercicio") {
                        exercises.append("")
                    }
                }
            }
            .navigationTitle("Nuevo ejercicio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveWorkout()
                    }
                    .disabled(workoutName.isEmpty || exercises.first?.isEmpty == true || isLoading)
                }
            }
            .overlay(
                Group {
                    if isLoading {
                        ProgressView("Guardando...")
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(radius: 10)
                    }
                }
            )
        }
    }
    
    func saveWorkout() {
        guard let userId = viewModel.currentUser?.id else { return }
        
        isLoading = true
        
        // Filtrar ejercicios vacíos
        let validExercises = exercises.filter { !$0.isEmpty }
        
        let workout = Workout(
            name: workoutName,
            date: Date(),
            exercises: validExercises,
            userId: userId
        )
        
        // Guardar en Firestore
        do {
            try Firestore.firestore().collection("workouts").addDocument(from: workout) { error in
                isLoading = false
                
                if let error = error {
                    print("Error saving workout: \(error.localizedDescription)")
                    return
                }
                
                onSave(workout)
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            isLoading = false
            print("Error encoding workout: \(error.localizedDescription)")
        }
    }
} 