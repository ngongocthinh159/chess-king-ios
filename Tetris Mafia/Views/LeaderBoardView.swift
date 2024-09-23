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
import SwiftUICharts

struct LeaderBoardView: View {
    @Environment(ModelData.self) var data
    
    @State var selectedPlayer: User?
    @State var isShowPlayerProfile: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundImage(image: data.appConfig.backgroundImageName)
            
            VStack(spacing: 0) {
                ImageOverlapText(image: "leaderboard-logo", text: "Leaderboard")
                
                // Header Row
                HStack {
                    Text(data.appConfig.getLeaderboardView_Name_Text())
                        .myTextStyle()
                        .bold()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                    Text(data.appConfig.getLeaderboardView_Badges_Text())
                        .myTextStyle()
                        .bold()
                        .frame(width: data.appConfig.leaderboardBadgesWidth, alignment: .leading)
                    
                    Text(data.appConfig.getLeaderboardView_Scores_Text())
                        .myTextStyle()
                        .bold()
                        .frame(width: data.appConfig.leaderboardScoreWidth, alignment: .trailing)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                ScrollView {
                    VStack(spacing: data.appConfig.isIPhone ? 36 : 56) {
                        VStack(spacing: 0) {
                            // MARK: Player row
                            ForEach(getTopPlayers(), id: \.id) { player in
                                Button {
                                    selectedPlayer = player
                                    isShowPlayerProfile = true
                                    
                                    AudioManager.shared.playSoundEffect(filename: data.appConfig.profileButtonTapMusic)
                                } label: {
                                    LeaderboardRowView(player: player)
                                    Divider()
                                }
    //                            .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .background(BlurView(style: .systemMaterialDark))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top, data.appConfig.isIPhone ? 8 : 12)
                        
                        // MARK: Bar chart
                        BarChartView(data: getBadgesBarChartData(forLanguage: data.appConfig.language))
                    }
                    
                }
            }
            .padding()
            .padding(.top)
            .padding(.top)
            .padding(.top)
            .padding(.top)
            .padding(.top, data.appConfig.isIPhone ? 0 : 36)
        }
        .navigationBarHidden(true)
        .withHeader(title: data.appConfig.getLeaderboardView_PageHeader_Text())
        
        // MARK: Navigation
        .navigationDestination(isPresented: $isShowPlayerProfile) {
            if let player = selectedPlayer {
                ProfileView(user: player, isMyself: false)
            }
        }
        
        // MARK: Music
        .onAppear {
            AudioManager.shared.pauseAllMusics()
            AudioManager.shared.stopLeaderboardMusic()
            AudioManager.shared.playLeaderboardMusic(filename: data.appConfig.leaderboardMusic)
        }
    }
    
    func getTopPlayers() -> [User] {
        let players = Array(data.users)
        let sortedPlayers = players.sorted {
            if $0.score == $1.score {
                return $0.name < $1.name // Ascending order for names if scores are equal
            }
            return $0.score > $1.score // Descending order for scores
        }
        return Array(sortedPlayers.prefix(10)) // Return only the top 10 players
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray.opacity(0.1) : Color.clear)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

#Preview {
    LeaderBoardView()
        .environment(ModelData.previewModelData)
}

extension LeaderBoardView {
    func getBadgesBarChartData(forLanguage language: AppLanguage) -> BarChartData {
        let data: BarDataSet =
            BarDataSet(dataPoints:
                Array(badgeToCount(players: getTopPlayers()).map { (badge, count) in
                    return BarChartDataPoint(value: Double(count), 
                                             xAxisLabel: badge.toRepresent(language: language),
                                             description: badge.toRepresent(language: language),
                                             colour: ColourStyle(colour: getRandomColor())
                    )
                }),
                       legendTitle: language == .EN ? "Data" : "Dữ Liệu")

        let metadata = ChartMetadata(title: language == .EN ? "Owned by Top 10" : "Sở Hữu Bởi Top 10", subtitle: language == .EN ? "Badges" : "Huy Hiệu")

        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour: Color(.lightGray).opacity(0.25),
                                   lineWidth: 1)

        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(-90)),
                                       xAxisTitle: language == .EN ? "Badge Types" : "Loại Huy Hiệu",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 5,
                                       yAxisTitle: language == .EN ? "Total Owned" : "Số Lượng Sở Hữu",
                                       baseline: .zero,
                                       topLine: .maximumValue)

        return BarChartData(dataSets: data,
                            metadata: metadata,
                            xAxisLabels: ["One", "Two", "Three"],
                            barStyle: BarStyle(barWidth: 0.5,
                                               cornerRadius: CornerRadius(top: 50, bottom: 0),
                                               colourFrom: .dataPoints,
                                               colour: ColourStyle(colour: .blue)),
                            chartStyle: chartStyle)
    }
    
    func badgeToCount(players: [User]) -> [Badge: Int] {
        var badgeCount = [Badge: Int]()

        for user in players {
            for badge in user.badges {
                badgeCount[badge, default: 0] += 1
            }
        }

        return badgeCount
    }
    
    func getRandomColor() -> Color {
        let colors: [Color] = [.red, .green, .yellow, .orange, .cyan, .brown, .pink, .mint]
        return colors.randomElement()! // Force unwrapping is safe here only if the array is non-empty
    }
}
