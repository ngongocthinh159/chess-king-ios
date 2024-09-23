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
import Foundation

struct Popup<Content>: View where Content: View {
    @Environment(ModelData.self) var modelData
    
    var title: String
    var closeAction: () -> Void
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack {
            // Dimmed background covering the entire screen
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            // Popup content
            VStack {
                ZStack {
                    // Title in the center
                    Text(title)
                        .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 32 : 48)
                        .foregroundColor(.white)
                    
                    HStack {
                        ImageButton(imageName: modelData.appConfig.backButtonName, width: modelData.appConfig.isIPhone ? 70 : 150) {
                            withAnimation {
                                closeAction()
                            }
                        }
                        
                        Spacer() // This spacer pushes the close button to the left
                        
                        // Placeholder on the right to balance the close button
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.clear)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // ScrollView for content
                ScrollView {
                    content()
                        .padding()
                }
                
                Spacer()
            }
            .frame(width: modelData.appConfig.popupWidth, height: modelData.appConfig.popupHeight)
            .background(GradientBackground())
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    Popup(title: "Popup", closeAction: {}, content: {})
        .environment(ModelData.previewModelData)
}
