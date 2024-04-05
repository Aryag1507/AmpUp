import SwiftUI
import UIKit

struct ExerciseShow: View {
    
    let exerciseName: String
    
    func loadImage(for exerciseName: String) -> some View {
        
        if exerciseName == "Dumbbell Curls" {
            
            return AnyView(VStack{
                Image("bicep").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                Text("Put the sensor on the short head and keep your shoulders back!")
            })
        }
        if exerciseName == "Hammer Curls" {
            
            return AnyView(VStack {
                Image("bicep").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                Text("Put the sensor on the brachialis! Do cross-body or upright")
            })
        }
        if exerciseName == "Leg Extensions" {
            return AnyView(VStack {
                Image("quad").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                Text("Put the sensor on the Vastus Medialis, and keep your feet pointed up!")
            })
        }
        if exerciseName == "Calf Raises" {
            return AnyView(VStack {
                Image("calf").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                Text("Put the sensor on either the lateral or medial gastrocnemius!")
            })
            
        }
        if exerciseName == "Tricep Pulldowns" {
            return AnyView(VStack {
                Image("tricep").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                Text("Put the sensor on the long head!")
            })
        }
        
        return AnyView(Text("No exercise found for this parameter!"))
    }
    
    var body: some View {
        VStack {
            Text(exerciseName)
            loadImage(for: exerciseName)
            
        }
        
    }
}
