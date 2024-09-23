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

struct DifficultySettingRowView: View {
    @Environment(ModelData.self) var data
    
    let description: String
    let imageName: String
    let aiName: String
    @Binding var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image and description
            HStack {
                VStack(alignment: .center, spacing: 0) {
                    AvatarSelection(image: imageName, isSelected: isSelected)
                        .border(Color.clear)
                    
                    Text(aiName)
                        .myTextStyle()
                }
                
                Spacer()
                
                // Checkbox area
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .green : .gray)
                    .onTapGesture {
                        isSelected.toggle()
                    }
            }
            
            Text("\(description)")
                .customFont(data.appConfig.appFontRegular, size: 16)
                .foregroundStyle(data.appConfig.textColorOnBG)
                
        }
        .padding()
        .background(Color.white.opacity(0.2)) // Semi-transparent background to fit various themes
        .cornerRadius(10) // Rounded corners for a softer look
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.5) // Subtle border for definition
        )
        .shadow(color: isSelected ? Color.blue.opacity(1) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

#Preview {
    DifficultySettingRowView(description: "abc", imageName: "ava-ai-tomhuynh", aiName: "TomHuynh", isSelected: .constant(false))
        .environment(ModelData.previewModelData)
}
