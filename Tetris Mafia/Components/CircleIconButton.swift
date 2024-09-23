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

struct CircleIconButton: View {
    var iconName: String
    var iconColor: Color
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: iconName) // Use SF Symbols
                .font(.system(size: 24)) // Adjust the size
                .foregroundColor(iconColor) // Change the color
        }
        .padding() // Add some padding around the icon
        .background(backgroundColor) // Add a background color with opacity
        .clipShape(Circle()) // Make the background circular
//        .cornerRadius(10) // Make the background rounded
    }
}

#Preview {
    CircleIconButton(iconName: "arrow.left", iconColor: .black, backgroundColor: Color.gray.opacity(0.2)) {
        // Add action here
    }
}
