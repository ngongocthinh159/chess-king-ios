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

struct AvatarSelection: View {
    @Environment(ModelData.self) var modelData
    
    var image: String
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            CircleImage(image: image, width: modelData.appConfig.isIPhone ? 60 : 100, height: modelData.appConfig.isIPhone ? 60 : 100)
                .overlay {
                    if isSelected {
                        Circle().stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
                    }
                }
                .shadow(color: isSelected ? Color.blue.opacity(0.5) : Color.clear, radius: 10, x: 0, y: 0)
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
                .padding()
        }
        
    }
}

#Preview {
    AvatarSelection(image: "ava-dog", isSelected: false )
        .environment(ModelData())
}
