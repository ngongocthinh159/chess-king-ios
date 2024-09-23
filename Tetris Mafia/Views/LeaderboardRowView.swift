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

struct LeaderboardRowView: View {
    @Environment(ModelData.self) var data
    
    var player: User
        
    var body: some View {
        HStack {
            Text(player.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .customFont(data.appConfig.appFontRegular, size: data.appConfig.isIPhone ? 16 : 28)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(player.badges.prefix(3), id: \.self) { badge in
                        Image(badge.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: data.appConfig.isIPhone ? 30 : 60, height: data.appConfig.isIPhone ? 30 : 60)
                    }
                    
                    Color.clear.frame(width: data.appConfig.leaderboardBadgesWidth, height: 40)
                }
                .frame(width: data.appConfig.leaderboardBadgesWidth, alignment: .leading)
            }
            

            Text("\(player.score)")
                .frame(width: data.appConfig.leaderboardScoreWidth, alignment: .trailing)
                .customFont(data.appConfig.appFontRegular, size: data.appConfig.isIPhone ? 16 : 28)
                .foregroundColor(.white)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding()
//        .background(Color.white.opacity(0.5))
//        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LeaderboardRowView(player: ModelData.previewModelData.users[3])
        .environment(ModelData.previewModelData)
}
