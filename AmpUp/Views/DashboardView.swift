//
//  PreviousWorkouts.swift
//  AmpUp
//
//  Created by Jack Sanchez on 4/3/24.
//

import SwiftUI
import UIKit
import Charts
import FirebaseAuth
import Foundation
import Charts
import FirebaseFirestore

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var workoutDataWithTitles: [(title: String, data: [Int])] = []
    @State private var workoutGroups: [WorkoutGroup] = [
        WorkoutGroup(title: "Leg Workouts", exercises: ["Barbell Squat", "Leg Extensions"]),
        WorkoutGroup(title: "Bicep and Back Workouts", exercises: ["Dumbbell Curls", "Hammer Curls"]),
        WorkoutGroup(title: "Chest and Tricep Workouts", exercises: ["Dumbbell Shoulder Press", "Dumbbell Lateral Raises"])
    ]
    @State private var showingAddWorkoutView = false
    @State private var showingAllWorkouts = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(spacing: 16) { // Horizontal stack for buttons
                    // "My Workout History" button
                    Button(action: {
                        showingAllWorkouts = true
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 175, height: 100)
                            .foregroundColor(.blue)
                            .overlay(Text("My Workout History")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity)
                            )
                    }
                    .sheet(isPresented: $showingAllWorkouts) {
                        PreviousWorkouts().environmentObject(appState)
                    }
                    
                    // "Compare Workouts" button
                    NavigationLink(destination: CompareWorkoutsView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 175, height: 100) // Square shape
                            .foregroundColor(Color(red: 182/255, green: 4/255, blue: 42/255))
                            .overlay(Text("Compare Workouts")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity)
                            )
                    }
                }
                .padding(.top, 16)
                .onAppear {
                    // Fetch workout data from Firestore when the view appears
                    fetchWorkoutData()
                }
                
                // Page label and "Create" button
                .navigationTitle("Workout Dashboard")
                .toolbar {
                    NavigationLink(destination: Workouts().environmentObject(appState)) {
                        Image(systemName: "plus")
                    }
                }
                
                // Label for recent workouts
                HStack {
                    Text("Most Recent Workouts:")
                        .font(.title)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                }
                
                // Display the last 3 workouts
                ForEach(workoutDataWithTitles.prefix(3), id: \.title) { workoutWithTitles in
                    // Display the workout title and a chart for each set of workout data
                    VStack {
                        Text(workoutWithTitles.title)
                            .font(.headline)
                            .padding(.vertical, 8)
                            
                        LineChart(workoutData: workoutWithTitles.data)
                            .frame(height: 200) // Adjust the height as needed
                            .padding()
                        }
                    }
            }
        }
    }
    
    func fetchWorkoutData() {
        let db = Firestore.firestore()
        let userID = "dummy7" // Replace with actual user ID
        
        db.collection("users").document(userID).collection("workouts")
            .order(by: "timestamp", descending: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    var fetchedDataWithTitles: [(title: String, data: [Int])] = []
                    for document in querySnapshot!.documents {
                        if let workoutArray = document.data()["workoutData"] as? [Int],
                           let title = document.data()["title"] as? String {
                            fetchedDataWithTitles.append((title: title, data: workoutArray))
                        }
                    }
                    self.workoutDataWithTitles = fetchedDataWithTitles
                }
            }
        }
    }

struct CompareWorkoutsView: View {
    var body: some View {
        Text("Compare Workouts View")
    }
}

#Preview {
    DashboardView().environmentObject(AppState())
}
