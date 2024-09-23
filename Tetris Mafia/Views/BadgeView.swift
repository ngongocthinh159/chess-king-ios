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

struct BadgeView: View {
    @Environment(ModelData.self) var modelData
    
    var name: String
    var image: String 
    var width: Int = 120
    var fontSize: Int = 24
    var fontColor: Color = .black
    var isShowName: Bool = true
    var isShowBackground: Bool = true
    
    @State private var isAnimated = false
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(width))
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .scaleEffect(isAnimated ? 1.1 : 0.9)
                .opacity(isAnimated ? 1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimated
                )
            
            if isShowName {
                Text(name)
                    .font(.custom(modelData.appConfig.appFontRegular, size: CGFloat(fontSize)))
                    .foregroundColor(fontColor)
                    .scaleEffect(isAnimated ? 1.1 : 0.9)
                    .opacity(isAnimated ? 1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimated
                    )
            }
        }
        .onAppear {
            isAnimated = true
        }
    }
}

#Preview {
    BadgeView(name: "First game play", image: "badge-firstPlay")
        .environment(ModelData.previewModelData)
}
