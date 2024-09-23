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

struct NavigateToOtherSettingRowView: View {
    @Environment(ModelData.self) var data
    
    var settingRow: SettingRow
    var iconImageName: String
    var additionalText: String
    var iconSize: CGFloat = 24
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(settingRow.friendlyName)
                    .myTextStyle() // Ensures text color adapts to theme automatically
                    .padding(.leading)

                Spacer()
                
                Text(additionalText)
                    .customFont(data.appConfig.appFontBold, size: data.appConfig.isIPhone ? 18 : 24)
                    .foregroundColor(.white)
                
                Image(systemName: iconImageName)
                    .foregroundColor(.white)
                    .font(.system(size: iconSize))
            }
        }
        .padding()
        .background(Color.white.opacity(0.2)) // Semi-transparent background to fit various themes
        .cornerRadius(10) // Rounded corners for a softer look
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.5) // Subtle border for definition
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2) // Soft shadow for depth
    }
}

#Preview {
    NavigateToOtherSettingRowView(settingRow: SettingRow(name: "Language", friendlyName: "Language"),
                                  iconImageName: "arrow.down.circle.fill",
                                  additionalText: "English",
                                  action: {})
        .environment(ModelData.previewModelData)
}
