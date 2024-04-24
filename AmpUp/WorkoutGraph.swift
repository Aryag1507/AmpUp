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
    @State private var workoutTitle: String = ""
    @State public var workoutData: [Int] = []
    @State public var dataPeak: Int = 0
    @State public var pausedState: Bool = false
    @State public var isInitialState: Bool = true
    
    var firestoreService: FirestoreServiceProtocol
    
    func startWorkout() {
        self.isInitialState = false
        let pkg: [String: Any] = ["state": "start"]
        firestoreService.setData(for: "0", in: "start_stop", data: pkg) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Started workout!")
                // Assuming listenToWorkout doesn't need to change for this example
                listenToWorkout()
            }
        }
    }
    
    func pauseWorkout() {
        
        var pkg: [String: Any] = ["state": "paused"]
        if self.pausedState == true {
            pkg = ["state": "start"]
        }
        firestoreService.setData(for: "0", in: "start_stop", data: pkg) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("paused / resumed workout")
            }
        }
        self.pausedState = !self.pausedState
    }
    
    func endWorkout() {
        
//        if self.workoutData == [] {
//            print("No data to write. Ending")
//            return
//        }
        
        let pkg: [String: Any] = ["state": "stop"]
        firestoreService.setData(for: "0", in: "start_stop", data: pkg) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Ended workout!")
            }
        }
        
        // Assuming Timestamp is understood in your context, or you have a way to serialize Date to your needed format.
        let timestamp = Date() // Simplified for context. You might need to adjust depending on your FirestoreService implementation.
        
        let workoutSessionData: [String: Any] = [
            "timestamp": timestamp,
            "workoutData": self.workoutData,
            "title": self.workoutTitle
        ]
        
        firestoreService.addData(to: "users/dummy6/workouts", data: workoutSessionData) { error, documentID in
            if let error = error {
                print("Error writing document: \(error)")
            } else if let documentID = documentID {
                print("Workout session added to Firestore with ID: \(documentID)")
            }
            self.workoutData = []
            self.workoutTitle = ""
        }
    }
    
    func listenToWorkout() {
        firestoreService.listenToDocument(in: "users", document: "0") { data, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            guard let data = data else {
                print("Document data was empty.")
                return
            }
            if let nsArray = data["workouts"] as? NSArray {
                let intWorkoutsArray = nsArray.compactMap { $0 as? Int }
                self.workoutData = intWorkoutsArray
                self.dataPeak = intWorkoutsArray.last ?? 0
            }
            
            print(self.workoutData)
        }
    }
    
    struct LineChart: View {
        var workoutData: [Int]
        var dataPeak: Int
        //var slidingWindow = workoutData.suffix(25)
        var peakMax: Int = 16383
        
        var body: some View {
            if #available(iOS 16.0, *) {
                
                ZStack {
                    Chart() {
                        ForEach(Array((workoutData.suffix(25)).enumerated()), id: \.offset) {index,datapoint in
                            LineMark(
                                x: .value("Time", index),
                                y: .value("Microvolts", datapoint)
                            )
                        }

                    }
                    if dataPeak >= peakMax {
                        Color.green.opacity(0.75)
                    }
                    
                }
                
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    var body: some View {
        
        LineChart(workoutData: self.workoutData, dataPeak: self.dataPeak)
        VStack{
            TextField("Workout Title", text: $workoutTitle) // Text field for user input
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            HStack{
                Button(action: startWorkout) {
                    Text("Start Workout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("Start Workout")
                
                (self.isInitialState == true) ? nil :
                Button(action: pauseWorkout) {
                    (self.pausedState == false) ? Image(systemName: "pause")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10) : Image(systemName: "play")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                    
                }
                .accessibilityIdentifier("Pause Workout")
                
                Button(action: endWorkout) {
                    Text("End Workout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("End Workout")
            }
        }
        
        
                
    }
}

struct WorkoutGraph_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutGraph(firestoreService: FirestoreService())
    }
}
