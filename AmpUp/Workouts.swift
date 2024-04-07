import SwiftUI
import Firebase

struct WorkoutGroup: Identifiable {
    let id = UUID()
    var title: String
    var exercises: [String]
}

struct Workouts: View {
    @EnvironmentObject var appState: AppState
    @State private var workoutGroups: [WorkoutGroup] = []
    @State private var showingAddWorkoutView = false
    
    var body: some View {
        ZStack {
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
                WorkoutGraph(firestoreService: FirestoreService())
            }
            .navigationBarTitle("Create New Workout", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    // Placeholder for navigation action if needed
                }) {
                    NavigationLink(destination: AllExercisesView(workoutGroups: $workoutGroups).environmentObject(appState)) {
                        Image(systemName: "list.bullet")
                    }
                }
            )
            .sheet(isPresented: $showingAddWorkoutView) {
                AddWorkoutGroupView(workoutGroups: $workoutGroups, firestoreService: FirestoreService())
            }
        }
        .onAppear {
            fetchWorkoutsFromFirestore()
        }
    }
    
    func fetchWorkoutsFromFirestore() {
        let db = Firestore.firestore()
        
        db.collection("workouts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching workouts: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.workoutGroups = documents.compactMap { document in
                guard let title = document.data()["title"] as? String else {
                    return nil // If title is missing, skip this document
                }
                
                let exercises = document.data()["exercises"] as? [String] ?? []
                return WorkoutGroup(title: title, exercises: exercises)
            }

        }
    }
}

struct ExerciseListView: View {
    var title: String
    var exercises: [String]
    
    var body: some View {
        List(exercises, id: \.self) { exercise in
            NavigationLink(destination: BicepCurlsView(exerciseName: exercise)) {
                Text(exercise)
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct Workouts_Previews: PreviewProvider {
    static var previews: some View {
        Workouts().environmentObject(AppState())
    }
}
