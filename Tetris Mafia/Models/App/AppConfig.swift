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

import Foundation
import SwiftUI

enum AIDifficulty: Int, Codable, CaseIterable {
    case easy = 1
    case medium = 2
    case hard = 3
    
    var description: String {
        switch self {
        case .easy:
            return "Beginner Friendly: Developed using a basic Minimax algorithm with alpha-beta pruning, this AI provides a manageable challenge, perfect for beginners looking to practice fundamental strategies. Its response time and tactical depth are limited, making it a great starting opponent"
        case .medium:
            return "Intermediate Challenge: Powered by the renowned Stockfish API, this AI operates at a search depth of 10, equating to an approximate rating of 1800 ELO. It offers a balanced challenge that requires solid tactical and strategic play, suitable for intermediate players"
        case .hard:
            return "Expert Level: Designed for advanced players, this AI uses a deep search of 15 levels, reaching an ELO of around 2563. Its superior strategic planning and tactical execution make it a formidable opponent, providing a stern test for even the most skilled chess enthusiasts"
        }
    }
    
    var representImage: String {
        switch self {
        case .easy:
            return "ava-ai-easy"
        case .medium:
            return "ava-ai-medium"
        case .hard:
            return "ava-ai-hard"
        }
    }
    
    var name: String {
        switch self {
        case .easy:
            return "Michael"
        case .medium:
            return "Alex"
        case .hard:
            return "TomHuynh"
        }
    }
}

enum Theme: String, Codable, CaseIterable {
    case modern
    case halloween
    
    var reprentImage: String {
        switch self {
        case .modern:
            return "background-modern"
        case .halloween:
            return "background-halloween"
        }
    }
    
    var name: String {
        switch self {
        case .modern:
            return "Modern"
        case .halloween:
            return "Halloween"
        }
    }
}

enum BoardTheme: String, Codable, CaseIterable {
    case modern
    case halloween
    case wood
    
    var reprentImage: String {
        switch self {
        case .modern:
            return "board-theme-represent-modern"
        case .halloween:
            return "board-theme-represent-halloween"
        case .wood:
            return "board-theme-represent-wood"
        }
    }
    
    var name: String {
        switch self {
        case .modern:
            return "Modern"
        case .halloween:
            return "Halloween"
        case .wood:
            return "Wood"
        }
    }
}

enum AppLanguage: String, Codable, CaseIterable {
    case EN
    case VN
    
    func toRepresentation(inLangue: AppLanguage) -> String {
        switch self {
        case .EN:
            return inLangue == .EN ? "English" : "Tiếng Anh"
        case .VN:
            return inLangue == .EN ? "Vietnamese" : "Tiếng Việt"
        }
    }
}

class AppConfig: Codable {
    var theme: Theme
    var boardTheme: BoardTheme
    var aiDifficulty: AIDifficulty
    var isSoundOn: Bool
    var language: AppLanguage
    
    init() {
        self.theme = .halloween
        self.boardTheme = .modern
        self.aiDifficulty = .easy
        self.isSoundOn = true
        self.language = .VN
    }
    
    init(theme: Theme, boardTheme: BoardTheme) {
        self.theme = theme
        self.boardTheme = boardTheme
        self.aiDifficulty = .easy
        self.isSoundOn = true
        self.language = .VN
    }
    
    init(theme: Theme, boardTheme: BoardTheme, aiDifficulty: AIDifficulty) {
        self.theme = theme
        self.boardTheme = boardTheme
        self.aiDifficulty = aiDifficulty
        self.isSoundOn = true
        self.language = .VN
    }
    
    init(theme: Theme, boardTheme: BoardTheme, aiDifficulty: AIDifficulty, isSoundOn: Bool, language: AppLanguage) {
        self.theme = theme
        self.boardTheme = boardTheme
        self.aiDifficulty = aiDifficulty
        self.isSoundOn = isSoundOn
        self.language = language
    }
    
    var accentColor: Color  {
        return Color("accent" + getSuffix(isCommonForTheme: false, isCommonForLang: true))
    }
    
    var accentHex: String  {
        return Color("accent" + getSuffix(isCommonForTheme: false, isCommonForLang: true)).toHex()!
    }
    
    var backgroundImage: Image {
        return Image("background" + getSuffix(isCommonForTheme: false, isCommonForLang: true))
    }
    
    var backgroundImageName: String  {
        return "background" + getSuffix(isCommonForTheme: false, isCommonForLang: true)
    }
    
    // is common meaning this button has theme? or just has localization
    func getSuffix(isCommonForTheme: Bool = false, isCommonForLang: Bool = false) -> String {
        var suf = ""
        
        // theme suffix
        if !isCommonForTheme {
            suf += "-" + (self.theme == .modern ? "modern" : "halloween")
        }
        
        // localization suffix
        if !isCommonForLang {
            switch self.language {
            case .EN:
                suf += ""
            case .VN:
                suf += "-" + "vn"
            }
        }

        return suf
    }
    
    var  isIPhone: Bool  {
        let deviceType = UIDevice.current.userInterfaceIdiom

        switch deviceType {
        case .phone:
            return true 
        case .pad:
            return false 
        default:
            return false 
        }
    }
    
    var logoImageName: String {
        return "logo"
    }
    
    var menuButtonWidth: CGFloat {
        return CGFloat(self.isIPhone ? 260 : 420)
    }
    
    var menuButtonHeight: CGFloat {
        return CGFloat(self.isIPhone ? 60 : menuButtonWidth/260*60)
    }

    var menuLogoWidth: CGFloat {
        return CGFloat(self.isIPhone ? 260 : 480)
    }
    
    var textColorOnBG: Color {
        switch theme {
        case .modern:
            return .white
        case .halloween:
            return .white
        }
    }
    
