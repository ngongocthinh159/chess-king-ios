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

class Bishop: Piece {
    
    required init(owner: Team, pieceType: PieceType) {
        super.init(owner: owner, pieceType: pieceType)
    }
    
    override var value: Int {
        return 4
    }
    
    override func threadtenedPositions(position: Position, game: Game) -> BoolChessGrid {
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontLeftMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalLeftFrontSpaces.map({
                $0.position
            }), board: game.board)
        
        let frontRightMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalRightFrontSpaces.map({
                $0.position
            }), board: game.board)
        
        let backLeftMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalLeftBackSpaces.map({
                $0.position
            }), board: game.board)
        
        let backRightMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalRightBackSpaces.map({
                $0.position
            }), board: game.board)
        
        let allMoves = frontLeftMoves + frontRightMoves + backLeftMoves + backRightMoves
        
        return BoolChessGrid(positions: allMoves)
    }
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        return threadtenedPositions(position: position, game: game).toMoves(origin: position, board: game.board)
    }
    
    override func fenChar() -> String {
        return self.owner == .white ? "B" : "b"
    }
    
    
    
    // Codable conformance
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

extension Bishop {
    static func _threadtenedPositions(position: Position, game: Game, owner: Team, pieceType: PieceType ) -> BoolChessGrid {
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontLeftMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalLeftFrontSpaces.map({
                $0.position
            }), board: game.board)
        
        let frontRightMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalRightFrontSpaces.map({
                $0.position
            }), board: game.board)
        
        let backLeftMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalLeftBackSpaces.map({
                $0.position
            }), board: game.board)
        
        let backRightMoves = Position
            .pathConsideringCollisions(team: owner, path: directedPosition.diagonalRightBackSpaces.map({
                $0.position
            }), board: game.board)
        
        let allMoves = frontLeftMoves + frontRightMoves + backLeftMoves + backRightMoves
        
        return BoolChessGrid(positions: allMoves)
    }
    
    static func _possibleMoves(position: Position, game: Game, owner: Team, pieceType: PieceType ) -> Set<Move> {
        return _threadtenedPositions(position: position, game: game, owner: owner, pieceType: pieceType ).toMoves(origin: position, board: game.board)
    }
}


