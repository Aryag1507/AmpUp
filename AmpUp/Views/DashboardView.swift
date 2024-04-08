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
    
    let MAX_EMG_VAL = 16383
    func getNumberReps(rawData: [Int]) -> Double{
            //we want to find number local maximums
            // we need a threshold to determine when to classify a spike as a rep, or else the noise will be classified as such
            
            //window -> [1,2,1,3,1,400,300,32,1]

            let threshold = 2000
            var left = 0
            var right = 1
            var res = 0.0
            var thresholdHit = false
            
            //if not enough data, return
            if rawData.count <= 2{
                return 0
            }
            var prevValue = -1
            while right < rawData.count {
                //two pointer window, if it's increasing keep going, if it starts decreasing and it hasn't jumped a threshold l=r r+1

                var leftVal = rawData[left]
                var rightVal = rawData[right]
                
                
                //print(leftVal)
                //print(rightVal)
                //print(prevValue)
                if prevValue > rightVal {
                    //print("previous is smaller")
                    left = right
                    prevValue = rightVal
                    right+=1
                    thresholdHit = false
                }
                else if leftVal < rightVal{
                    //leftval < rightval, we're increasing. check the threshold. if met count the rep and keep going. if not keep going
                    if (rightVal - leftVal) > threshold && thresholdHit == false{
                        //print("increasing, thresholdHit")
                        res += 1
                        prevValue = rightVal
                        right+=1
                        thresholdHit = true
                    }else {
                        //print("increasing, but no threshold")
                        prevValue = rightVal
                        //print("prev now", prevValue)
                        right+=1
                    }
                }else{
                    //otherwise we're decreasing or even. in tihs case, restart the window
                    //print("locally")
                    left = right
                    prevValue = rightVal
                    right+=1
                    thresholdHit = false
                }
                //print()
                
                
            }
            
            return res
            
            
        }
    
    func getNumberMaxReps(rawData: [Int]) -> Double {
        //find number of times we max out
        var res = 0.0
        var i = 0
        let WINDOW_SIZE = 3
        if rawData.count < 5 {
            return 0
        }else {
            
            while i <= rawData.count - 5 {
                let window = rawData[i...(i + 4)]
                if window.contains(MAX_EMG_VAL) {
                    i += 5 // Shift the window by 5 positions
                    res += 1
                } else {
                    i += 1 // If not found, shift the window by 1 position
                }
            }
            
        }
        
        return res
        
    }
    
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
                            .accessibilityLabel("NavigateToWorkouts")
                            .accessibilityIdentifier("NavigateToWorkouts")

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
                        HStack {
                            Text("Reps: " + String(Int(getNumberReps(rawData: workoutWithTitles.data))))
                                .font(.headline)
                                .padding(.vertical,8)
                            Spacer()
                            Text("Optimal Reps: " + String(Int(getNumberMaxReps(rawData: workoutWithTitles.data))))
                                .font(.headline)
                                .padding(.vertical,8)
                            Spacer()
                            Text("Optimization Score: " + "(" + String(format: "%.2f", (getNumberReps(rawData: workoutWithTitles.data) != 0) ? (getNumberMaxReps(rawData: workoutWithTitles.data) / getNumberReps(rawData: workoutWithTitles.data)) * 100 : 0) + "%)")
                        }.padding(8)
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
        let userID = "dummy6" // Replace with actual user ID
        
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


#Preview {
    DashboardView().environmentObject(AppState())
}
