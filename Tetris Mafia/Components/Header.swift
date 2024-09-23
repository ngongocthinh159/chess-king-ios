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

struct Header: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ModelData.self) var modelData
    
    let title: String
    let isBackable: Bool
    let isShowConfirmBeforeBack: Bool
    let alertMessage: String 
    
    @State private var isConfirmationShowing = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isBackable {
                ImageButton(imageName: modelData.appConfig.backButtonName, width: modelData.appConfig.isIPhone ? 70 : 150) {
                    if !isShowConfirmBeforeBack {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isConfirmationShowing = true 
                    }
                }
            }

            VStack {
                Text(title)
                    .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 36 : 60)
                    .foregroundColor(modelData.appConfig.textColorOnBG)
            }
            .frame(maxWidth : .infinity)
        }
        .padding(.horizontal, modelData.appConfig.isIPhone ? 24 : 36)
        .alert(isPresented: $isConfirmationShowing) { // Alert for confirmation
            Alert(
                title: Text("Confirm"),
                message: Text(alertMessage),
                primaryButton: .destructive(Text("Go Back")) {
                    presentationMode.wrappedValue.dismiss()  // Dismiss the view
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    Header(title: "Register", isBackable: true, isShowConfirmBeforeBack: false, alertMessage: "Are you sure?" )
        .environment(ModelData())
}
