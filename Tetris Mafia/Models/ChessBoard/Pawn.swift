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

class Pawn: Piece {
    
    required init(owner: Team, pieceType: PieceType) {
        super.init(owner: owner, pieceType: pieceType)
    }
    
    override var value: Int {
        return 1
    }
    
    static let doubleMovesAllowedPositionsWhitePawns = DirectedPosition(position: Position(col: .A, row: .two), perspective: .white).rightSpaces.map { 
            $0.position
        } + [Position(col: .A, row: .two)]
    
    static let doubleMovesAllowedPositionsBlackPawns = DirectedPosition(position: Position(col: .A, row: .seven), perspective: .black).leftSpaces.map {
            $0.position
        } + [Position(col: .A, row: .seven)]
    
    static let promotionRequiredPositionsForWhitePawns = DirectedPosition(position: Position(col: .A, row: .eight), perspective: .white).rightSpaces.map {
        $0.position
    } + [Position(col: .A, row: .eight)]
    
    static let promotionRequiredPositionsForBlackPawns = DirectedPosition(position: Position(col: .A, row: .one), perspective: .black).leftSpaces.map {
        $0.position
    } + [Position(col: .A, row: .one)]
    
    override func possibleMoves(position: Position, game: Game) -> Set<Move> {
        let directedPosition = position.fromPerspective(team: owner)
        
        let frontMove: Position? = {
            guard let space = directedPosition.front?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return space
                
            case .some(_):
                return nil
            }
        }()
        
        let frontLeftMove: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return nil
                
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightMove: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return nil
                
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let allMovePositions = [frontMove, frontLeftMove, frontRightMove]
            .compactMap({
                $0
            })
        
        let normalMoves: [Move] = allMovePositions.map { destination in
            if (owner == .white ? Pawn.promotionRequiredPositionsForWhitePawns : Pawn.promotionRequiredPositionsForBlackPawns).contains(destination) {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination], kind: .needsPromotion)
            } else {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination])
            }
        }
        
        let doubleMove = { () -> Move? in
            switch self.owner {
            case .white:
                guard Pawn.doubleMovesAllowedPositionsWhitePawns.contains(position) else {
                    return nil
                }
                
            case .black:
                guard Pawn.doubleMovesAllowedPositionsBlackPawns.contains(position) else {
                    return nil
                }
            }
            
            guard let front = directedPosition.front?.position, game.board[front] == nil else {
                return nil
            }
            
            guard let doubleMoveDestination = directedPosition.front?.front?.position, game.board[doubleMoveDestination] == nil else {
                return nil
            }
            
            return Move(origin: position, destination: doubleMoveDestination, capturedPiece: game.board[doubleMoveDestination])
        }()
        
        let enPassantMove = { () -> Move? in
            guard let lastMove = game.history.last, let piece = game.board[lastMove.destination], let pawn = piece as? Pawn else {
                return nil
            }
            
            assert(pawn.owner == game.turn.opponent)
            
            switch game.turn {
            case .white:
                guard Pawn.doubleMovesAllowedPositionsBlackPawns.contains(lastMove.origin), abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2 else {
                    return nil
                }
                
            case .black:
                guard Pawn.doubleMovesAllowedPositionsWhitePawns.contains(lastMove.origin), abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2 else {
                    return nil
                }
            }
            
            guard lastMove.destination != directedPosition.left?.position else {
                return Move(origin: position, destination: directedPosition.diagonalLeftFront!.position, capturedPiece: game.board[lastMove.destination], kind: .enPassant)
            }
            
            guard lastMove.destination != directedPosition.right?.position else {
                return Move(origin: position, destination: directedPosition.diagonalRightFront!.position, capturedPiece: game.board[lastMove.destination], kind: .enPassant)
            }
            
            return nil
        }()
        
        return Set(normalMoves + [doubleMove, enPassantMove].compactMap({
            $0
        }))
    }
    
    override func threadtenedPositions(position: Position, game: Game) -> BoolChessGrid {
        let directedPosition = position.fromPerspective(team: owner)
        
        let frontLeftThreat: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {
                return nil
            }
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightThreat: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {
                return nil
            }
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        return BoolChessGrid(positions: [frontLeftThreat, frontRightThreat].compactMap({
            $0
        }))
    }
    
    override func fenChar() -> String {
        return self.owner == .white ? "P" : "p"
    }
    
    
    
    // Codable conformance
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}


extension Pawn {
    static func _possibleMoves(position: Position, game: Game, owner: Team, pieceType: PieceType) -> Set<Move> {
        let directedPosition = position.fromPerspective(team: owner)
        
        let frontMove: Position? = {
            guard let space = directedPosition.front?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return space
                
            case .some(_):
                return nil
            }
        }()
        
        let frontLeftMove: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return nil
                
            case .some(let collidingPiece):
                if collidingPiece.owner == owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightMove: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {
                return nil
            }
            
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return nil
                
            case .some(let collidingPiece):
                if collidingPiece.owner == owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let allMovePositions = [frontMove, frontLeftMove, frontRightMove]
            .compactMap({
                $0
            })
        
        let normalMoves: [Move] = allMovePositions.map { destination in
            if (owner == .white ? Pawn.promotionRequiredPositionsForWhitePawns : Pawn.promotionRequiredPositionsForBlackPawns).contains(destination) {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination], kind: .needsPromotion)
            } else {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination])
            }
        }
        
        let doubleMove = { () -> Move? in
            switch owner {
            case .white:
                guard Pawn.doubleMovesAllowedPositionsWhitePawns.contains(position) else {
                    return nil
                }
                
            case .black:
                guard Pawn.doubleMovesAllowedPositionsBlackPawns.contains(position) else {
                    return nil
                }
            }
            
            guard let front = directedPosition.front?.position, game.board[front] == nil else {
                return nil
            }
            
            guard let doubleMoveDestination = directedPosition.front?.front?.position, game.board[doubleMoveDestination] == nil else {
                return nil
            }
            
            return Move(origin: position, destination: doubleMoveDestination, capturedPiece: game.board[doubleMoveDestination])
        }()
        
        let enPassantMove = { () -> Move? in
            guard let lastMove = game.history.last, let piece = game.board[lastMove.destination], let pawn = piece as? Pawn else {
                return nil
            }
            
            assert(pawn.owner == game.turn.opponent)
            
            switch game.turn {
            case .white:
                guard Pawn.doubleMovesAllowedPositionsBlackPawns.contains(lastMove.origin), abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2 else {
                    return nil
                }
                
            case .black:
                guard Pawn.doubleMovesAllowedPositionsWhitePawns.contains(lastMove.origin), abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2 else {
                    return nil
                }
            }
            
            guard lastMove.destination != directedPosition.left?.position else {
                return Move(origin: position, destination: directedPosition.diagonalLeftFront!.position, capturedPiece: game.board[lastMove.destination], kind: .enPassant)
            }
            
            guard lastMove.destination != directedPosition.right?.position else {
                return Move(origin: position, destination: directedPosition.diagonalRightFront!.position, capturedPiece: game.board[lastMove.destination], kind: .enPassant)
            }
            
            return nil
        }()
        
        return Set(normalMoves + [doubleMove, enPassantMove].compactMap({
            $0
        }))
    }
    
    static func _threadtenedPositions(position: Position, game: Game, owner: Team, pieceType: PieceType) -> BoolChessGrid {
        let directedPosition = position.fromPerspective(team: owner)
        
        let frontLeftThreat: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {
                return nil
            }
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightThreat: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {
                return nil
            }
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        return BoolChessGrid(positions: [frontLeftThreat, frontRightThreat].compactMap({
            $0
        }))
    }
}
