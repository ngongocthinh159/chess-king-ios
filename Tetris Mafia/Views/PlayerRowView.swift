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

struct PlayerRowView: View {
    @Environment(ModelData.self) var modelData
    
    var user : User
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            CircleImage(image: user.avatarStr,
                        width: modelData.appConfig.isIPhone ? 60 : 100,
                        height: modelData.appConfig.isIPhone ? 60 : 100,
                        strokeWidth: 2)
                .overlay(Circle().stroke(isSelected ? Color.blue : Color.white, lineWidth: 2))
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .foregroundColor(isSelected ? Color.blue : Color.white)
                    .customFont(modelData.appConfig.appFontBold,
                                size: modelData.appConfig.isIPhone ? 16 : 24)
                
                Text("\(modelData.appConfig.getPlayerRowView_LastLogin_Text()): \(user.formattedLastLogin)")
                    .foregroundColor(.gray)
                    .customFont(modelData.appConfig.appFontBold,
                                size: modelData.appConfig.isIPhone ? 16 : 24)
                    
            }

            Spacer()
        }
        .padding(.horizontal)
        .frame(height: modelData.appConfig.isIPhone ? 80 : 120)
        .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
}

#Preview {
    PlayerRowView(user: ModelData.previewModelData.users[0], isSelected: true )
        .environment(ModelData.previewModelData)
}
