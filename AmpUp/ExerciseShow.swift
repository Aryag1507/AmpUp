import SwiftUI
import UIKit

struct ExerciseShow: View {
    
    let exerciseName: String
    var body: some View {
        VStack {
            Text(exerciseName)
            Text("Put image of $exerciseName here")
            
        }
        
    }
}
