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

struct SectionRow {
    var name: String
    var value: String
}

struct SectionView: View {
    @Environment(ModelData.self) var modelData
    
    var title: String
    var sectionRows: [SectionRow]
    
    var body: some View {

        VStack(alignment: .leading) {
            Text(title)
                .customFont(modelData.appConfig.appFontBold, size: modelData.appConfig.isIPhone ? 24 : 36)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(sectionRows, id: \.name) { row in
                    HStack {
                        Text(row.name)
                            .customFont(modelData.appConfig.appFontBold, size: modelData.appConfig.isIPhone ? 16 : 24)
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                        Spacer()
                        Text(row.value)
                            .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 16 : 24)
                            .foregroundColor(.white)
                            .padding(.trailing, 16)
                    }
                }
            }
        }
        .padding()
        .background(BlurView(style: .systemMaterialDark))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
    }
}

#Preview {
    SectionView(title: "Game Stats", sectionRows: [
        SectionRow(name: "Total white move: ", value: "12"),
        SectionRow(name: "Total black move: ", value: "11"),
    ])
    .environment(ModelData.previewModelData)
}
