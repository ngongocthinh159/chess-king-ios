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

struct Game: Equatable, Codable {
    let board: Board
    let history: [Move]
    let turn: Team
    
    static let standard = Game(board: .standard)
    static let validator = CheckHandler()
    
    init(board: Board) {
        self = Game(board: board, history: [], turn: .white)
    }
    
    init(board: Board, history: [Move] = [], turn: Team = .white) {
        self.board = board
        self.history = history
        self.turn = turn
    }
    
    func performing(_ move: Move) -> Game {
        var newBoard = board
        var newHistory = history
        let newTurn = turn.opponent
        
        let pieceToMove = board[move.origin]!
        newBoard[move.origin] = nil
        newBoard[move.destination] = pieceToMove
        
        switch move.kind {
        case .standard, .needsPromotion:
            break
            
        case .enPassant:
            let capturedPosition = DirectedPosition(position: move.destination, perspective: turn).back!.position
            
            newBoard[capturedPosition] = nil
            
        case .castle:
            let isKingsideCastle = move.origin.col.rawValue < move.destination.col.rawValue
            let newRookCol = Col(rawValue: isKingsideCastle ? move.destination.col.rawValue - 1 : move.destination.col.rawValue + 1)!
            let rookDestination = Position(col: newRookCol, row: move.destination.row)
            let rookOrigin = Position(col: isKingsideCastle ? .H : .A, row: pieceToMove.owner == .white ? .one : .eight)
            
            assert(newBoard[rookOrigin] is Rook)
            let rook = board[rookOrigin]!
            newBoard[rookOrigin] = nil
            newBoard[rookDestination] = rook
            
        case .promotion(let promotionPiece):
            newBoard[move.destination] = promotionPiece
        }
        
        newHistory.append(move)
        
        return Game(board: newBoard, history: newHistory, turn: newTurn)
    }
    
    func reversingLastMove() -> Game {
        var newBoard = board
        var newHistory = history
        let newTurn = turn.opponent
        
        guard let move = newHistory.popLast() else {
            return self
        }
        
        switch move.kind {
        case .standard, .needsPromotion:
            let pieceToReverse = newBoard[move.destination]!
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = move.capturedPiece
            
        case .castle:
            let pieceToReverse = newBoard[move.destination]!
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = nil
            
            let isKingsideCastle = move.origin.col.rawValue < move.destination.col.rawValue
            let rookToReverseCol = Col(rawValue: isKingsideCastle ? move.destination.col.rawValue - 1 : move.destination.col.rawValue + 1)!
            let rookCurrentPosition = Position(col: rookToReverseCol, row: move.destination.row)
            let rookDestination = Position(col: isKingsideCastle ? .H : .A, row: pieceToReverse.owner == .white ? .one : .eight)
            
            let rook = board[rookCurrentPosition]!
            newBoard[rookCurrentPosition] = nil
            newBoard[rookDestination] = rook
            
        case .enPassant:
            let pieceToReverse = newBoard[move.destination]!
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = nil
            
            let capturedPosition = DirectedPosition(position: move.destination, perspective: turn.opponent).back!.position
            
            newBoard[capturedPosition] = move.capturedPiece
            
        case .promotion(_):
            let pieceToReverse = Pawn(owner: turn.opponent, pieceType: .pawn)
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = move.capturedPiece
        }
        
        return Game(board: newBoard, history: newHistory, turn: newTurn)
    }
    
    func moves(position: Position) -> Set<Move>? {
        guard let piece = board[position] else {
            return nil
        }
        
        return piece.possibleMoves(position: position, game: self)
    }
    
    func allMoves(team: Team) -> Set<Move> {
        return board.indices
            .reduce(Set<Move>()) {(nextPartialResult, position) -> Set<Move> in
                guard let piece = board[position], piece.owner == team else {
                    return nextPartialResult
                }
                
                return nextPartialResult.union(piece.possibleMoves(position: position, game: self))
            }
    }
    
    func positionsThreatened(team: Team) -> BoolChessGrid {
        return zip(board.indices, board)
            .compactMap { position, piece in
                guard piece?.owner == team else {
                    return nil
                }
                
                return piece?.threadtenedPositions(position: position, game: self)
            }
            .reduce(BoolChessGrid.false) { (nextPartialResult, moves) -> BoolChessGrid in
                nextPartialResult.union(moves)
            }
    }
    
