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

class King: Piece {
    
    required init(owner: Team, pieceType: PieceType) {
        super.init(owner: owner, pieceType: pieceType)
    }
    
    override var value: Int {
        return 999 // super high value for the king for AI priority
    }
    
    func standardMoveGrid(position: Position, game: Game) -> BoolChessGrid {
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.front?.position].compactMap({
            $0
        }), board: game.board)
        
        let backMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.back?.position].compactMap({
            $0
        }), board: game.board)
        
        let leftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.left?.position].compactMap({
            $0
        }), board: game.board)
        
        let rightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.right?.position].compactMap({
            $0
        }), board: game.board)
        
        let frontLeftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalLeftFront?.position].compactMap({
            $0
        }), board: game.board)
        
        let frontRightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalRightFront?.position].compactMap({
            $0
        }), board: game.board)
        
        let backLeftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalLeftBack?.position].compactMap({
            $0
        }), board: game.board)
        
        let backRightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalRightBack?.position].compactMap({
            $0
        }), board: game.board)
        
        let allMoves = frontMove + backMove + leftMove + rightMove + frontLeftMove + frontRightMove + backLeftMove + backRightMove
        
        return BoolChessGrid(positions: allMoves)
    }
    
    override func threadtenedPositions(position: Position, game: Game) -> BoolChessGrid {
        return standardMoveGrid(position: position, game: game)
    }
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        let standardMoves = standardMoveGrid(position: position, game: game).toMoves(origin: position, board: game.board)
        
        let castleMoves: Set<Move> = {
            let startingPosition = owner == .white ? Position(col: .E, row: .one) : Position(col: .E, row: .eight)
            
            let movesFromStartingPosition = game.history.filter {
                $0.origin == startingPosition
            }
            
            guard position == startingPosition, movesFromStartingPosition.count == 0 else {
                return Set()
            }
            
            let directedPosition = DirectedPosition(position: position, perspective: owner)
            
            let queensideCastle: Move? = {
                let rookPosition = self.owner == .white ? Position(col: .A, row: .one) : Position(col: .A, row: .eight)
                
                let movesFromRookPosition = game.history.filter {
                    $0.origin == rookPosition
                }
                
                guard let _ = game.board[rookPosition] as? Rook, movesFromRookPosition.count == 0
                else {
                    return nil
                }
                
                // only castle if spaces between king and rook are empty
                let spacesThatAreRequiredToBeEmpty = (owner == .white ? directedPosition.leftSpaces : directedPosition.rightSpaces).dropLast()
                    .map{
                        $0.position
                    }
                
                for space in spacesThatAreRequiredToBeEmpty {
                    guard game.board[space] == nil else {
                        return nil
                    }
                }
                
                let spacesThatAreRequiredToBeUnthreatened = spacesThatAreRequiredToBeEmpty.dropLast()
                let positionsThreatenedByOpponent = game.positionsThreatened(team: owner.opponent)
                
                for space in spacesThatAreRequiredToBeUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {
                        return nil
                    }
                }
                
                let destination: Position! = (owner == .white ? directedPosition.left?.left : directedPosition.right?.right)?.position
                
                guard !positionsThreatenedByOpponent[position],
                        !positionsThreatenedByOpponent[destination] else {
                    return nil
                }
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            let kingsideCastle: Move? = {
                let rookPosition = self.owner == .white ? Position(col: .H, row: .one) : Position(col: .H, row: .eight)
                
                let movesFromRookPosition = game.history.filter {
                    $0.origin == rookPosition
                }
                
                guard let _ = game.board[rookPosition] as? Rook, movesFromRookPosition.count == 0
                else {
                    return nil
                }
                
                // only castle if spaces between king and rook are empty
                let spacesThatAreRequiredToBeEmptyAndUnthreatened = (owner == .white ? directedPosition.rightSpaces : directedPosition.leftSpaces).dropLast()
                    .map{
                        $0.position
                    }
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard game.board[space] == nil else {
                        return nil
                    }
                }
                
                let positionsThreatenedByOpponent = game.positionsThreatened(team: owner.opponent)
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {
                        return nil
                    }
                }
                
                let destination: Position! = (owner == .white ? directedPosition.right?.right : directedPosition.left?.left)?.position
                
                guard !positionsThreatenedByOpponent[position],
                        !positionsThreatenedByOpponent[destination] else {
                    return nil
                }
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            return [queensideCastle, kingsideCastle]
                .compactMap {
                    $0
                }
                .toSet()
        }()
        
        return standardMoves.union(castleMoves)
    }
    
    override func fenChar() -> String {
        return self.owner == .white ? "K" : "k"
    }
    
    
    
    // Codable conformance
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

