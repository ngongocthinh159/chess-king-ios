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

struct MenuView: View {
    @Environment(ModelData.self) var modelData
    @Environment(SessionManager.self) var session
    @Environment(\.presentationMode) var presentationMode
    
    enum PlayMode {
        case vsAI
        case twoPlayers
    }
    
    @State private var isShowGameView = false
    @State private var isShowProfileView = false
    @State private var isShowLeaderBoardView = false 
    @State private var isShowSettingsView = false
    @State private var isShowHowToPlayView = false
    @State private var playMode: PlayMode = .vsAI
    @State private var vm: GameViewModel?
    @State private var isShowOtherPlayNameInputField = false 
    @State private var isShowSheetToPickOtherPlayerNameFor2PlayersMode = false 
    
    @State private var otherPlayerName: String = ""
    @State private var otherPlayerNameErrorMsg: String?
    
    var body: some View {
        ZStack {
            BackgroundImage(image: modelData.appConfig.backgroundImageName)
            
            VStack {
                Image(modelData.appConfig.logoImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: modelData.appConfig.menuLogoWidth)
                
                VStack(spacing: 24) {
                    if hasPreviousRunningGame() {
                        // MARK: - continue last game
                        ImageButton(imageName: modelData.appConfig.continueGameButtonName, width: modelData.appConfig.menuButtonWidth + 32) {
                            replayLastRunningGame()
                        }
                    }
                    
                    // MARK: - leader board
                    ImageButton(imageName: modelData.appConfig.leaderBoardButtonName, width: modelData.appConfig.menuButtonWidth) {
                        isShowLeaderBoardView = true 
                    }
                    
                    // MARK: - play AI
                    ImageButton(imageName: modelData.appConfig.playAIButtonName, width: modelData.appConfig.menuButtonWidth) {
                        startNewGameVsAIMode()
                    }
                    
                    // MARK: - play 2 players
                    ImageButton(imageName: modelData.appConfig.twoPlayersButtonName, width: modelData.appConfig.menuButtonWidth) {
                        isShowSheetToPickOtherPlayerNameFor2PlayersMode = true
                    }
                    
                    // MARK: - how to play
                    ImageButton(imageName: modelData.appConfig.howToPlayButtonName, width: modelData.appConfig.menuButtonWidth) {
                        isShowHowToPlayView = true
                    }
                    
                    // MARK: - settings
                    ImageButton(imageName: modelData.appConfig.settingsButtonName, width: modelData.appConfig.menuButtonWidth) {
                        isShowSettingsView = true
                    }
                }
                
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowSheetToPickOtherPlayerNameFor2PlayersMode) {
            OtherPlayerPickerView(inputText: $otherPlayerName, inputErrorMessage: $otherPlayerNameErrorMsg, buttonAction: play2PlayersModeIfValidPicking)
                .presentationDetents([.medium])
        }
        
        // MARK: - Profile button
        .overlay(
            // Button as an overlay
            Button(action: {
                isShowProfileView = true
                
                AudioManager.shared.playSoundEffect(filename: modelData.appConfig.profileButtonTapMusic)
            }) {
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(15)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    if !modelData.appConfig.isIPhone {
                        Text("Hi \(session.user.name)!")
                            .myTextStyle()
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding([.top, .trailing], modelData.appConfig.isIPhone ? 24 : 80),
            
            alignment: .topTrailing
        )
        
        // MARK: - Music
        .onAppear {
            AudioManager.shared.pauseAllMusicsExcept("background")
            AudioManager.shared.resumeBackgoundMusic()
        }
        
        
        // MARK: - Navigation
        .navigationDestination(isPresented: $isShowGameView) {
            GameView(viewModel: vm ?? getDefaultGame())
        }
        .navigationDestination(isPresented: $isShowProfileView) {
            ProfileView(user: session.user, isMyself: true)
        }
        .navigationDestination(isPresented: $isShowLeaderBoardView) {
            LeaderBoardView()
        }
        .navigationDestination(isPresented: $isShowHowToPlayView) {
            HowToPlayView(steps: modelData.appConfig.language == .EN ?
                          HowToPlayStep.staticStepsEnglish() : HowToPlayStep.staticStepsVietNamese())
        }
        .navigationDestination(isPresented: $isShowSettingsView) {
            Settings()
        }
    }
    
    func play2PlayersModeIfValidPicking() {
        let _otherPlayerName = otherPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if _otherPlayerName.isEmpty {
            otherPlayerNameErrorMsg = modelData.appConfig.getMenuView_OtherPlayerNameEmptyErroMsg_Text()
            return 
        }
        
        if _otherPlayerName.lowercased() == session.user.name.lowercased() {
            otherPlayerNameErrorMsg = modelData.appConfig.getMenuView_SamePlayerNameEmptyErroMsg_Text()
            return
        }
        
        for user in modelData.users {
            if user.type == .human && user.name.lowercased() == _otherPlayerName {
                
                startNewGameTwoPlayersMode(whiteName: session.user.name, blackName: _otherPlayerName)
                
                return
            }
        }
        
        otherPlayerNameErrorMsg = modelData.appConfig.getMenuView_PlayerNotFoundErroMsg_Text()
    }
    
    func hasPreviousRunningGame() -> Bool {
        return session.user.lastGameState != nil
    }
    
    func getDefaultGame() -> GameViewModel {
        return GameViewModel(
            roster: Roster(
                        whitePlayer: .human(TheHuman(name: session.user.name)),
                        blackPlayer: .AI(Michael())),
            session: self.session)
    }
    
    func startNewGameVsAIMode() {
        vm = GameViewModel(
            roster: Roster(
                whitePlayer: .human(TheHuman(name: session.user.name)),
                blackPlayer: Player.getAIPlayerFromDifficulty(difficulty: modelData.appConfig.aiDifficulty)),
            session: self.session)
        
        isShowGameView = true
        playMode = .vsAI
        
        // save lastGame
        session.user.lastGameState = GameState(
            game: vm?.game ?? getDefaultGame().game,
            whitePlayer: session.user.name,
            blackPlayer: Player.getAIPlayerFromDifficulty(difficulty: modelData.appConfig.aiDifficulty).name,
            vsAI: true
        )
        session.save()
    }
    
    func startNewGameTwoPlayersMode(whiteName: String, blackName: String ) {
        vm = GameViewModel(
            roster: Roster(
                whitePlayer: .human(TheHuman(name: whiteName)),
                blackPlayer: .human(TheHuman(name: blackName))),
            session: self.session)
        
        playMode = .twoPlayers
        isShowGameView = true
        isShowSheetToPickOtherPlayerNameFor2PlayersMode = false
        
        // save lastGame
        session.user.lastGameState = GameState(
            game: vm?.game ?? getDefaultGame().game,
            whitePlayer: whiteName,
            blackPlayer: blackName,
            vsAI: false 
        )
        session.save()
    }
    
    func replayLastRunningGame() {
        let lastGame = session.user.lastGameState!
        
        vm = GameViewModel(
            roster: Roster(
                whitePlayer: .human(TheHuman(name: lastGame.whitePlayer)),
                blackPlayer: lastGame.vsAI ? Player.getAIPlayerFromName(name: lastGame.blackPlayer)! : .human(TheHuman(name: lastGame.blackPlayer))),
            game: lastGame.game,
            session: self.session)
        
        isShowGameView = true
    }
}

#Preview {
    MenuView()
        .environment(ModelData.previewModelData)
        .environment(SessionManager.previewSession)
}
