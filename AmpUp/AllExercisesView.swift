import SwiftUI

class ExerciseViewModel: ObservableObject {
    @Published var navigateToPathViewForExercise: String? = nil
    @Published var isNavigatingToPathView: Bool = false
    @Published var selectedExercise: String? = nil
    @Published var isShowingGroupSelection: Bool = false

    func resetNavigationState() {
        navigateToPathViewForExercise = nil
        isNavigatingToPathView = false
    }
}

struct AllExercisesView: View {
    @Binding var workoutGroups: [WorkoutGroup]
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Custom Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                TextField("Search exercises", text: $searchText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.vertical, 8)
                    .padding(.leading, 0)
                    .padding(.trailing)
            }
            .padding(.horizontal)
            .frame(height: 36)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // List of Exercises
            List(filteredExercises, id: \.self) { exercise in
                HStack {
                    Text(exercise)
                        .foregroundColor(.primary)
                        .onTapGesture {
                            viewModel.navigateToPathViewForExercise = exercise
                            viewModel.isNavigatingToPathView = true
                        }
                    Spacer()
                    Button("Change Group") {
                        viewModel.selectedExercise = exercise
                        viewModel.isShowingGroupSelection = true
                    }
                    .foregroundColor(.blue)
                    .accessibilityIdentifier("\(exercise) ChangeGroup")
                }
            }
            .listStyle(PlainListStyle())
//            .background("Background")
        }
        .sheet(isPresented: $viewModel.isShowingGroupSelection) {
            if let selectedExercise = viewModel.selectedExercise {
                GroupSelectionView(exercise: selectedExercise, workoutGroups: $workoutGroups)
            }
        }
        .background(
            NavigationLink(
                destination: ExerciseShow(exerciseName: viewModel.navigateToPathViewForExercise ?? ""),
                isActive: $viewModel.isNavigatingToPathView) { EmptyView() }
        )
    }
    
    var filteredExercises: [String] {
        if searchText.isEmpty {
            return workoutGroups.flatMap { $0.exercises }.sorted().unique()
        } else {
            return workoutGroups.flatMap { $0.exercises }
                .filter { $0.localizedCaseInsensitiveContains(searchText) }
                .sorted()
                .unique()
        }
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}

struct GroupSelectionView: View {
    let exercise: String
    @Binding var workoutGroups: [WorkoutGroup]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            ForEach(workoutGroups.indices, id: \.self) { index in
                Button(action: {
                    addExerciseToGroup(at: index)
                }) {
                    Text(workoutGroups[index].title)
                }
                .accessibilityIdentifier(workoutGroups[index].title)
            }
        }
        .navigationBarTitle("Select Group", displayMode: .inline)
    }

    private func addExerciseToGroup(at index: Int) {
        // First, remove the exercise from any group it might already belong to
        workoutGroups = workoutGroups.map { group in
            var modifiedGroup = group
            modifiedGroup.exercises.removeAll { $0 == exercise }
            return modifiedGroup
        }
        // Then, add the exercise to the selected group
        workoutGroups[index].exercises.append(exercise)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AllExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            AllExercisesView(workoutGroups: .constant([
                WorkoutGroup(title: "Leg Workouts", exercises: ["Barbell Squat", "Leg Extensions"]),
                WorkoutGroup(title: "Bicep and Back Workouts", exercises: ["Dumbbell Curls", "Hammer Curls"]),
                WorkoutGroup(title: "Chest and Tricep Workouts", exercises: ["Dumbbell Shoulder Press", "Dumbbell Lateral Raises"])
            ]))
            .padding()
        }
    }
}