extension King {
    static func _standardMoveGrid(position: Position, game: Game, owner: Team, pieceType: PieceType) -> BoolChessGrid {
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.front?.position].compactMap({
            $0
        }), board: game.board)
        
        let backMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.back?.position].compactMap({
            $0
        }), board: game.board)
        
        let leftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.left?.position].compactMap({
            $0
        }), board: game.board)
        
        let rightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.right?.position].compactMap({
            $0
        }), board: game.board)
        
        let frontLeftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalLeftFront?.position].compactMap({
            $0
        }), board: game.board)
        
        let frontRightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalRightFront?.position].compactMap({
            $0
        }), board: game.board)
        
        let backLeftMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalLeftBack?.position].compactMap({
            $0
        }), board: game.board)
        
        let backRightMove = Position.pathConsideringCollisions(team: owner, path: [directedPosition.diagonalRightBack?.position].compactMap({
            $0
        }), board: game.board)
        
        let allMoves = frontMove + backMove + leftMove + rightMove + frontLeftMove + frontRightMove + backLeftMove + backRightMove
        
        return BoolChessGrid(positions: allMoves)
    }
    
    static  func _threadtenedPositions(position: Position, game: Game, owner: Team, pieceType: PieceType) -> BoolChessGrid {
        return _standardMoveGrid(position: position, game: game, owner: owner, pieceType: pieceType)
    }
    
    static  func _possibleMoves(position: Position, game: Game, owner: Team, pieceType: PieceType) -> Set<Move> {
        let standardMoves = _standardMoveGrid(position: position, game: game, owner: owner, pieceType: pieceType).toMoves(origin: position, board: game.board)
        
        let castleMoves: Set<Move> = {
            let startingPosition = owner == .white ? Position(col: .E, row: .one) : Position(col: .E, row: .eight)
            
            let movesFromStartingPosition = game.history.filter {
                $0.origin == startingPosition
            }
            
            guard position == startingPosition, movesFromStartingPosition.count == 0 else {
                return Set()
            }
            
            let directedPosition = DirectedPosition(position: position, perspective: owner)
            
            let queensideCastle: Move? = {
                let rookPosition = owner == .white ? Position(col: .A, row: .one) : Position(col: .A, row: .eight)
                
                let movesFromRookPosition = game.history.filter {
                    $0.origin == rookPosition
                }
                
                guard let _ = game.board[rookPosition] as? Rook, movesFromRookPosition.count == 0
                else {
                    return nil
                }
                
                // only castle if spaces between king and rook are empty
                let spacesThatAreRequiredToBeEmpty = (owner == .white ? directedPosition.leftSpaces : directedPosition.rightSpaces).dropLast()
                    .map{
                        $0.position
                    }
                
                for space in spacesThatAreRequiredToBeEmpty {
                    guard game.board[space] == nil else {
                        return nil
                    }
                }
                
                let spacesThatAreRequiredToBeUnthreatened = spacesThatAreRequiredToBeEmpty.dropLast()
                let positionsThreatenedByOpponent = game.positionsThreatened(team: owner.opponent)
                
                for space in spacesThatAreRequiredToBeUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {
                        return nil
                    }
                }
                
                let destination: Position! = (owner == .white ? directedPosition.left?.left : directedPosition.right?.right)?.position
                
                guard !positionsThreatenedByOpponent[position],
                        !positionsThreatenedByOpponent[destination] else {
                    return nil
                }
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            let kingsideCastle: Move? = {
                let rookPosition = owner == .white ? Position(col: .H, row: .one) : Position(col: .H, row: .eight)
                
                let movesFromRookPosition = game.history.filter {
                    $0.origin == rookPosition
                }
                
                guard let _ = game.board[rookPosition] as? Rook, movesFromRookPosition.count == 0
                else {
                    return nil
                }
                
                // only castle if spaces between king and rook are empty
                let spacesThatAreRequiredToBeEmptyAndUnthreatened = (owner == .white ? directedPosition.rightSpaces : directedPosition.leftSpaces).dropLast()
                    .map{
                        $0.position
                    }
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard game.board[space] == nil else {
                        return nil
                    }
                }
                
                let positionsThreatenedByOpponent = game.positionsThreatened(team: owner.opponent)
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {
                        return nil
                    }
                }
                
                let destination: Position! = (owner == .white ? directedPosition.right?.right : directedPosition.left?.left)?.position
                
                guard !positionsThreatenedByOpponent[position],
                        !positionsThreatenedByOpponent[destination] else {
                    return nil
                }
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            return [queensideCastle, kingsideCastle]
                .compactMap {
                    $0
                }
                .toSet()
        }()
        
        return standardMoves.union(castleMoves)
    }
}
