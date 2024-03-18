import SwiftUI

struct WorkoutGroup: Identifiable {
    let id = UUID()
    var title: String
    var exercises: [String]
}

struct Workouts: View {
    @State private var workoutStartTime: Date?
    @State private var workoutGroups: [WorkoutGroup] = [
        WorkoutGroup(title: "Leg Workouts", exercises: ["Barbell Squat", "Leg Extensions"]),
        WorkoutGroup(title: "Bicep and Back Workouts", exercises: ["Dumbbell Curls", "Hammer Curls"]),
        WorkoutGroup(title: "Chest and Tricep Workouts", exercises: ["Dumbbell Shoulder Press", "Dumbbell Lateral Raises"])
    ]
    @State private var showingAddWorkoutView = false

    var body: some View {
            VStack {
                ScrollView {
                    ForEach(workoutGroups) { group in
                        NavigationLink(destination: ExerciseListView(title: group.title, exercises: group.exercises)) {
                            Text(group.title)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    
                    Button(action: {
                        showingAddWorkoutView = true
                    }) {
                        HStack {
                            Text("+Add Workout Group")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                        }
                    }
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                }

                Spacer()
                
                WorkoutGraph()

                HStack(spacing: 20) {
                    Button(action: startWorkout) {
                        Text("Start Workout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }

                    Button(action: endWorkout) {
                        Text("End Workout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                
            }
            .navigationBarTitle("Workouts", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                // Placeholder for navigation action if needed
            }) {
                NavigationLink(destination: AllExercisesView(workoutGroups: $workoutGroups)) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.primary)
                }
            })
            .sheet(isPresented: $showingAddWorkoutView) {
                AddWorkoutGroupView(workoutGroups: $workoutGroups)
            }
        }

    private func startWorkout() {
        workoutStartTime = Date()
        // Additional logic for starting a workout can be added here
    }

    private func endWorkout() {
        guard let startTime = workoutStartTime else { return }
        let workoutDuration = Date().timeIntervalSince(startTime)
        print("Workout ended. Duration: \(workoutDuration) seconds.")
        workoutStartTime = nil
        // Additional logic for ending a workout can be added here
    }
    
    // Example view for adding a new workout group. Replace with your actual view or form
    struct AddWorkoutGroupView: View {
        @Binding var workoutGroups: [WorkoutGroup]
        @State private var newTitle = ""
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            NavigationView {
                Form {
                    TextField("Workout Group Title", text: $newTitle)
                    Button("Add") {
                        addNewWorkoutGroup()
                    }
                }
                .navigationBarTitle("Add Workout Group", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        
        private func addNewWorkoutGroup() {
            guard !newTitle.isEmpty else { return }
            let newGroup = WorkoutGroup(title: newTitle, exercises: [])
            workoutGroups.append(newGroup)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ExerciseListView: View {
    var title: String
    var exercises: [String]
    
    var body: some View {
        List(exercises, id: \.self) { exercise in
            Text(exercise)
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct Workouts_Previews: PreviewProvider {
    static var previews: some View {
        Workouts()
    }
}
