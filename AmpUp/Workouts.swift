import SwiftUI

struct WorkoutGroup {
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
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(workoutGroups.indices, id: \.self) { index in
                        NavigationLink(destination: ExerciseListView(title: workoutGroups[index].title, exercises: workoutGroups[index].exercises)) {
                            WorkoutButton(title: workoutGroups[index].title,
                                          onRename: {
                                              // Action to rename the workout group
                                              // Implement your renaming logic here
                                              print("Rename action for \(workoutGroups[index].title)")
                                          },
                                          onDelete: {
                                              // Action to delete the workout group
                                              workoutGroups.remove(at: index)
                                          })
                        }
                    }
                    Button(action: addWorkoutGroup) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                            Text("Add Workout Group")
                                .font(.caption)
                        }
                        .padding()
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: {
                    self.workoutStartTime = Date()
                    print("Workout started at \(String(describing: self.workoutStartTime))")
                }) {
                    Text("Start Workout")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                Button(action: {
                    let workoutEndTime = Date()
                    if let startTime = self.workoutStartTime {
                        let workoutDuration = workoutEndTime.timeIntervalSince(startTime)
                        print("Workout ended at \(workoutEndTime). Total workout time: \(workoutDuration) seconds.")
                    } else {
                        print("End Workout pressed without starting a workout.")
                    }
                    self.workoutStartTime = nil
                }) {
                    Text("End Workout")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }
        }
        .navigationBarTitle("Workouts")
    }
    
    func addWorkoutGroup() {
        let newGroup = WorkoutGroup(title: "New Workout Group \(workoutGroups.count + 1)", exercises: ["Exercise 1", "Exercise 2"])
        workoutGroups.append(newGroup)
    }
}

// Custom button style for workout categories, adjusted for grid layout
struct WorkoutButton: View {
    var title: String
    var onRename: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        Text(title)
            .padding()
            .frame(height: 100) // Specify height for uniformity
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                Button(action: onRename) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.white)
                        .padding([.top, .leading], 10)
                }, alignment: .topLeading
            )
            .overlay(
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.white)
                        .padding([.top, .trailing], 10)
                }, alignment: .topTrailing
            )
    }
}

struct ExerciseListView: View {
    var title: String
    @State var exercises: [String]
    
    var body: some View {
        List {
            Section(header: Text(title)) {
                ForEach(exercises, id: \.self) { exercise in
                    Text(exercise)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct Workouts_Previews: PreviewProvider {
    static var previews: some View {
        Workouts()
    }
}
