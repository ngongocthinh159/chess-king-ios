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

struct ImageOverlapText: View {
    @Environment(ModelData.self) var data
    
    var image: String
    var text: String
    
    var body: some View {
        VStack {
            // Logo
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: data.appConfig.isIPhone ? 100 : 160)
                .shadow(radius: 10) // Optional: add a shadow for depth

            // Text
            Text(text)
                .font(.custom(data.appConfig.appFontBold, size: data.appConfig.isIPhone ? 32 : 46))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.7), radius: 5, x: 2, y: 2) // Shadow to make text stand out
                .background(Color.black.opacity(0.3).blur(radius: 30)) // Blur effect for separation
                .offset(y: data.appConfig.isIPhone ? -30 : -42) // Adjust to overlap with the bottom of the logo
        }
    }
}

#Preview {
    ImageOverlapText(image: "leaderboard-logo", text: "Leaderboard")
        .environment(ModelData.previewModelData)
}
