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

struct PlayerInfoInGame: View {
    @Environment(ModelData.self) var modelData 
    var left: Bool 
    var image: String
    var name: String 
    var winRate: Double
    
    var body: some View {
        HStack(spacing: 24) {
            if !left {
                VStack(alignment: left ? .leading : .trailing, spacing: 6)  {
                    Text(name )
                        .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 20 : 32)
                        .foregroundColor(modelData.appConfig.textColorOnBG)
                    
                    Text(String(format: "\(modelData.appConfig.getPlayerInfoInGameView_WinningRate_Text()): %.2f", winRate) + "%")
                        .customFont(modelData.appConfig.appFontBold, size: modelData.appConfig.isIPhone ? 14 : 24)
                        .foregroundColor(modelData.appConfig.textColorOnBG)
                }
            }
            
            CircleImage(image: image,
                        width: modelData.appConfig.isIPhone ? 60 : 120,
                        height : modelData.appConfig.isIPhone ? 60 : 120,
                        strokeWidth: modelData.appConfig.isIPhone ? 2 : 6)
            
            if left {
                VStack(alignment: left ? .leading : .trailing, spacing: 6)  {
                    Text(name )
                        .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 20 : 32)
                        .foregroundColor(modelData.appConfig.textColorOnBG)
                    
                    Text(String(format: "\(modelData.appConfig.getPlayerInfoInGameView_WinningRate_Text()): %.2f%", winRate) + "%")
                        .customFont(modelData.appConfig.appFontBold, size: modelData.appConfig.isIPhone ? 14: 24)
                        .foregroundColor(modelData.appConfig.textColorOnBG)
                }
            }
        }
    }
}

#Preview {
    PlayerInfoInGame(left: false , image: "ava-ai-tomhuynh", name: "TomHuynh super AI", winRate: 80.24)
        .environment(ModelData.previewModelData)
}
