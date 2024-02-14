import SwiftUI

struct Workouts: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Create your workout")
                .font(.headline)
            Spacer()
            NavigationLink(destination: ExerciseListView(title: "Leg Workouts", exercises: legExercises)) {
                WorkoutButton(title: "Leg Workouts")
            }
            NavigationLink(destination: ExerciseListView(title: "Bicep Workouts", exercises: bicepExercises)) {
                WorkoutButton(title: "Bicep Workouts")
            }
            NavigationLink(destination: ExerciseListView(title: "Tricep Workouts", exercises: tricepExercises)) {
                WorkoutButton(title: "Tricep Workouts")
            }
            NavigationLink(destination: ExerciseListView(title: "Chest Workouts", exercises: chestExercises)) {
                WorkoutButton(title: "Chest Workouts")
            }
            NavigationLink(destination: ExerciseListView(title: "Back Workouts", exercises: backExercises)) {
                WorkoutButton(title: "Back Workouts")
            }
            NavigationLink(destination: ExerciseListView(title: "Shoulder Workouts", exercises: shoulderExercises)) {
                WorkoutButton(title: "Shoulder Workouts")
            }
            Spacer()
            Button(action: {
                // Action to perform when the button is tapped
                print("Workout started!")
            }) {
                Text("Start Workout")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .navigationBarTitle("Workouts")
    }
}

// Custom button style for workout categories
struct WorkoutButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity) //.frame(width: 150)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
    }
}

// Sample data for exercises
let legExercises = ["Barbell Squat", "Leg Extensions"]
let bicepExercises = ["Dumbbell Curls", "Hammer Curls"]
let tricepExercises = ["Skull Crushers", "V-Bar Pulldowns"]
let chestExercises = ["Barbell Bench Press", "Incline Dumbbell Bench Press"]
let backExercises = ["Lat Pulldowns", "Cable Rows"]
let shoulderExercises = ["Dumbbell Shoulder Press", "Dumbbell Lateral Raises"]

struct ExerciseListView: View {
    var title: String
    @State var exercises: [String] // Change to @State
    
    @State private var customExercise = ""
    
    var body: some View {
        List {
            Section(header: Text(title)) {
                ForEach(exercises, id: \.self) { exercise in
                    ExerciseRow(exercise: exercise)
                }
                HStack {
                    TextField("Add your own exercise", text: $customExercise)
                    Button(action: {
                        if !customExercise.isEmpty {
                            exercises.append(customExercise)
                            customExercise = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
    }
}



struct ExerciseRow: View {
    var exercise: String
    
    var body: some View {
        HStack {
            Text(exercise)
            Spacer()
            Button(action: {
                // Action to perform when the button is tapped
                print("\(exercise) added to workout!")
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

struct Workouts_Previews: PreviewProvider {
    static var previews: some View {
        Workouts()
    }
}
