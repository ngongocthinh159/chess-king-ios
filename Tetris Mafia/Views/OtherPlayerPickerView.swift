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

struct OtherPlayerPickerView: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var inputText: String
    @Binding var inputErrorMessage: String?
    var buttonAction: () -> Void
    
    var body: some View {
        ZStack {
            GradientBackground()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .trailing, spacing: modelData.appConfig.isIPhone ? 16 : 32) {
                    InputFieldWithBGImage(text: $inputText, 
                                          errorMessage: $inputErrorMessage,
                                          title: modelData.appConfig.getOtherPlayerPickerView_Username_Text(),
                                          width: modelData.appConfig.isIPhone ? 300 : 500,
                                          placeHolder: modelData.appConfig.getOtherPlayerPickerView_Placeholder_Text())
                    
                    ImageButton(imageName: modelData.appConfig.okButtonName, width: modelData.appConfig.isIPhone ? 130 : 180) {
                        buttonAction()
                    }
                }
            }
        }
        .withHeader(title: modelData.appConfig.getOtherPlayerPickerView_PageHeader_Text())
    }
}

#Preview {
    OtherPlayerPickerView(inputText: .constant("abc"), inputErrorMessage: .constant("anc"), buttonAction: {})
        .environment(ModelData.previewModelData)
        .environment(SessionManager.previewSession)
}
