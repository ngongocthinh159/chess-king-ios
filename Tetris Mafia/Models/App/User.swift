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
import SwiftUICharts
import Combine

enum Avatar: String, CaseIterable, Hashable, Equatable, Codable {
    case dog
    case cat
    case mouse
    
    static var allCases: [Avatar] {
       return [.dog, .cat, .mouse] // Exclude .adhoc
   }
    
    func toImage() -> Image {
        switch self {
        case .dog:
            return Image("ava-dog")
        case .cat:
            return Image("ava-cat")
        case .mouse:
            return Image("ava-mouse")
        }
    }
    
    func toImageString() -> String {
        switch self {
        case .dog:
            return "ava-dog"
        case .cat:
            return "ava-cat"
        case .mouse:
            return "ava-mouse"
        }
    }
    
    static func random() -> Avatar {
        return Avatar.allCases.randomElement() ?? .dog // Providing a default to handle the optional
    }
}

enum PlayerType: String, Codable {
    case human
    case ai
}

struct GameState: Codable {
    var game: Game 
    var whitePlayer: String 
    var blackPlayer: String 
    var selection: GameViewModel.Selection?
    var vsAI: Bool
}

enum Badge: String, Codable, CaseIterable {
    case firstPlay = "firstPlay"
    case win10 = "win10"
    
    case promotionExpert = "promotionExpert"
    case enpassantExpert = "enpassantExpert"
    case castlingExpert = "castlingExpert"
    
    case beatEasyAI = "beatEasyAI"
    case beatMediumAI = "beatMediumAI"
    case beatHardAI = "beatHardAI"
    
    var name: String {
        switch self {
        case .firstPlay:
            return "Welcome first game"  // A warm welcome to new players.
        case .win10:
            return "Seasoned Player"  // Indicates a significant level of skill.
            
        case .promotionExpert:
            return "Strategist Savant"
        case .enpassantExpert:
            return "En Passant Tactician"
        case .castlingExpert:
            return "Castle Commander"
            
        case .beatEasyAI:
            return "AI Beginner Beater"  // Acknowledges overcoming the first level of AI.
        case .beatMediumAI:
            return "AI Challenger"  // Notes the medium difficulty conquest.
        case .beatHardAI:
            return "AI Conqueror"  // Celebrates defeating the highest AI difficulty.
        }
    }
    
    var imageName: String  {
        return "badge-\(self)"
    }
    
    static func previews() -> [Badge] {
        return [
            .firstPlay,
            .beatHardAI,
            .enpassantExpert
        ]
    }
    
    
    func toRepresent(language: AppLanguage) -> String {
        switch language {
        case .EN:
            return self.name
            
        case .VN:
            switch self {
            case .firstPlay:
                return "Chào Mừng Bạn Mới"  // A warm welcome to new players.
            case .win10:
                return "Người Chơi Điêu Luyện"  // Indicates a significant level of skill.
                
            case .promotionExpert:
                return "Phong Cấp Thiên Tài"
            case .enpassantExpert:
                return "Chiến Thuật Gia En Passant"
            case .castlingExpert:
                return "Chỉ Huy Lâu Đài"
                
            case .beatEasyAI:
                return "Chiến Binh AI"  // Acknowledges overcoming the first level of AI.
            case .beatMediumAI:
                return "Người Thử Thách AI"  // Notes the medium difficulty conquest.
            case .beatHardAI:
                return "Người Chinh Phục AI"  // Celebrates defeating the highest AI difficulty.
            }
        }
    }
    
    static func randomBadges(maxCnt: Int) -> [Badge] {
        var badges: [Badge] = [.firstPlay] // Start with the firstPlay badge as it's guaranteed
        let otherBadges = Badge.allCases.filter { $0 != .firstPlay }
        
        let additionalBadgeCount = Int.random(in: 0...maxCnt - 1)
        
        // Shuffle the other badges and append the required number to the badges array
        let shuffledBadges = otherBadges.shuffled()
        badges.append(contentsOf: shuffledBadges.prefix(additionalBadgeCount))
        
        return badges
    }
}

struct UserStats {
    var totalWins: Int
    var totalPlay: Int
    var totalEnpassants: Int
    var totalPromotions: Int
    var totalCastlings: Int
    var winRate: Double
}

struct ScoreHistoryEntry: Codable {
    var score: Int
    var time: Date
}

class User: Codable, Identifiable {
    var id: UUID
    var name: String
    var type: PlayerType
    var avatar: Avatar
    var totalWins: Int
    var totalPlay: Int
    var totalEnpassants: Int
    var totalPromotions: Int
    var totalCastlings: Int
    var lastLogin: Date
    var playedGames: [Game]
    var lastGameState: GameState?
    var badges: [Badge]
    var score: Int
    var scoreHistory: [ScoreHistoryEntry]
    
    var avatarImage: Image  {
        if self.type == .ai {
            return Image("ava-ai-\(name)")
        }
        return avatar.toImage()
    }
    
