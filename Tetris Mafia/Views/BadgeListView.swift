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

struct BadgeListView: View {
    @Environment(ModelData.self) var modelData
        
    var title: String
    var badges: [Badge]
    var titleFontSize: CGFloat?
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(modelData.appConfig.appFontBold, size: titleFontSize ?? (modelData.appConfig.isIPhone ? 18 : 24)))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 24)
            
            VStack(spacing: 48) {
                ForEach(badges, id: \.self) { badge in
                    BadgeView(name: badge.toRepresent(language: modelData.appConfig.language),
                              image: badge.imageName,
                              width: Int(modelData.appConfig.popupWidth / 3 - 20),
                              fontSize: modelData.appConfig.isIPhone ? 16 : 24,
                              fontColor: .white)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(BlurView(style: .systemMaterialDark)) // Using BlurView for an aesthetic glass effect
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

#Preview {
    BadgeListView(title: "New badges", badges: Badge.previews())
        .environment(ModelData.previewModelData)
}