    func kingPosition(team: Team) -> Position {
        return zip(board.indices, board)
            .first { position, piece in
                piece?.pieceType == .king && piece?.owner == team
            }!.0
    }
    
    func currentMoves() -> Set<Move> {
        return Game.validator.validMoves(possibleMoves: allMoves(team: turn), game: self)
    }
}

extension Game: Hashable {
    
}

extension Game {
    enum CastleSide {
        case kingside
        case queenside
    }
    
    func toFEN() -> String {
        var fenParts = [String]()
        
        // 1. Piece placement
        let boardFEN = (1...8).reversed().map { row in
            var rowFEN = ""
            var emptySquares = 0
            for col in 1...8 {
                let position = Position(col: Col(rawValue: col)!, row: Row(rawValue: row)!)
                if let piece = board[position] {
                    if emptySquares > 0 {
                        rowFEN += "\(emptySquares)"
                        emptySquares = 0
                    }
                    rowFEN += piece.fenChar()
                } else {
                    emptySquares += 1
                }
            }
            if emptySquares > 0 {
                rowFEN += "\(emptySquares)"
            }
            return rowFEN
        }.joined(separator: "/")
        fenParts.append(boardFEN)
        
        // 2. Active color
        let activeColor = turn == .white ? "w" : "b"
        fenParts.append(activeColor)
        
        // 3. Castling availability
        var castling = ""
        if canCastle(for: .white, kingside: true) { castling += "K" }
        if canCastle(for: .white, kingside: false) { castling += "Q" }
        if canCastle(for: .black, kingside: true) { castling += "k" }
        if canCastle(for: .black, kingside: false) { castling += "q" }
        fenParts.append(castling.isEmpty ? "-" : castling)
        
        // 4. En passant target square
        if let enPassantSquare = enPassantTargetSquare() {
            fenParts.append(enPassantSquare)
        } else {
            fenParts.append("-")
        }
//        fenParts.append("-")
        
        // 5. Halfmove clock
        let halfmoveClock = history.reversed().prefix(while: { !$0.isCaptureOrPawnMove(in: self) }).count
        fenParts.append("\(halfmoveClock)")
        
        // 6. Fullmove number
        let fullmoveNumber = (history.count / 2) + 1
        fenParts.append("\(fullmoveNumber)")
        
        return fenParts.joined(separator: " ")
    }
    
    func canCastle(for team: Team, kingside: Bool) -> Bool {
        // Determine the King's position
        guard let kingPosition = board.indices.first(where: { board[$0] is King && board[$0]?.owner == team }) else {
            return false
        }
        
        // Determine the Rook's position
        let rookCol: Col = kingside ? .H : .A
        let rookRow: Row = team == .white ? .one : .eight
        let rookPosition = Position(col: rookCol, row: rookRow)
        
        guard let rook = board[rookPosition] as? Rook, rook.owner == team else {
            return false
        }
        
        // Ensure neither the King nor the Rook has moved
        if history.contains(where: { $0.origin == kingPosition || $0.origin == rookPosition }) {
            return false
        }
        
        // Check that the squares between the King and the Rook are empty
//        let emptyRange: [Col] = kingside
//            ? [Col.F, Col.G] // Kingside: Squares F1, G1 (or F8, G8)
//            : [Col.B, Col.C, Col.D] // Queenside: Squares B1, C1, D1 (or B8, C8, D8)
//        
//        for col in emptyRange {
//            let position = Position(col: col, row: kingPosition.row)
//            if board[position] != nil {
//                return false
//            }
//        }
        
        // Ensure the King is not in check, and the squares it moves across are not threatened
        let kingMoveRange: [Position] = kingside
            ? [kingPosition, Position(col: .F, row: kingPosition.row), Position(col: .G, row: kingPosition.row)]
            : [kingPosition, Position(col: .D, row: kingPosition.row), Position(col: .C, row: kingPosition.row)]
        
        for position in kingMoveRange {
            if positionThreatened(by: team.opponent, at: position) {
                return false
            }
        }
        
        return true
    }
    
    private func positionThreatened(by team: Team, at position: Position) -> Bool {
        // This method checks if the given position is threatened by any piece of the opposing team.
        let threatenedPositions = positionsThreatened(team: team)
        return threatenedPositions[position]
    }
    