    var avatarStr: String {
        if self.type == .ai {
            return "ava-ai-\(name)"
        }
        return avatar.toImageString()
    }
    
    var formattedLastLogin: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: lastLogin)
    }
    
    init(name: String, avatar: Avatar) {
        self.id = UUID()
        self.name = name
        self.type = .human
        self.avatar = avatar
        self.totalPlay = 0
        self.totalWins = 0
        self.totalEnpassants = 0
        self.totalCastlings = 0
        self.totalPromotions = 0
        self.lastLogin = Date.now
        self.playedGames = []
        self.lastGameState = nil 
        self.badges = []
        self.score = 0
        self.scoreHistory = []
    }
    
    init(name: String, avatar: Avatar, badges: [Badge]) {
        self.id = UUID()
        self.name = name
        self.type = .human
        self.avatar = avatar
        self.totalPlay = 0
        self.totalWins = 0
        self.totalEnpassants = 0
        self.totalCastlings = 0
        self.totalPromotions = 0
        self.lastLogin = Date.now
        self.playedGames = []
        self.lastGameState = nil
        self.badges = badges
        self.score = 0
        self.scoreHistory = []
    }
    
    init(name: String, 
         type: PlayerType,
         avatar: Avatar, 
         totalPlay: Int,
         totalWins: Int,
         lastLogin: Date,
         badges: [Badge ],
         totalEnpassants: Int,
         totalCastlings: Int,
         totalPromotions: Int,
         score: Int,
         scoreHistory: [ScoreHistoryEntry]) {
        self.id = UUID()
        self.name = name
        self.type = type 
        self.avatar = avatar
        self.totalPlay = totalPlay
        self.totalWins = totalWins
        self.totalEnpassants = totalEnpassants
        self.totalCastlings = totalCastlings
        self.totalPromotions = totalPromotions
        self.lastLogin = lastLogin
        self.playedGames = []
        self.lastGameState = nil 
        self.badges = badges
        self.score = score
        self.scoreHistory = scoreHistory
    }
    
    init(name: String,
         type: PlayerType,
         avatar: Avatar,
         totalPlay: Int,
         totalWins: Int,
         totalEnpassants: Int,
         totalCastlings: Int,
         totalPromotions: Int,
         lastLogin: Date,
         playedGames: [Game],
         lastGameState: GameState?,
         badges: [Badge ],
         score: Int,
         scoreHistory: [ScoreHistoryEntry]) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.avatar = avatar
        self.totalPlay = totalPlay
        self.totalWins = totalWins
        self.totalEnpassants = totalEnpassants
        self.totalCastlings = totalCastlings
        self.totalPromotions = totalPromotions
        self.lastLogin = lastLogin
        self.playedGames = playedGames
        self.lastGameState = lastGameState
        self.badges = badges
        self.score = score
        self.scoreHistory = scoreHistory
    }
    
    
    init(name: String, avatar: Avatar, type: PlayerType) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.avatar = avatar
        self.totalPlay = 0
        self.totalWins = 0
        self.totalEnpassants = 0
        self.totalCastlings = 0
        self.totalPromotions = 0
        self.lastLogin = Date.now
        self.playedGames = []
        self.lastGameState = nil
        self.badges = []
        self.score = 0
        self.scoreHistory = []
    }
    
    func getStats() -> UserStats {
        return UserStats(totalWins: self.totalWins,
                         totalPlay: self.totalPlay,
                         totalEnpassants: self.totalEnpassants,
                         totalPromotions: self.totalPromotions,
                         totalCastlings: self.totalCastlings,
                         winRate: self.calWinRate()
        )
    }
    
    func calWinRate() -> Double {
        if self.totalPlay > 0 {
            return Double(totalWins) / Double(totalPlay) * 100.0
        } else {
            return 100.0
        }
    }
}