    var popupWidth: CGFloat {
        return isIPhone ? UIScreen.main.bounds.width - 72 : UIScreen.main.bounds.width - 72*2
    }
    
    var popupHeight: CGFloat {
        return isIPhone ? UIScreen.main.bounds.height - 200 : UIScreen.main.bounds.height - 200*2
    }
    
    var leaderboardBadgesWidth: CGFloat {
        return isIPhone ? 150 : 300
    }
    
    var leaderboardScoreWidth: CGFloat {
        return isIPhone ? 60 : 120
    }
}

// Button
extension AppConfig {
    // Common button has no theme only localization
    var signupButtonName: String {
        return "signup-btn" + getSuffix(isCommonForTheme: true)
    }
    
    var continueGameButtonName: String {
        return "continue-game-btn" + getSuffix(isCommonForTheme: true)
    }
    
    // Button has theme
    var playAIButtonName: String {
        return "menu-btn-play-ai" + getSuffix()
    }
    
    var twoPlayersButtonName: String {
        return "menu-btn-2player" + getSuffix()
    }
    
    var profileButtonName: String {
        return "menu-btn-profile" + getSuffix()
    }
    
    var settingsButtonName: String {
        return "menu-btn-settings" + getSuffix()
    }
    
    var registerButtonName: String {
        return "register-btn" + getSuffix()
    }
    
    var backButtonName: String {
        return "back-btn" + getSuffix()
    }
    
    var loginButtonName: String {
        return "login-btn" + getSuffix()
    }
    
    var leaderBoardButtonName: String {
        return "leader-btn" + getSuffix()
    }
    
    var okButtonName: String {
        return "ok-btn" + getSuffix()
    }
    
    var howToPlayButtonName: String {
        return "how-to-play-btn" + getSuffix()
    }
}

// Board customization
extension AppConfig {
    var blackTileBGColor: Color {
        switch self.boardTheme {
        case .modern:
            return Color(hex: "4068F5")
        case .halloween:
            return Color(hex: "D959AC")
        case .wood:
            return Color(hex: "732E11")
        }
    }
    
    var whileTileBGColor: Color {
        switch self.boardTheme {
        case .modern:
            return .white
        case .halloween:
            return Color(hex: "E9ECF4")
        case .wood:
            return Color(hex: "FFE8DE")
        }
    }
    
    var boardBorderPadding: CGFloat {
        return CGFloat(self.isIPhone ? 12 : 24)
    }
    
    var boardBorderWidth: CGFloat {
        return boardBorderPadding - spacingBetweenEachTile
    }
    
    var boardBorderColor: Color {
        switch self.boardTheme {
        case .modern:
            return Color(hex: "4068F5")
        case .halloween:
            return Color(hex: "D959AC")
        case .wood:
            return Color(hex: "38180B")
        }
    }
    
    var boardBGColor: Color {
        switch self.boardTheme {
        case .modern:
            return .clear
        case .halloween:
            return .clear
        case .wood:
            return Color(hex: "38180B").opacity(0.6)
        }
    }
    
    var boardCornerRadius: CGFloat {
        return CGFloat(self.isIPhone ? 12 : 24)
    }
    
    var tileBorderWidth: CGFloat {
        return CGFloat(self.isIPhone ? 2 : 4)
    }
    
    var tileBorderColor: Color {
        return .black
    }
    
    var spacingBetweenEachTile: CGFloat {
        return CGFloat(self.isIPhone ? 2 : 4)
    }
    
    var piecePadding: CGFloat {
        return CGFloat(self.isIPhone ? 2 : 4)
    }
    
    var titleSelectHightlightColor: Color {
        return self.boardTheme == .modern ? .black : .green
    }
    
    var captureMoveHightlightColor: Color {
        return .red
    }
    
    var validMoveHightlightColor: Color {
        return self.boardTheme == .modern ? .yellow : .blue
    }
    
    var boardMaxWidth: CGFloat {
        return CGFloat(self.isIPhone ? 360 : 600)
    }
    
    var boardMaxHeight: CGFloat {
        return CGFloat(self.boardMaxWidth)
    }
}

// Font customization
extension AppConfig {
    var appFont: String  {
        return "Nunito"
    }
    
    var appFontBold: String {
        return appFont + "-Bold"
    }
    
    var appFontBlack: String {
        return appFont + "-Black"
    }
    
    var appFontRegular: String {
        return appFont + "-Regular"
    }
}

// How to play steps
extension AppConfig {
    var stepHeaderFontSize: CGFloat {
        return CGFloat(28)
    }
    
    var stepSectionTitleFontSize: CGFloat {
        return CGFloat(24)
    }
    
    var stepNormalTextFontSize: CGFloat {
        return CGFloat(18)
    }
}

// Sounds
extension AppConfig {
    var backgroundMusicName: String {
        return "music-victory.mp3"
    }
    
    var inGameMusicName: String {
        return "8-bit-retro-game-music.mp3"
    }
    
    var leaderboardMusic: String {
        return "leaderboard.mp3"
    }
    
    var howToPlayMusic: String {
        return "how-to-play.mp3"
    }
    
    var buttonTappingMusic: String {
        return "mouse-click.wav"
    }
    
    var boardTouchMusic: String {
        return "arcade-game-jump-coin.wav"
    }
    
    var settingTapMusic: String {
        return "mixkit-modern-technology-select.wav"
    }
    
    var profileButtonTapMusic: String {
        return "mouse-click.wav"
    }
    
    var gameWinMusic: String {
        return "game-win-male.mp3"
    }
    
    var gameLoseMusic: String {
        return "game-lose.wav"
    }
    
    var gameOverMusic: String {
        return "violin-gameover.mp3"
    }
}
