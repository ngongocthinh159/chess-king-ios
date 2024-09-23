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

struct GameOverPopup: View {
    @Environment(ModelData.self) var modelData
    
    var isWhitePlayerWin: Bool
    var isVsAI: Bool
    @Binding var whiteBadges: [Badge]
    @Binding var blackBadges: [Badge]
    var whiteName: String
    var blackName: String
    @Binding var whiteScoreChange: Int
    @Binding var blackScoreChange: Int
    var gameStats: GameStats
    var closeAction: () -> Void
    
    var body: some View {
        Popup(title: "Over", closeAction: closeAction) {
            VStack(spacing: 24) {
                // MARK: Win lose text
                VStack {
                    if (isVsAI) {
                        Text("\(modelData.appConfig.language == .EN ? "You are" : "Bạn đã") "
                             + (isWhitePlayerWin ? (modelData.appConfig.language == .EN ? "win" : "thắng") :
                                                    (modelData.appConfig.language == .EN ? "lose" : "thua")) + "!")
                            .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 36 : 48)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                        
                        Text((isWhitePlayerWin ? (modelData.appConfig.language == .EN ? "Congratulation" : "Chúc mừng") :
                                (modelData.appConfig.language == .EN ? "Try harder next time" : "Cố hơn trong lần tới nhé")))
                            .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 16 : 28)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                        
                        Text("\(getScores_Lang()): \(whiteScoreChange >= 0 ? "+" : "")\(whiteScoreChange)")
                            .customFont(modelData.appConfig.appFontRegular, size: modelData.appConfig.isIPhone ? 16 : 28)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                            .padding(.top, 2)
                        
                    } else {
                        Text("\(isWhitePlayerWin ? getWhiteName_Lang() : getBlackName_Lang()) is win!")
                            .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 36 : 48)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                        
                        Text("\(modelData.appConfig.language == .EN ? "Congratulation" : "Chúc mừng")")
                            .customFont(modelData.appConfig.appFontBlack, size: modelData.appConfig.isIPhone ? 16 : 28)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                        
                        Text("\(getWhiteName_Lang()) \(getScores_Lang()): \(whiteScoreChange >= 0 ? "+" : "")\(whiteScoreChange)")
                            .customFont(modelData.appConfig.appFontRegular, size: modelData.appConfig.isIPhone ? 16 : 28)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                            .padding(.top, 2)
                            .padding(.bottom, 1)
                        
                        Text("\(getBlackName_Lang()) \(getScores_Lang()): \(blackScoreChange >= 0 ? "+" : "")\(blackScoreChange)")
                            .customFont(modelData.appConfig.appFontRegular, size: modelData.appConfig.isIPhone ? 16 : 28)
                            .foregroundColor(modelData.appConfig.textColorOnBG)
                    }
                }
                
