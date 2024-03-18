//
//  WorkoutGraph.swift
//  AmpUp
//
//  Created by Keegan Reynolds on 3/18/24.
//

import SwiftUI
import FirebaseFirestore
import Charts

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
}



struct WorkoutGraph: View {
    
    @State private var workoutData: [String] = []
    
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
            print("Current data: \(data["workouts"])")
            workoutData = data["workouts"]
          }
    }
    
    var body: some View {
        
        
        VStack{
            Chart{
                ForEach(workoutData) {datapoint in
                    LineMark(x: .value(Int(Date().timeIntervalSince1970)), y: .value(Int(datapoint)))
                }
            }
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
