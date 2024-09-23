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
import Foundation

enum Team: Codable {
    case white
    case black
    
    var opponent: Team {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
    
    var color: Color {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}

extension Team : CustomStringConvertible {
    var description: String {
        switch self {
        case .white:
            return "white"
        case .black:
            return "black"
        }
    }
    
    func descriptionInLanguage(language: AppLanguage) -> String {
        switch language {
        case .EN:
            switch self {
            case .white:
                return "white 🍎"
            case .black:
                return "black 🍊"
            }
        case .VN:
            switch self {
            case .white:
                return "trắng 🍎"
            case .black:
                return "đen 🍊"
            }
        }
    }
}

protocol BoardPlayer {
    var name: String { get set }
    var wins: Int { get set } // number of win games
}

protocol ArtificialIntelligence: BoardPlayer {
    
    // any AI agent must implement this func
    func nextMove(game: Game) -> Move
}

protocol Human: BoardPlayer {
    
}

enum Player {
    case human(Human)
    case AI(ArtificialIntelligence)
    
    static func getAIPlayerFromDifficulty(difficulty: AIDifficulty) -> Player {
        switch difficulty {
        case .easy:
            return .AI(Michael())
        case .medium:
            return .AI(Alex())
        case .hard:
            return .AI(TomHuynh())
        }
    }
    
    static func getDifficultyFromAIName(name: String) -> AIDifficulty {
        switch name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "Michael the dumb AI".lowercased():
            return .easy
        case "Alex the clever AI".lowercased():
            return .medium
        case "TomHuynh super AI".lowercased():
            return .hard
        default:
            return .easy
        }
    }
    
    static func getAIPlayerFromName(name: String) -> Player? {
        switch name.lowercased() {
        case Michael().name.lowercased():
            return .AI(Michael())
        case Alex().name.lowercased():
            return .AI(Alex())
        case TomHuynh().name.lowercased():
            return .AI(TomHuynh())
        default:
            return nil  // No AI found with that name
        }
    }
    
    var name: String {
        switch self {
        case .human(let human):
            return human.name
        case .AI(let ai):
            return ai.name
        }
    }
    
    // Property to check if the player is human
    var isHuman: Bool {
        switch self {
        case .human(_):
            return true
        case .AI(_):
            return false
        }
    }

    // Property to check if the player is AI
    var isAI: Bool {
        !isHuman
    }
}

extension Player: CustomStringConvertible {
    var description: String {
        switch self {
        case .human(let human ):
            return human.name
        case .AI(let artificialIntelligence):
            return artificialIntelligence.name
        }
    }
}

// Rank
enum Col: Int, Codable {
    case A = 1
    case B
    case C
    case D
    case E
    case F
    case G
    case H
    
    var fenCharacter: String {
        switch self {
        case .A: return "a"
        case .B: return "b"
        case .C: return "c"
        case .D: return "d"
        case .E: return "e"
        case .F: return "f"
        case .G: return "g"
        case .H: return "h"
        }
    }
}

// File
enum Row: Int, Codable {
    case one = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case end = -1
    
    var fenCharacter: String {
        return String(self.rawValue)
    }
}

extension IndexPath {
    init(row: Int, column: Int) {
        self.init(indexes: [column, row])
    }
    
    var row: Int {
        return self[1]
    }
    
    var column: Int {
        return self[0]
    }
}

struct Roster {
    let whitePlayer: Player
    let blackPlayer: Player
    
    init(whitePlayer: Player, blackPlayer: Player) {
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
    }
    
    subscript(team: Team) -> Player {
        switch team {
        case .white:
            return whitePlayer
        case .black:
            return blackPlayer
        }
    }
}

enum Kind: Hashable, Codable {
    case standard
    case castle
    case enPassant
    case needsPromotion
    case promotion(Piece)
}

extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        return Set(self)
    }
}
