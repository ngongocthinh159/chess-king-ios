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

struct ProfileView: View {
    @Environment(ModelData.self) var data
    
    @State private var showingAvatarPicker = false
    @State private var selectedAvatar: Avatar = .cat
    
    var user: User
    var isMyself: Bool

    var body: some View {
        ZStack {
            BackgroundImage(image: data.appConfig.backgroundImageName)
            
            ScrollView {
                VStack(spacing: data.appConfig.isIPhone ? 16 : 24) {
                    // MARK: Avatar + name
                    VStack(spacing: data.appConfig.isIPhone ? 24 : 36) {
                        Image(selectedAvatar.toImageString())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 4)
                            )
                            .overlay(
                                VStack {
                                    if isMyself {
                                        Button(action: {
                                            showingAvatarPicker = true
                                            
                                            AudioManager.shared.playSoundEffect(filename: data.appConfig.profileButtonTapMusic)
                                        }, label: {
                                            Image(systemName: "pencil.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                                .padding(6)
                                                .background(Color.black.opacity(0.24))
                                                .clipShape(Circle())
                                                .position(x: 130, y: 130)
                                        })
                                    }
                                }
                            )
                        
                        VStack(spacing: 4) {
                            // MARK: username text
                            Text(user.name)
                                .customFont(data.appConfig.appFontBlack, size: data.appConfig.isIPhone ? 32 : 48)
                                .foregroundColor(.white)
                            
                            // MARK: score text
                            Text("\(data.appConfig.getProfileView_Scores_Text()): \(String(user.score))")
                                .customFont(data.appConfig.appFontBlack, size: data.appConfig.isIPhone ? 16 : 32)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                    
                    // MARK: Stats
                    SectionView(title: data.appConfig.getProfileView_YourStats_Text(),
                                sectionRows: getUserStatsSectionRows())
                    
                    // MARK: Badges
                    if !user.badges.isEmpty {
                        BadgeListView(title: data.appConfig.getProfileView_YourBadges_Text(),
                                      badges: user.badges,
                                      titleFontSize: data.appConfig.isIPhone ? 24 : 36)
                    }
                    
                    // MARK: Line Chart
                    VStack(alignment: .leading) {
                        Text("\(data.appConfig.language == .EN ? "Scores History" : "Lịch Sử Điểm")")
                            .customFont(data.appConfig.appFontBold, size: data.appConfig.isIPhone ? 24 : 36)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        
                        LineChartView(data: user.getUserScoresLineChartData(language: data.appConfig.language))
                    }
                    .padding(.top, data.appConfig.isIPhone ? 24 : 36)
                    
                    Spacer()
                }
            }
            .padding()
            .padding(.top, 60)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selectedAvatar = user.avatar
        }
        
        // Avatar picker
        .sheet(isPresented: $showingAvatarPicker) {
            VStack {
                AvatarPickerView(selectedAvatar: $selectedAvatar) {
                    data.getUser(byId: user.id)?.avatar = selectedAvatar
                    data.save()
                }
            }
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.top, 24)
            .withHeader(title: "Avatar")
            .presentationDetents([.medium])
            .background(GradientBackground().ignoresSafeArea())
        }
        
        .withHeader(title: data.appConfig.getProfileView_PageHeader_Text())
    }
    
    func getUserStatsSectionRows() -> [SectionRow] {
        let userStats = user.getStats()
        
        return [
            SectionRow(name: "\(data.appConfig.getProfileView_Stats_TotalGames_Text()): ",
                       value: String(userStats.totalPlay)),
            SectionRow(name: "\(data.appConfig.getProfileView_Stats_TotalWins_Text()): ", 
                       value: String(userStats.totalWins)),
            SectionRow(name: "\(data.appConfig.getProfileView_Stats_WinRate_Text()): ",
                       value: String(format: "%.2f", userStats.winRate) + "%"),
            SectionRow(name: "\(data.appConfig.getProfileView_Stats_TotalEnPassantMoves_Text()): ",
                       value: String(userStats.totalEnpassants)),
            SectionRow(name: "\(data.appConfig.getProfileView_Stats_TotalCastlingMoves_Text()): ", 
                       value: String(userStats.totalCastlings)),
            SectionRow(name: "\(data.appConfig.getProfileView_Stats_TotalPromotionMoves_Text()): ",
                       value: String(userStats.totalPromotions)),
        ]
    }
}

#Preview {
    ProfileView(user: User.generateMockUser(name: "Thinh Ngo", type: .human), isMyself: true)
        .environment(ModelData.previewModelData)
}
