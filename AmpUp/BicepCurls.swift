import SwiftUI
import UIKit

// MARK: - UIKit Component for Bicep Curls Visualization
//class BicepCurls: UIView {
//    var temperatureData: [(CGPoint, CGFloat)] = [
//        (CGPoint(x: 50, y: 100), 0.5),
//        (CGPoint(x: 100, y: 150), 1.0)
//    ]
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = .clear
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.backgroundColor = .clear
//    }
//
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        if let bodyImage = UIImage(named: "bodySilhouette.png") {
//            let aspectRatio = bodyImage.size.width / bodyImage.size.height
//            let scaledHeight = rect.width / aspectRatio
//            let imageRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: scaledHeight)
//            bodyImage.draw(in: imageRect)
//        }
//
//        temperatureData.forEach { point, temperature in
//            let color = colorForTemperature(temperature)
//            context.setFillColor(color.cgColor)
//
//            let circleRadius: CGFloat = 10
//            let circleRect = CGRect(x: point.x - circleRadius / 2, y: point.y - circleRadius / 2, width: circleRadius, height: circleRadius)
//            context.fillEllipse(in: circleRect)
//        }
//    }
//
//    private func colorForTemperature(_ temperature: CGFloat) -> UIColor {
//        let normalizedTemperature = min(max(temperature, 0), 1)
//        return UIColor(red: normalizedTemperature, green: 0, blue: 1 - normalizedTemperature, alpha: 1)
//    }
//}

// MARK: - SwiftUI Wrapper for BicepCurls UIView
struct BicepCurlsView: View {
    var exerciseName: String
    @State private var workoutStartTime: Date?
    @State private var showAlert = false
    @State private var workoutDuration: TimeInterval = 0

    var body: some View {
            VStack {
                Spacer()
                Spacer()
                Spacer()

        
        if let bodyImage = UIImage(named: "bodySilhouette.png") {
            // This will maintain the aspect ratio of the image
            let aspectRatio = bodyImage.size.width / bodyImage.size.height
            let scaledHeight = rect.width / aspectRatio
            let imageRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: scaledHeight)
            bodyImage.draw(in: imageRect)
        }
        
        temperatureData.forEach { (point, temperature) in
            let color = self.colorForTemperature(temperature)
            context.setFillColor(color.cgColor)
                HStack(spacing: 20) {
                    Button("Start Workout") {
                        startWorkout()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)

                    Button("End Workout") {
                        endWorkout()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Workout Completed"),
                    message: Text("Workout ended. Duration: \(workoutDuration, specifier: "%.2f") seconds."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
    }

    func colorForTemperature(_ temperature: CGFloat) -> UIColor {
        let normalizedTemperature = min(max(temperature, 0), 1)
        return UIColor(red: normalizedTemperature, green: 0, blue: 1 - normalizedTemperature, alpha: 1)
    }
}

struct BicepCurlsView: UIViewRepresentable {
    var exerciseName: String

    func makeUIView(context: Context) -> BicepCurls {
        BicepCurls()
    }

    private func endWorkout() {
        guard let startTime = workoutStartTime else { return }
        workoutDuration = Date().timeIntervalSince(startTime)
        workoutStartTime = nil
        showAlert = true // This triggers the alert to be shown
    }
}

struct BicepCurlsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            BicepCurlsView(exerciseName: "Bicep Curls")
                .frame(width: 300, height: 200)
                .previewLayout(.sizeThatFits)
        }
    }
}
