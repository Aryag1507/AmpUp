//
//  Workouts.swift
//  AmpUp
//
//  Created by Arya Gupta on 2/14/24.
//

import SwiftUI

struct Workouts: View {
    var body: some View {
        VStack{
            NavigationLink(destination: Legs()) {
                Text("Leg Workouts")
                    .padding()
            }
            NavigationLink(destination: Biceps()) {
                Text("Bicep Workouts")
                    .padding()
            }
            NavigationLink(destination: Triceps()) {
                Text("Tricep Workouts")
                    .padding()
            }
            NavigationLink(destination: Chest()) {
                Text("Chest Workouts")
                    .padding()
            }
            NavigationLink(destination: Back()) {
                Text("Back Workouts")
                    .padding()
            }
            NavigationLink(destination: Shoulders()) {
                Text("Shoulder Workouts")
                    .padding()
            }
            Button(action: {
                // Action to perform when the button is tapped
                print("Workout started!")
            }) {
                Text("Start Workout")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        
    }
}

// Sub-pages of the Workout page (split by muscle group)
struct Legs: View {
    var body: some View {
        VStack{
            HStack{
                Text("Barbell Squat")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Button tapped!")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            HStack{
                Text("Leg Extensions")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Leg extensions added to workout.")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}
struct Biceps: View {
    var body: some View {
        VStack{
            HStack{
                Text("Dumbbell curls")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Dumbbell curls added to workout")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            HStack{
                Text("Hammer curls")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Hammer curls added to workout.")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}
struct Triceps: View {
    var body: some View {
        VStack{
            HStack{
                Text("Skull crushers")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Skull crushers added to workout")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            HStack{
                Text("V-bar Pulldowns")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("V-bar Pulldowns added to workout.")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}
struct Chest: View {
    var body: some View {
        VStack{
            HStack{
                Text("Barbell Bench Press")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Barbell Bench Press added to workout")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            HStack{
                Text("Incline Dumbbell Bench Press")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Incline Dumbbell Bench Press added to workout.")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}
struct Back: View {
    var body: some View {
        VStack{
            HStack{
                Text("Lat Pulldowns")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Lat Pulldowns added to workout")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            HStack{
                Text("Cable Rows")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Cable Rows added to workout.")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}
struct Shoulders: View {
    var body: some View {
        VStack{
            HStack{
                Text("Dumbbell Shoulder Press")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Dumbbell Shoulder Press added to workout")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
            HStack{
                Text("Dumbbell Lateral Raises")
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Dumbbell Lateral Raises added to workout.")
                }) {
                    Text("+")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct Workouts_Previews: PreviewProvider {
    static var previews: some View {
        Workouts()
    }
}
