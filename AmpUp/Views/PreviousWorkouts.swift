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
    @State private var workoutDataWithTitles: [(title: String, data: [Int])] = []
    @State private var workoutGroups: [WorkoutGroup] = [
        WorkoutGroup(title: "Leg Workouts", exercises: ["Barbell Squat", "Leg Extensions"]),
        WorkoutGroup(title: "Bicep and Back Workouts", exercises: ["Dumbbell Curls", "Hammer Curls"]),
        WorkoutGroup(title: "Chest and Tricep Workouts", exercises: ["Dumbbell Shoulder Press", "Dumbbell Lateral Raises"])
    ]
    @State private var showingAddWorkoutView = false
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
                ZStack {
                    VStack {
                        ForEach($workoutDataWithTitles, id: \.title) { workoutWithTitles in
                            //displaying workout title, number of reps, and the chart
                            VStack {
                                
                                HStack {
                                    Text("Title: " + workoutWithTitles.title.wrappedValue)
                                        .font(.headline)
                                        .padding(.vertical, 8)
                                        
                                    Spacer()
                                    Text("Reps: " + String(Int(getNumberReps(rawData: workoutWithTitles.data.wrappedValue))))
                                        .font(.headline)
                                        .padding(.vertical,8)
                                    Spacer()
                                    Text("Optimal Reps: " + String(Int(getNumberMaxReps(rawData: workoutWithTitles.data.wrappedValue))))
                                        .font(.headline)
                                        .padding(.vertical,8)
                                    Spacer()
                                    Text("Optimization Score: " + "(" + String(format: "%.2f", (getNumberReps(rawData: workoutWithTitles.data.wrappedValue) != 0) ? (getNumberMaxReps(rawData: workoutWithTitles.data.wrappedValue) / getNumberReps(rawData: workoutWithTitles.data.wrappedValue)) * 100 : 0) + "%)")

                                }.padding(8)

                                
                                
                                
                                LineChart(workoutData: workoutWithTitles.data.wrappedValue)
                                    .frame(height: 200) // Adjust the height as needed
                                    .padding()
                            }
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
