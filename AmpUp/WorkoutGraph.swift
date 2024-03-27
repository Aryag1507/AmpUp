//
//  WorkoutGraph.swift
//  AmpUp
//
//  Created by Keegan Reynolds on 3/18/24.
//

import SwiftUI
import FirebaseFirestore
import Charts




struct WorkoutGraph: View {
    
    @State public var workoutData: [Int] = []
    
    private func startWorkout() {
        let db = Firestore.firestore()
        let pkg: [String: Any] = [
            "state": "start"
        ]
        db.collection("start_stop").document("0").setData(pkg) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Started workout!")
                listenToWorkout()
            }
        }
    }

    private func endWorkout() {
        let db = Firestore.firestore()
        let pkg: [String: Any] = [
            "state": "stop"
        ]
        db.collection("start_stop").document("0").setData(pkg) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Ended workout!")
            }
        }
        
        // Generate a timestamp for the workout session
        let timestamp = Timestamp(date: Date())
        
        // Add the workout data to the map
        let workoutSessionData: [String: Any] = [
            "timestamp": timestamp,
            "workoutData": self.workoutData
        ]
        
        // Create a new document under the "workouts" map with a unique ID
        let workoutSessionRef = db.collection("users").document("dummy3")
            .collection("workouts").document()
        
        // Set the workout session data under the new document
        workoutSessionRef.setData(workoutSessionData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Workout session added to Firestore!")
            }
        }
        
        self.workoutData = []
    }

    
    
    private func listenToWorkout() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document("0")
        
        userRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            if let nsArray = data["workouts"] as? NSArray {
                //get everything from NS_ArrayM to [Int]
                let intWorkoutsArray = nsArray.compactMap { $0 as? Int }
                //print("Converted array of integers:", intWorkoutsArray)
                self.workoutData = intWorkoutsArray
            }
            
            print(self.workoutData)
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
    
    var body: some View {
        
        LineChart(workoutData: self.workoutData)
        VStack{
            HStack{
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
        
        
                
    }
}

struct WorkoutGraph_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutGraph()
    }
}
