//
//  PreviousWorkouts.swift
//  AmpUp
//
//  Created by Jack Sanchez on 3/28/24.
//

import SwiftUI
import UIKit
import Charts
import FirebaseAuth
import Foundation
import Charts
import FirebaseFirestore

struct PreviousWorkouts: View {
    @EnvironmentObject var appState: AppState
    @State private var workoutData: [[Int]] = [] // Array to hold workout data
    @State private var workoutGroups: [WorkoutGroup] = [
        WorkoutGroup(title: "Leg Workouts", exercises: ["Barbell Squat", "Leg Extensions"]),
        WorkoutGroup(title: "Bicep and Back Workouts", exercises: ["Dumbbell Curls", "Hammer Curls"]),
        WorkoutGroup(title: "Chest and Tricep Workouts", exercises: ["Dumbbell Shoulder Press", "Dumbbell Lateral Raises"])
    ]
    @State private var showingAddWorkoutView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                
                    VStack {
    //                    Text("Previous Workouts")
    //                        .foregroundColor(.white)
    //                        .bold()
    //                        .font(.title)
                        
                        ForEach(workoutData.indices, id: \.self) { index in
                            // Display a chart for each set of workout data
                            LineChart(workoutData: workoutData[index])
                                .frame(height: 200) // Adjust the height as needed
                                .padding()
                        }
                    }
                    .onAppear {
                        // Fetch workout data from Firestore when the view appears
                        fetchWorkoutData()
                    }
                    .navigationTitle("My Previous Workouts")
                    .toolbar {
                        NavigationLink(destination: Workouts().environmentObject(appState)) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
    
    func fetchWorkoutData() {
        let db = Firestore.firestore()
        let userID = "dummy3" // Replace with actual user ID
        
        db.collection("users").document(userID).collection("workouts").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if let workoutArray = document.data()["workoutData"] as? [Int] {
                        // Append workout data to the array
                        workoutData.append(workoutArray)
                    }
                }
            }
        }
    }
}

struct LineChart: View {
    var workoutData: [Int]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart() {
                ForEach(Array(workoutData.enumerated()), id: \.offset) {index,datapoint in
                    LineMark(
                        x: .value("Time", index),
                        y: .value("Microvolts", datapoint)
                    )
                }

            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    PreviousWorkouts().environmentObject(AppState())
}
