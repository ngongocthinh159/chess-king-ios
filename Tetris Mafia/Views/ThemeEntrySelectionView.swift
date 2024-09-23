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

struct ThemeEntrySelectionView: View {
    let image: String
    let themeName: String
    var width: CGFloat?
    var height: CGFloat?
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: width != nil ? width : .infinity, maxHeight: height != nil ? height : 80)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: isSelected ? 2 : 0)
                    )
                    .shadow(radius: 5)
                
                if isSelected {
    //                BlurView(style: .systemUltraThinMaterialLight)
    //                    .frame(width: width ?? .infinity, height: height ?? 80)
    //                    .cornerRadius(12)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                        .padding([.top, .trailing], 8)
                }
            }
            
            Text(themeName)
                .myTextStyle()
        }
        
    }
}

#Preview {
    ThemeEntrySelectionView(image: "background-halloween", themeName: "Halloween", isSelected: .constant(true))
}
