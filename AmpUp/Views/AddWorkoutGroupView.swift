//
//  AddWorkoutGroupView.swift
//  AmpUp
//
//  Created by Jack Sanchez on 4/1/24.
//

import SwiftUI

// Example view for adding a new workout group. Replace with your actual view or form
struct AddWorkoutGroupView: View {
    @Binding var workoutGroups: [WorkoutGroup]
    @State private var newTitle = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Workout Group Title", text: $newTitle)
                Button("Add") {
                    addNewWorkoutGroup()
                }
            }
            .navigationBarTitle("Add Workout Group", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addNewWorkoutGroup() {
        guard !newTitle.isEmpty else { return }
        let newGroup = WorkoutGroup(title: newTitle, exercises: [])
        workoutGroups.append(newGroup)
        presentationMode.wrappedValue.dismiss()
    }
}

//#Preview {
//    AddWorkoutGroupView()
//}
