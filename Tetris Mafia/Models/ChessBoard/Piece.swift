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

enum PieceType: String, Codable {
    case rook = "rook"
    case queen = "queen"
    case bishop = "bishop"
    case knight = "knight"
    case king = "king"
    case pawn = "pawn"
    case general = "general"
}

class Piece: Codable {
    var owner: Team
    var pieceType: PieceType
    
    required init(owner: Team, pieceType: PieceType) {
        self.owner = owner
        self.pieceType = pieceType
    }
    
    // important score of a piece. The king will have the highest score
    var value: Int {
        return 0
    }
    
//    func image(themeName: String) -> Image {
//        let color = owner.description
//        let piece = String(describing: type(of: self)).lowercased()
//        return Image("\(piece)-\(color)-\(themeName)", bundle: Bundle(for: type(of: self)))
//    }
    
    // MARK: - Possible moves
    func possibleMoves(position: Position, game: Game) -> Set<Move> {
//        fatalError("This function must be overriden in the subclass")
        switch self.pieceType {
        case .rook:
            Rook._possibleMoves(position: position, game: game, owner: owner, pieceType: pieceType)
        case .queen:
            Queen ._possibleMoves(position: position, game: game, owner: owner, pieceType: pieceType)
        case .bishop:
            Bishop ._possibleMoves(position: position, game: game, owner: owner, pieceType: pieceType)
        case .knight:
            Knight ._possibleMoves(position: position, game: game, owner: owner, pieceType: pieceType)
        case .king:
            King ._possibleMoves(position: position, game: game, owner: owner, pieceType: pieceType)
        case .pawn:
            Pawn ._possibleMoves(position: position, game: game, owner: owner, pieceType: pieceType)
        case .general:
            fatalError("This function must be overriden in the subclass")
        }
    }
    
    // MARK: - Threatened positions
    func threadtenedPositions(position: Position, game: Game) -> BoolChessGrid {
//        fatalError("This function must be overriden in the subclass")
        switch self.pieceType {
        case .rook:
            Rook._threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType)
        case .queen:
            Queen ._threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType)
        case .bishop:
            Bishop._threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType)
        case .knight:
            Knight ._threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType)
        case .king:
            King ._threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType)
        case .pawn:
            Pawn ._threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType)
        case .general:
            fatalError("This function must be overriden in the subclass")
        }
    }
    
    func fenChar() -> String {
        switch self.pieceType {
        case .rook:
            owner == .white ? "R" : "r"
        case .queen:
            owner == .white ? "Q" : "q"
        case .bishop:
            owner == .white ? "B" : "b"
        case .knight:
            owner == .white ? "N" : "n"
        case .king:
            owner == .white ? "K" : "k"
        case .pawn:
            owner == .white ? "P" : "p"
        case .general:
            fatalError("This function must be overriden in the subclass")
        }
//        fatalError("This function must be overriden in the subclass")
    }
    
    
    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        owner = try container.decode(Team.self, forKey: .owner)
        pieceType = try container.decode(PieceType.self, forKey: .pieceType)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(owner, forKey: .owner)
        try container.encode(pieceType.rawValue, forKey: .pieceType)
    }

    private enum CodingKeys: String, CodingKey {
        case owner, pieceType
    }
}

extension Piece: Equatable {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        guard lhs.owner == rhs.owner && type(of: lhs) == type(of: rhs) else {
            return false
        }
        return true
    }
}

extension Piece: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(owner)
        hasher.combine(String(describing: type(of: self)))
    }
}

