//
//  AddWorkoutGroupView.swift
//  AmpUp
//
//  Created by Jack Sanchez on 4/1/24.
//

import SwiftUI

struct AddWorkoutGroupView: View {
    @Binding var workoutGroups: [WorkoutGroup]
    @State private var newTitle = ""
    @Environment(\.presentationMode) var presentationMode
    var firestoreService: FirestoreServiceProtocol
    var body: some View {
        NavigationView {
            Form {
                TextField("Workout Group Title", text: $newTitle)
                    .accessibilityIdentifier("Workout Group Title")
                Button("Add") {
                    addNewWorkoutGroup()
                }
                .accessibilityIdentifier("Add Workout Group Button")
            }
            .navigationBarTitle("Add Workout Group", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func addNewWorkoutGroup() {
            guard !newTitle.isEmpty else { return }
            
            firestoreService.addWorkoutGroup(title: newTitle) { result in
                switch result {
                case .success(let newGroup):
                    workoutGroups.append(newGroup)
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print("Error adding workout group: \(error.localizedDescription)")
                }
            }
        }
}

//#Preview {
//    AddWorkoutGroupView()
//}