                // MARK: Badges
                if isVsAI {
                    if !whiteBadges.isEmpty {
                        BadgeListView(title: "\(isEN() ? "Your New Badges" : "Huy Hiệu Mới") 🔥", badges: whiteBadges)
                    }
                } else {
                    if !whiteBadges.isEmpty {
                        BadgeListView(title: "\(isEN() ? "White's New Badges" : "Huy hiệu mới của " + getWhiteName_Lang()) 🔥", badges: whiteBadges)
                    }
                    if !blackBadges.isEmpty {
                        BadgeListView(title: "\(isEN() ? "Black's New Badges" : "Huy hiệu mới của " + getBlackName_Lang()) 🔥", badges: blackBadges)
                    }
                }
                
                // MARK: Stats
                SectionView(title: "\(isEN() ? "Game Stats" : "Thống Kê Game")  🍎",
                            sectionRows: isVsAI ?
                                getSectionRowsFromGameStatsForVsAIGame() : getSectionRowsFromGameStatsForTwoPlayersGame())
            }
            
        }
    }
    
    func isEN() -> Bool {
        return modelData.appConfig.language == .EN
    }
    
    func getWhiteName_Lang() -> String {
        switch modelData.appConfig.language {
        case .EN:
            return "White"
        case .VN:
            return "Trắng"
        }
    }
    
    func getBlackName_Lang() -> String {
        switch modelData.appConfig.language {
        case .EN:
            return "Black"
        case .VN:
            return "Đen"
        }
    }
    
    func getScores_Lang() -> String {
        switch modelData.appConfig.language {
        case .EN:
            return "Score Changes"
        case .VN:
            return "Thay Đổi Điểm"
        }
    }
    
    // \(isEN() ? "" : "")
    func getSectionRowsFromGameStatsForVsAIGame() -> [SectionRow] {
        return [
            SectionRow(name: "\(isEN() ? "Your total moves" : "Số nước đi của bạn"): ", value: String(gameStats.whiteTotalMoves)),
            SectionRow(name: "\(isEN() ? "AI total moves" : "Số nước đi của AI"): ", value: String(gameStats.blackTotalMoves)),
            SectionRow(name: "\(isEN() ? "Your en passants" : "En Passant của bạn"): ", value: String(gameStats.whiteTotalEnpassants)),
            SectionRow(name: "\(isEN() ? "AI en passants" : "En Passant của AI"): ", value: String(gameStats.blackTotalEnpassants)),
            SectionRow(name: "\(isEN() ? "Your promotions" : "Phong cấp của bạn"): ", value: String(gameStats.whiteTotalPromotions)),
            SectionRow(name: "\(isEN() ? "AI promotions" : "Phong cấp của AI"): ", value: String(gameStats.blackTotalPromotions)),
            SectionRow(name: "\(isEN() ? "Your catslings" : "Nhập thành của bạn"): ", value: String(gameStats.whiteTotalCastlings)),
            SectionRow(name: "\(isEN() ? "AI catslings" : "Nhập thành của AI"): ", value: String(gameStats.blackTotalCastlings)),
        ]
    }
    
    func getSectionRowsFromGameStatsForTwoPlayersGame() -> [SectionRow] {
        return [
            SectionRow(name: "\(isEN() ? "White total moves" : "Số nước đi của trắng"): ", value: String(gameStats.whiteTotalMoves)),
            SectionRow(name: "\(isEN() ? "Black total moves" : "Số nước đi của đen"): ", value: String(gameStats.blackTotalMoves)),
            SectionRow(name: "\(isEN() ? "White en passants" : "En Passant của trắng"): ", value: String(gameStats.whiteTotalEnpassants)),
            SectionRow(name: "\(isEN() ? "Black en passants" : "En Passant của đen"): ", value: String(gameStats.blackTotalEnpassants)),
            SectionRow(name: "\(isEN() ? "White promotions" : "Phong cấp của trắng"): ", value: String(gameStats.whiteTotalPromotions)),
            SectionRow(name: "\(isEN() ? "Black promotions" : "Phong cấp của đen"): ", value: String(gameStats.blackTotalPromotions)),
            SectionRow(name: "\(isEN() ? "White catslings" : "Nhập thành của trắng"): ", value: String(gameStats.whiteTotalCastlings)),
            SectionRow(name: "\(isEN() ? "Black catslings" : "Nhập thành của đen"): ", value: String(gameStats.blackTotalCastlings)),
        ]
    }
}

#Preview {
    GameOverPopup(isWhitePlayerWin: false, 
                  isVsAI: true,
                  whiteBadges: .constant(Badge.previews()),
                  blackBadges: .constant(Badge.previews()),
                  whiteName: "Thinh Ngo",
                  blackName: "Tom Huynh",
                  whiteScoreChange: .constant(300),
                  blackScoreChange: .constant(-300),
                  gameStats: GameStats.previews(), closeAction: {})
        .environment(ModelData.previewModelData)
}
