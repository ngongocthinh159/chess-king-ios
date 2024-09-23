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

struct SettingsSectionView<Content: View>: View {
    @Environment(ModelData.self) var data
    
    var title: String
    @ViewBuilder var content: () -> Content  // Using a view builder to allow passing custom content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .customFont(data.appConfig.appFontBold, size: data.appConfig.isIPhone ? 24 : 36)
                .font(.headline)
                .foregroundColor(data.appConfig.textColorOnBG)

            content()  // This will render the content passed to the view builder
        }
    }
}

#Preview {
    SettingsSectionView(title: "General", content: {})
        .environment(ModelData.previewModelData)
}
