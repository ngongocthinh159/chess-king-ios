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

struct Settings: View {
    @Environment(ModelData.self) var data
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isSoundOn: Bool?
    @State private var selectedDifficulty: AIDifficulty?  // Assuming AIDifficulty is an enum
    @State private var selectedAppTheme: Theme?
    @State private var selectedBoardTheme: BoardTheme?
    @State private var selectedLanguage: AppLanguage?
    @State private var isShowLanguagePicking: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundImage(image: data.appConfig.backgroundImageName)
            
            ScrollView {
                VStack(spacing: 36) {
                    // MARK: general
                    SettingsSectionView(title: data.appConfig.getSettingsView_General_Text()) {
                        VStack {
                            BoolSettingRowView(
                                settingRow: SettingRow(name: "sound",
                                                       friendlyName: data.appConfig.getSettingsView_SoundFriendlyLabel_Text()),
                                isEnabled: isSoundOn != nil ? .constant(isSoundOn!) : .constant(false)
                            ) {
                                if isSoundOn != nil {
                                    if isSoundOn! {
                                        stopMusicAndSaveSoundConfig()
                                    } else {
                                        resumeMusicAndSaveSoundConfig()
                                    }
                                    isSoundOn = !(isSoundOn!)
                                }
                                
                                AudioManager.shared.playSoundEffect(filename: data.appConfig.settingTapMusic)
                            }
                            
                            NavigateToOtherSettingRowView(
                                settingRow: SettingRow(name: "language", 
                                                       friendlyName: data.appConfig.getSettingsView_LanguageFriendlyLabel_Text()),
                                iconImageName: "chevron.down",
                                additionalText: "\(data.appConfig.language.toRepresentation(inLangue: data.appConfig.language))",
                                iconSize: 16) {
                                    isShowLanguagePicking = true
                                    
                                    AudioManager.shared.playSoundEffect(filename: data.appConfig.settingTapMusic)
                                }
                        }
                    }
                    
                    // MARK: App theme
                    SettingsSectionView(title: data.appConfig.getSettingsView_AppTheme_Text()) {
                        HStack(spacing: 12) {
                            ForEach(Theme.allCases, id: \.self) { theme in
                                ThemeEntrySelectionView(image: theme.reprentImage,
                                                        themeName: theme.name,
                                                        height: 100,
                                                        isSelected: .constant(selectedAppTheme == theme))
                                .onTapGesture {
                                    data.appConfig.theme = theme
                                    data.save()
                                    
                                    selectedAppTheme = theme
                                    
                                    AudioManager.shared.playSoundEffect(filename: data.appConfig.settingTapMusic)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // MARK: Board theme
                    SettingsSectionView(title: data.appConfig.getSettingsView_BoardTheme_Text()) {
                        HStack(spacing: 12) {
                            ForEach(BoardTheme.allCases, id: \.self) { theme in
                                ThemeEntrySelectionView(image: theme.reprentImage,
                                                        themeName: theme.name,
                                                        height: 140,
                                                        isSelected: .constant(selectedBoardTheme == theme))
                                .onTapGesture {
                                    data.appConfig.boardTheme = theme
                                    data.save()
                                    
                                    selectedBoardTheme = theme
                                    
                                    AudioManager.shared.playSoundEffect(filename: data.appConfig.settingTapMusic)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // MARK: AI difficulty
                    SettingsSectionView(title: data.appConfig.getSettingsView_AIDifficulty_Text()) {
                        VStack(spacing: 12) {
                            ForEach(AIDifficulty.allCases, id: \.self) { difficulty in
                                DifficultySettingRowView(
                                    description: data.appConfig.getSettingsView_AIDescription_Text(difficulty: difficulty),
                                    imageName: difficulty.representImage,
                                    aiName: difficulty.name,
                                    isSelected: .constant(selectedDifficulty == difficulty)
                                )
                                .onTapGesture {
                                    data.appConfig.aiDifficulty = difficulty
                                    data.save()
                                    
                                    selectedDifficulty = difficulty
                                    
                                    AudioManager.shared.playSoundEffect(filename: data.appConfig.settingTapMusic)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, data.appConfig.isIPhone ? 80 : 120)
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .withHeader(title: data.appConfig.getSettingsView_PageHeader_Text())
        
        // MARK: - Language picking popup
        .popup(isPresented: $isShowLanguagePicking) {
            LanguagePickingView(selectedLanguage: Binding($selectedLanguage) ?? .constant(.EN)) {
                isShowLanguagePicking = false
            }
        } customize: {
            $0
                .closeOnTap(false)
                .closeOnTapOutside(false)
        }
        
        // MARK: - Init setting values
        .onAppear {
            isSoundOn = data.appConfig.isSoundOn
            selectedDifficulty = data.appConfig.aiDifficulty
            selectedAppTheme = data.appConfig.theme
            selectedBoardTheme = data.appConfig.boardTheme
            selectedLanguage = data.appConfig.language
        }
    }
    
    func stopMusicAndSaveSoundConfig() {
        AudioManager.shared.pauseAllMusics()
        data.appConfig.isSoundOn = false
        data.save()
    }
    
    func resumeMusicAndSaveSoundConfig() {
        data.appConfig.isSoundOn = true
        data.save()
        
        if AudioManager.shared.isBackgoundPlayerPlaying() {
            AudioManager.shared.resumeBackgoundMusic()
        } else {
            AudioManager.shared.playBackgroundMusic(filename: data.appConfig.backgroundMusicName)
        }
    }
}

#Preview {
    Settings()
        .environment(ModelData.previewModelData)
}
