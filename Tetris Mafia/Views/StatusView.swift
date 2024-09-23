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

struct StatusView: View {
    @Environment(ModelData.self) var modelData
    var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\(self.viewModel.state.descriptionInLanguage(language: modelData.appConfig.language))")
                    .customFont(modelData.appConfig.appFontRegular, size: modelData.appConfig.isIPhone ? 16 : 32)
                    .foregroundColor(modelData.appConfig.textColorOnBG)
                
                Spacer()
                
                Spacer()
                
                Text("\(modelData.appConfig.language == .EN ? "Turn" : "Lượt") \(self.viewModel.game.turn.descriptionInLanguage(language: modelData.appConfig.language))")
                    .customFont(modelData.appConfig.appFontRegular, size: modelData.appConfig.isIPhone ? 16 : 32)
                    .foregroundColor(modelData.appConfig.textColorOnBG)
            }
            .padding(.horizontal)
            
            Button("\(modelData.appConfig.language == .EN ? "Reverse" : "Đánh lại")", systemImage: "arrow.3.trianglepath") {
                self.viewModel.reverseLastMove()
                
                AudioManager.shared.playSoundEffect(filename: modelData.appConfig.settingTapMusic)
            }
//            .buttonStyle(.borderedProminent)
            .buttonStyle(ProminentButtonStyle())
            .customFont(modelData.appConfig.appFontBold, size: modelData.appConfig.isIPhone ? 16 : 32)
            .disabled(self.viewModel.state != .awaitingInput || self.viewModel.game.history.isEmpty)
        }
    }
}

struct ProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundView)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: isEnabled ? 10 : 0) // No shadow when disabled
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1.0) : 0.5) // Reduced opacity when disabled
            .animation(.easeOut, value: configuration.isPressed)
    }

    private var backgroundView: some View {
        Group {
            if isEnabled {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
            } else {
                Color.gray
            }
        }
    }
}

#Preview {
    StatusViewPreview.previews
}

struct StatusViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            statusAwaitingInput()
                .environment(ModelData.previewModelData)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
    
    static func statusAwaitingInput() -> some View {
        let vm = GameViewModel(game: .standard, session: SessionManager.previewSession)
        
        return StatusView(viewModel: vm)
    }
}

