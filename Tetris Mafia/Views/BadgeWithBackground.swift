/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 26/08/2024
  Last modified: 02/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
     https://www.youtube.com/watch?v=Va1Xeq04YxU&t=15559s
     https://www.instructables.com/Playing-Chess/
     https://github.com/exyte/PopupView
     https://github.com/willdale/SwiftUICharts
*/

import SwiftUI

struct BadgeWithBackground: View {
    var name: String
    var image: String
    var width: Int = 120
    var fontSize: Int = 24
    var isShowName: Bool = true
    
    var body: some View {
        BadgeView(name: name, image: image, width: width, fontSize: fontSize, isShowName: isShowName, isShowBackground: true)
            .padding() // Add padding around the content inside the glass background
            .background(
                // Background with blur and a semi-transparent layer
                RoundedRectangle(cornerRadius: 24)
                    .fill(.thickMaterial) // Semi-transparent black background
                    .background(
                        BlurView(style: .systemThinMaterial)
                    )
//                    .blendMode(.darken) // Blend mode to ensure the blur mixes well with the background
            )
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip the outer container to rounded corners
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    BadgeWithBackground(name: "ABC", image: "badge-win1")
        .environment(ModelData.previewModelData)
}
