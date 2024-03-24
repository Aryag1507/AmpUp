import SwiftUI
import UIKit

class BicepCurls: UIView {
    var temperatureData: [(CGPoint, CGFloat)] = [
        (CGPoint(x: 50, y: 100), 0.5),
        (CGPoint(x: 100, y: 150), 1.0)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        if let bodyImage = UIImage(named: "bodySilhouette.png") {
            let aspectRatio = bodyImage.size.width / bodyImage.size.height
            let scaledHeight = rect.width / aspectRatio
            let imageRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: scaledHeight)
            bodyImage.draw(in: imageRect)
        }

        temperatureData.forEach { point, temperature in
            let color = colorForTemperature(temperature)
            context.setFillColor(color.cgColor)

            let circleRadius: CGFloat = 10
            let circleRect = CGRect(x: point.x - circleRadius / 2, y: point.y - circleRadius / 2, width: circleRadius, height: circleRadius)
            context.fillEllipse(in: circleRect)
        }
    }

    private func colorForTemperature(_ temperature: CGFloat) -> UIColor {
        let normalizedTemperature = min(max(temperature, 0), 1)
        return UIColor(red: normalizedTemperature, green: 0, blue: 1 - normalizedTemperature, alpha: 1)
    }
}

struct BicepCurlsView: UIViewRepresentable {
    
    func updateUIView(_ uiView: BicepCurls, context: Context) {
        //t
    }
    
    var exerciseName: String

    func makeUIView(context: Context) -> BicepCurls {
        BicepCurls()
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
