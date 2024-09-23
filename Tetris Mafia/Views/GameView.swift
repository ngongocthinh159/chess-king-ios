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
import PopupView

struct GameView: View {
    @Environment(ModelData.self) var modelData
    @Environment(SessionManager.self) var session
    @Environment(\.presentationMode) var presentationMode
    
    var viewModel: GameViewModel
    @State var checkMate = false
    @State var whiteReceivedBadges: [Badge] = []
    @State var blackReceivedBadges: [Badge] = []
    @State var whiteScoreChange: Int = 0
    @State var blackScoreChange: Int = 0
    @State var isShowGameOverPopup: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundImage(image : modelData.appConfig.backgroundImageName)
            
            VStack(spacing: modelData.appConfig.isIPhone ? 28 : 56) {
                // MARK: black player
                HStack {
                    Spacer()
                    
                    PlayerInfoInGame(left: false,
                                     image: modelData.getUserByName(name: viewModel.roster.blackPlayer.name)?.avatar.toImageString() ?? "no-image",
                                     name: viewModel.roster.blackPlayer.name,
                                     winRate: modelData.getUserByName(name: viewModel.roster.blackPlayer.name)?.getStats().winRate ?? 0)
                }
                
                // MARK: board
                BoardView(viewModel: viewModel)
                
                // MARK: white player
                HStack {
                    PlayerInfoInGame(left: true,
                                     image: modelData.getUserByName(name: viewModel.roster.whitePlayer.name)?.avatar.toImageString() ?? "no-image",
                                     name: viewModel.roster.whitePlayer.name,
                                     winRate: modelData.getUserByName(name: viewModel.roster.whitePlayer.name)?.getStats().winRate ?? 0)
                    Spacer()
                }
                
                // MARK: game status + reverse button
                HStack(alignment: .center) {
                    StatusView(viewModel: viewModel)
                }
            }
            .padding(.top)
            .padding(.top)
            .padding(.top)
            .padding(.top)
            .padding()
//            .alert("Checkmate", isPresented: $checkMate) {
//                
//            } message: {
//                Text("Game Over. \(viewModel.game.turn.opponent) has won")
//            }
            .onReceive(viewModel.checkmateOccured, perform: { _ in
                checkMate = true
                
                DispatchQueue.main.async {
                    saveUserStatsAfterGameFinish()
                    isShowGameOverPopup = true
                    
                    playSoundAfterGameEnd()
                }
            })
        }
        .navigationBarBackButtonHidden(true)
        .withHeader(title: modelData.appConfig.getGameView_PageHeader_Text(),
                    isBackable: true,
                    isShowConfirmBeforeBack: true,
                    alertMessage: modelData.appConfig.getGameView_GoBackAlertMessage_Text())
        
        // MARK: - Popup
        .popup(isPresented: $isShowGameOverPopup) {
            GameOverPopup(
                isWhitePlayerWin: isWhitePlayerWin(),
                isVsAI: isVsAIGame(),
                whiteBadges: $whiteReceivedBadges,
                blackBadges: $blackReceivedBadges,
                whiteName: viewModel.roster.whitePlayer.name,
                blackName: viewModel.roster.blackPlayer.name,
                whiteScoreChange: $whiteScoreChange,
                blackScoreChange: $blackScoreChange,
                gameStats: viewModel.game.getGameStats())
            {
                isShowGameOverPopup = false
                presentationMode.wrappedValue.dismiss()
            }
        } customize: {
            $0
                .closeOnTap(false)
                .closeOnTapOutside(false)
        }
        
        
        // Music
        .onAppear {
            AudioManager.shared.pauseAllMusics()
            AudioManager.shared.stopGameMusic()
            AudioManager.shared.playGameMusic(filename: modelData.appConfig.inGameMusicName)
        }
    }
    
    func saveUserStatsAfterGameFinish() {
        let gameStats = viewModel.game.getGameStats()
        
        // white player
        session.user.lastGameState = nil
        session.user.playedGames.append(viewModel.game)
        session.user.totalPlay += 1
        session.user.totalWins += isWhitePlayerWin() ? 1 : 0
        
        session.user.totalCastlings += gameStats.whiteTotalCastlings
        session.user.totalEnpassants += gameStats.whiteTotalEnpassants
        session.user.totalPromotions += gameStats.whiteTotalPromotions
        
        let newWhiteAllBadges = getAllApplicableBadge(
            totalWinsIncludeGame: session.user.totalWins,
            userName: session.user.name,
            hasEnpassant: gameStats.whiteTotalEnpassants > 0,
            hasPromotion: gameStats.whiteTotalPromotions > 0,
            hasCastling: gameStats.whiteTotalCastlings > 0
        )
        if isWhitePlayerWin() {
            whiteReceivedBadges = getNewBadges(oldBadges: session.user.badges, newBadges: newWhiteAllBadges)
            session.user.badges = newWhiteAllBadges
        }
        session.user.score = getFinalWhitePlayerScoreAndSetViewFinalScoreChange(whiteUser: session.user)
        session.user.scoreHistory.append(ScoreHistoryEntry(score: session.user.score, time: Date.now))
        
        session.save()
        
        
        
        // black player
        let blackUser = modelData.getUserByName(name: viewModel.roster.blackPlayer.name)!
        blackUser.lastGameState = nil
        blackUser.playedGames.append(viewModel.game)
        blackUser.totalPlay += 1
        blackUser.totalWins += isWhitePlayerWin() ? 0 : 1
        
        blackUser.totalCastlings += gameStats.blackTotalCastlings
        blackUser.totalEnpassants += gameStats.blackTotalEnpassants
        blackUser.totalPromotions += gameStats.blackTotalPromotions
        
        let newBlackAllBadges = getAllApplicableBadge(
            totalWinsIncludeGame: blackUser.totalWins,
            userName: blackUser.name,
            hasEnpassant: gameStats.blackTotalEnpassants > 0,
            hasPromotion: gameStats.blackTotalPromotions > 0,
            hasCastling: gameStats.blackTotalCastlings > 0
        )
        if !isWhitePlayerWin() {
            blackReceivedBadges = getNewBadges(oldBadges: blackUser.badges, newBadges: newBlackAllBadges)
            blackUser.badges = newBlackAllBadges
        }
        blackUser.score = getFinalBlackPlayerScoreAndSetViewFinalScoreChange(blackUser: blackUser)
        blackUser.scoreHistory.append(ScoreHistoryEntry(score: session.user.score, time: Date.now))
        
        modelData.saveUser(user: blackUser)
    }
    
    func getFinalWhitePlayerScoreAndSetViewFinalScoreChange(whiteUser: User) -> Int {
        let desiredChange = getDesiredWhiteScoreChange(whiteUser: whiteUser)
        if whiteUser.score + desiredChange >= 0 {
            whiteScoreChange = desiredChange
            return whiteUser.score + desiredChange
        } else {
            whiteScoreChange = -whiteUser.score
            return 0
        }
    }
    
    func getFinalBlackPlayerScoreAndSetViewFinalScoreChange(blackUser: User) -> Int {
        let desiredChange = getDesiredBlackScoreChange(blackUser: blackUser)
        if blackUser.score + desiredChange >= 0 {
            blackScoreChange = desiredChange
            return blackUser.score + desiredChange
        } else {
            blackScoreChange = -blackUser.score
            return 0
        }
    }
    
    func getDesiredWhiteScoreChange(whiteUser: User) -> Int {
        var scoreChanges = 0
        if isWhitePlayerWin() {
            scoreChanges += GameRule.winScore
            
            // Defeat AI plus score
            if isVsAIGame() {
                let difficulty = Player.getDifficultyFromAIName(name: viewModel.roster.blackPlayer.name)
                switch difficulty {
                case .easy:
                    scoreChanges += GameRule.defeatEasyAIScore
                case .medium:
                    scoreChanges += GameRule.defeatMediumAIScore
                case .hard:
                    scoreChanges += GameRule.defeatHardAIScore
                }
            }
        } else {
            scoreChanges -= GameRule.winScore
        }
        
        return scoreChanges
    }
    
    func getDesiredBlackScoreChange(blackUser: User) -> Int {
        var scoreChanges = 0
        if isWhitePlayerWin() {
            scoreChanges -= GameRule.winScore
        } else {
            scoreChanges += GameRule.winScore
        }
        
        return scoreChanges
    }
    
    func getNewBadges(oldBadges: [Badge], newBadges: [Badge]) -> [Badge] {
        let oldSet = Set(oldBadges)
        let newSet = Set(newBadges)
        return Array(newSet.subtracting(oldSet))
    }
    
    func getAllApplicableBadge(totalWinsIncludeGame: Int, userName: String, hasEnpassant: Bool, hasPromotion: Bool, hasCastling: Bool) -> [Badge] {
        let user = modelData.getUserByName(name: userName)!
        
        let totalWins = totalWinsIncludeGame
        let _: Player = viewModel.roster.whitePlayer.name == user.name ? viewModel.roster.whitePlayer : viewModel.roster.blackPlayer
        let opponentPlayer: Player = viewModel.roster.whitePlayer.name == user.name ? viewModel.roster.blackPlayer : viewModel.roster.whitePlayer
        
        var res = [Badge]()
        
        res.append(.firstPlay)
        if totalWins >= 10 {
            res.append(.win10)
        }

        if hasEnpassant {
            res.append(.enpassantExpert)
        }
        if hasPromotion {
            res.append(.promotionExpert)
        }
        if hasCastling {
            res.append(.castlingExpert)
        }
        
        if opponentPlayer.isAI {
            if modelData.appConfig.aiDifficulty == .easy {
                res.append(.beatEasyAI)
            }
            if modelData.appConfig.aiDifficulty == .medium {
                res.append(.beatMediumAI)
            }
            if modelData.appConfig.aiDifficulty == .hard {
                res.append(.beatHardAI)
            }
        }
        
        return res
    }
    
    func isWhitePlayerWin() -> Bool {
        return viewModel.game.turn.opponent.color == .white
    }
    
    func isVsAIGame() -> Bool {
        return viewModel.roster.blackPlayer.isAI
    }
    
    func playSoundAfterGameEnd() {
        if isVsAIGame() {
            if isWhitePlayerWin() {
                // Win again AI
                AudioManager.shared.playSoundEffect(filename: modelData.appConfig.gameWinMusic)
            } else {
                // Lose again AI
                AudioManager.shared.playSoundEffect(filename: modelData.appConfig.gameLoseMusic)
            }
        } else {
            // 2 player mode => play more general sound
            AudioManager.shared.playSoundEffect(filename: modelData.appConfig.gameOverMusic)
        }
    }
}

#Preview {
    GameView_Previews.previews
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            gameViewStandardGame()
                .environment(ModelData.previewModelData)
                .environment(SessionManager.previewSession)
        }
    }
    
    static func gameViewStandardGame() -> some View {
        let vm = GameViewModel(roster: Roster(whitePlayer: .human(TheHuman(name: "Thinh Ngo")), blackPlayer: .human(TheHuman(name: "Bomman"))), session: SessionManager.previewSession)
        
        return GameView(viewModel: vm)
            .previewLayout(.fixed(width: 350, height: 350))
    }
}
