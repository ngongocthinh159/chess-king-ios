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

struct ImageButton: View {
    @Environment(ModelData.self) var data
    
    var imageName: String
    var width: CGFloat
//    var height: CGFloat
    var action: () -> Void
    private var _isDisabled: Binding<Bool>  // Using a private Binding variable

    // Expose a public init that optionally accepts a Binding
    init(imageName: String, width: CGFloat, isDisabled: Binding<Bool>? = nil, action: @escaping () -> Void) {
        self.imageName = imageName
        self.width = width
        self.action = action
        self._isDisabled = isDisabled ?? .constant(false )
    }

    var body: some View {
        Button(action: {
            if !_isDisabled.wrappedValue {
                action()
                
                AudioManager.shared.playSoundEffect(filename: data.appConfig.buttonTappingMusic)
            }
        }) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .scaleEffect(1.0)
        }
        .buttonStyle(SpringButtonStyle())
        .disabled(_isDisabled.wrappedValue)
        .opacity(_isDisabled.wrappedValue ? 0.4 : 1.0) // Grey out the button when disabled
        .animation(.easeInOut, value: _isDisabled.wrappedValue)
    }
}

struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.3 : 1.0)
            .animation(.linear, value: configuration.isPressed)
    }
}

#Preview {
    Group {
        ImageButton(imageName: AppConfig(theme: .halloween, boardTheme: .halloween).playAIButtonName, width: 240) {
            
        }
        .environment(ModelData.previewModelData)
    }
    
}