extension User {
    func getUserScoresLineChartData(language: AppLanguage) -> LineChartData {
        let displayedScores = self.scoreHistory
                                    .sorted(by: { $0.time > $1.time })
                                    .prefix(5)
                                    .reversed() // get most five recently scores
        
        let data = LineDataSet(dataPoints: displayedScores.map{
            return LineChartDataPoint(value: Double($0.score), xAxisLabel: xAxisDateFormatter(date: $0.time), description: language == .EN ? "Scores" : "Điểm")
        },
        legendTitle: language == .EN ? "Score Changes Over Time" : "Điểm Thay Đổi Theo Thời Gian",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxContentAlignment: .vertical,
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                        xAxisTitle          : language == .EN ? "Time" : "Thời Gian",
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 7,
                                        
                                        baseline            : .minimumWithMaximum(of: -100),
                                        topLine             : .maximum(of: 2600),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
        
        
        
        let chartData = LineChartData(dataSets       : data,
                                      metadata       : ChartMetadata(title: "", subtitle: ""),
                                      chartStyle     : chartStyle)
        
        defer {
            chartData.touchedDataPointPublisher
                .map(\.value)
                .sink { value in
                    var dotStyle: DotStyle
                    if value < 500 {
                        dotStyle = DotStyle(fillColour: .green)
                    } else if value >= 500 && value <= 1500 {
                        dotStyle = DotStyle(fillColour: .blue)
                    } else {
                        dotStyle = DotStyle(fillColour: .red)
                    }
                    withAnimation(.linear(duration: 0.5)) {
                        chartData.chartStyle.markerType = .vertical(attachment: .line(dot: .style(dotStyle)))
                    }
                }
                .store(in: &chartData.subscription)
        }
        
        return chartData
    }
    
    private func xAxisDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

extension User {
    static func generateMockUsers(count: Int) -> [User] {
        let names = Array(Set(generateUniqueNames(count: count)))
        
        var humanUsers: [User] = []
        var aiUsers: [User] = []
        
        for i in 1...min(count, names.count) {
            humanUsers.append(generateMockUser(name: names[i - 1], type: .human))
        }
        
        aiUsers.append(generateMockUser(name: "Michael the dumb AI", type: .ai))
        aiUsers.append(generateMockUser(name: "Alex the clever AI", type: .ai))
        aiUsers.append(generateMockUser(name: "TomHuynh super AI", type: .ai))
        
        return humanUsers + aiUsers
    }
    
    static func generateMockUser(name: String, type: PlayerType) -> User {
        let type: PlayerType = type
        let avatar = Avatar.random()
        let totalPlay = Int.random(in: 1...6)
        let totalWins = Int.random(in: 0...totalPlay)
        let totalEnpassants = Int.random(in: 0...totalPlay/2)
        let totalCastlings = Int.random(in: 0...totalPlay/2)
        let totalPromotions = Int.random(in: 0...totalPlay/2)
        let lastLogin = Date.now
//        let playedGame: Game = []
        let lastGameState: GameState? = nil
        let badges = Badge.randomBadges(maxCnt: 3)
        let (scoreHistory, score) = generateMockUserScoreHistory(totalPlays: totalPlay, totalWins: totalWins)
        
        return User(
            name: name,
            type: type,
            avatar: avatar,
            totalPlay: totalPlay,
            totalWins: totalWins,
            totalEnpassants: totalEnpassants,
            totalCastlings: totalCastlings,
            totalPromotions: totalPromotions,
            lastLogin: lastLogin,
            playedGames: [],
            lastGameState: lastGameState,
            badges: badges,
            score: score,
            scoreHistory: scoreHistory
        )
    }
    
    
    static func generateUniqueNames(count: Int) -> [String] {
        let firstNames = ["Alice", "Bob", "Charlie", "Diana", "Ethan", "Fiona", "George", "Hannah"]
        let lastNames = ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson"]
        
        var uniqueNames = Set<String>()
        var attemptCounter = 0
        
        while uniqueNames.count < count && attemptCounter < 1000 {
            let firstName = firstNames.randomElement()!
            let lastName = lastNames.randomElement()!
            let fullName = "\(firstName) \(lastName) \(uniqueNames.count)"
            
            uniqueNames.insert(fullName)
            attemptCounter += 1
        }
        
        if uniqueNames.count < count {
            print("Warning: Unable to generate the requested number of unique names within the attempt limit.")
        }
        
        return Array(uniqueNames)
    }
    
    static func generateMockUserScoreHistory(totalPlays: Int, totalWins: Int) -> ([ScoreHistoryEntry], Int) {
        var scoreHistory: [ScoreHistoryEntry] = []
        var currentScore = 0
        
        let calendar = Calendar.current
        let currentDate = Date()
        var curWin = 1
        
        for _ in 0..<totalPlays + 1 {
            let gameResult = Int.random(in: 1...4)  // 1: win, 2: defeat easy AI, 3: defeat medium AI, 4: defeat hard AI
            
            var gameScoreChange: Int
            switch gameResult {
            case 1:
                gameScoreChange = GameRule.winScore
            case 2:
                gameScoreChange = GameRule.winScore + (curWin <=  totalWins ? GameRule.defeatEasyAIScore : 0)
            case 3:
                gameScoreChange = GameRule.winScore + (curWin <=  totalWins ? GameRule.defeatMediumAIScore : 0)
            case 4:
                gameScoreChange = GameRule.winScore + (curWin <=  totalWins ? GameRule.defeatHardAIScore : 0)
            default:
                gameScoreChange = 0  // Should never happen, just for safety
            }
            
            if curWin > totalWins {
                gameScoreChange = -gameScoreChange
            }
            
            currentScore += gameScoreChange  // Update cumulative score
            if currentScore < 0 {
                currentScore = 0 // Guard for negative score
            }
            
            let daysBack = Int.random(in: 1...60)
            guard let randomDate = calendar.date(byAdding: .day, value: -daysBack, to: currentDate) else { continue }
            
            let scoreEntry = ScoreHistoryEntry(score: currentScore, time: randomDate)
            scoreHistory.append(scoreEntry)
            
            curWin += 1
        }
        
        // Sort scoreHistory by date from oldest to newest
        scoreHistory.sort { $0.time < $1.time }
        
        return (scoreHistory, currentScore)
    }
}
