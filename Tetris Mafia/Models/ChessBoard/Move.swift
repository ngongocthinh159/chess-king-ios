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

struct Move: Hashable, Codable {
    let origin: Position
    let destination: Position
    let capturedPiece: Piece?
    let kind: Kind
    
    init(origin: Position, destination: Position, capturedPiece: Piece?, kind: Kind = .standard) {
        self.origin = origin
        self.destination = destination
        self.capturedPiece = capturedPiece
        self.kind = kind
    }
    
    func isCaptureOrPawnMove(in game: Game) -> Bool {
        // Check if a piece is captured
        if capturedPiece != nil {
            return true
        }
        
        // Check if the piece at the origin is a pawn
        if let pieceAtOrigin = game.board[destination], pieceAtOrigin is Pawn {
            return true
        }
        
        return false
    }
}

extension Move: CustomStringConvertible {
    var description: String {
        switch kind {
        case .standard:
            return "\(origin) -> \(destination)"
        case .castle:
            return "\(origin) -> \(destination) Castle"
        case .enPassant:
            return "\(origin) -> \(destination) En Passant"
        case .needsPromotion:
            return "\(origin) -> \(destination) Needs Promotion"
        case .promotion(_):
            return "\(origin) -> \(destination) Promotion"
        }
    }
}