    func enPassantTargetSquare() -> String? {
        // Ensure that there is at least one move in history
        guard let lastMove = history.last else {
            return nil
        }

        // Check if the last move was a pawn's double-step move
        if lastMove.kind == .standard, let piece = board[lastMove.destination], piece is Pawn {
            let originRow = lastMove.origin.row.rawValue
            let destinationRow = lastMove.destination.row.rawValue
//            let originCol = lastMove.origin.col
//            let destinationCol = lastMove.destination.col

            // A double-step move for a pawn means the difference between the origin and destination rows is 2
            if abs(originRow - destinationRow) == 2 {
                // Determine the en passant target square (which is the square that can be attacked)
                let enPassantRow = Row(rawValue: ((originRow + destinationRow) / 2))!
                let enPassantCol = lastMove.destination.col

                // Ensure the target square is empty (where a potential en passant capture could occur)
                let enPassantTargetSquare = Position(col: enPassantCol, row: enPassantRow)
                if board[enPassantTargetSquare] == nil {
                    // Convert the column and row to FEN format
                    return "\(enPassantCol.fenCharacter)\(enPassantRow.fenCharacter)"
                }
            }
        }

        // No en passant target square
        return nil
    }
}

struct GameStats {
    var whiteTotalMoves: Int
    var whiteTotalEnpassants: Int
    var whiteTotalCastlings: Int
    var whiteTotalPromotions: Int
    
    var blackTotalMoves: Int
    var blackTotalEnpassants: Int
    var blackTotalCastlings: Int
    var blackTotalPromotions: Int
    
    static func previews() -> GameStats {
        return GameStats(
            whiteTotalMoves: 10,
            whiteTotalEnpassants: 1,
            whiteTotalCastlings: 2,
            whiteTotalPromotions: 2,
        
            blackTotalMoves: 10,
            blackTotalEnpassants: 1,
            blackTotalCastlings: 2,
            blackTotalPromotions: 2
        )
    }
}

// stats
extension Game {
    func getGameStats() -> GameStats {
        return GameStats(
            whiteTotalMoves: getWhitePlayerTotalMoves(),
            whiteTotalEnpassants: getWhitePlayerTotalEnpassant(),
            whiteTotalCastlings: getWhitePlayerTotalCastling(),
            whiteTotalPromotions: getWhitePlayerTotalPromotion(),
            
            blackTotalMoves: getBlackPlayerTotalMoves(),
            blackTotalEnpassants: getBlackPlayerTotalEnpassant(),
            blackTotalCastlings: getBlackPlayerTotalCastling(),
            blackTotalPromotions: getBlackPlayerTotalPromotion()
        )
    }
    
    func getWhitePlayerTotalMoves() -> Int {
        var index = 0
        var totalMoves = 0
        for _ in history {
            if (index % 2 == 0) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getBlackPlayerTotalMoves() -> Int {
        var index = 0
        var totalMoves = 0
        for _ in history {
            if (index % 2 != 0) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getWhitePlayerTotalEnpassant() -> Int {
        var index = 0
        var totalMoves = 0
        for move in history {
            if (index % 2 == 0 && move.kind == .enPassant) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getBlackPlayerTotalEnpassant() -> Int {
        var index = 0
        var totalMoves = 0
        for move in history {
            if (index % 2 != 0 && move.kind == .enPassant) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getWhitePlayerTotalPromotion() -> Int {
        var index = 0
        var totalMoves = 0
        for move in history {
            if (index % 2 == 0 && move.kind == .needsPromotion) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getBlackPlayerTotalPromotion() -> Int {
        var index = 0
        var totalMoves = 0
        for move in history {
            if (index % 2 != 0 && move.kind == .needsPromotion) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getWhitePlayerTotalCastling() -> Int {
        var index = 0
        var totalMoves = 0
        for move in history {
            if (index % 2 == 0 && move.kind == .castle) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
    
    func getBlackPlayerTotalCastling() -> Int {
        var index = 0
        var totalMoves = 0
        for move in history {
            if (index % 2 != 0 && move.kind == .castle) {
                totalMoves += 1
            }
                
            index += 1
        }
        return totalMoves
    }
}
