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

struct InputFieldWithBGImage: View {
    @Environment(ModelData.self) var modelData
    
    @Binding var text: String
    @Binding var errorMessage: String?
    var title: String?
    var width: Int
    var placeHolder: String = "Enter your name"
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                if title != nil  {
                    GeneralTitle(title: title!)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    ZStack {
                        Image("input-bg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: CGFloat(width ))
                        
                        TextField(placeHolder, text: $text)
                            .padding(.horizontal, modelData.appConfig.isIPhone ? 16 : 32)
                            .frame(idealWidth: CGFloat(width ), maxWidth: CGFloat(width ))
                            .offset(y: modelData.appConfig.isIPhone ? -4 : -8)
                            .foregroundColor(.black)
                            .customFont(modelData.appConfig.appFontBold, size: modelData.appConfig.isIPhone ? 16 : 32)
                    }
                    
                    if errorMessage != nil  {
                        ErrorText(text: errorMessage!)
                    }
                }
            }
            
        }
    }
}

#Preview {
    InputFieldWithBGImage(text: .constant("current text"), errorMessage : .constant("Username can not be empty" ), title: "Username", width: 260)
        .environment(ModelData() )
}
