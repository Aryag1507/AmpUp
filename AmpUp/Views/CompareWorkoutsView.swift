//
//  CompareWorkoutsView.swift
//  AmpUp
//
//  Created by Maharshi Rathod on 4/7/24.
//

import SwiftUI
import UIKit
import Charts
import FirebaseAuth
import Foundation
import Charts
import FirebaseFirestore

struct CompareWorkoutsView: View {
    var firestoreService = FirestoreService()
    @State private var workouts: [(title: String, data: [Int])] = []
    @State private var selectedWorkout1: String?
    @State private var selectedWorkout2: String?
    @State private var comparisonResult: String?

    var body: some View {
        VStack {
            Text("Select Two Workouts to Compare")
                .font(.headline)

            Picker("Workout 1", selection: $selectedWorkout1) {
                ForEach(workouts, id: \.title) { workout in
                    Text(workout.title).tag(workout.title as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Picker("Workout 2", selection: $selectedWorkout2) {
                ForEach(workouts, id: \.title) { workout in
                    Text(workout.title).tag(workout.title as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Button("Compare") {
                performComparison()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if let result = comparisonResult {
                Text(result)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            fetchWorkoutData()
        }
    }

    private func fetchWorkoutData() {
        // Assuming you replace "dummyUserID" with the actual ID of the logged-in user.
        firestoreService.fetchWorkouts(for: "dummy7") { fetchedWorkouts, error in
            if let fetchedWorkouts = fetchedWorkouts {
                self.workouts = fetchedWorkouts
            } else {
                print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    func compareWorkoutData(workout1: (title: String, data: [Int]), workout2: (title: String, data: [Int])) -> String {
        let targetValue = 16383
            let count1 = workout1.data.filter { $0 == targetValue }.count
            let count2 = workout2.data.filter { $0 == targetValue }.count
            
            if count1 > count2 {
                return "\(workout1.title) hit the peak value more often (\(count1) times) than \(workout2.title) (\(count2) times)."
            } else if count1 < count2 {
                return "\(workout2.title) hit the peak value more often (\(count2) times) than \(workout1.title) (\(count1) times)."
            } else {
                return "Both workouts hit the peak value the same number of times (\(count1))."
            }
        }

    private func performComparison() {
        // Ensure two different workouts are selected
        guard let workout1 = workouts.first(where: { $0.title == selectedWorkout1 }),
              let workout2 = workouts.first(where: { $0.title == selectedWorkout2 }) else {
            comparisonResult = "Please select two different workouts."
            return
        }
        
        // Use the updated compareWorkoutData function for comparison
        comparisonResult = compareWorkoutData(workout1: workout1, workout2: workout2)
    }
}

struct CompareWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        CompareWorkoutsView()
    }
}
