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

struct LanguageRowView: View {
    @Environment(ModelData.self) var data
    
    var language: AppLanguage
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(language.toRepresentation(inLangue: data.appConfig.language))
                .customFont(data.appConfig.appFontBold, size: data.appConfig.isIPhone ? 16 : 24)
                .foregroundColor(isSelected ? .blue : .white)
                .padding(.leading, 10)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
            }
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.2) : Color.white.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue.opacity(0.5) : Color.white.opacity(0.5),
                        lineWidth: isSelected ? 2 : 1)
        )
        .shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1)
        .padding(.horizontal, 2)
    }
}

#Preview {
    LanguageRowView(language: .EN, isSelected: true)
        .environment(ModelData.previewModelData)
}
