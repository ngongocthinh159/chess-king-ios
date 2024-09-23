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
import Combine

@Observable
class GameViewModel {
    var session: SessionManager
    
    typealias ValidMoveCollection = Set<Move>
    let roster: Roster
    var game: Game
    var state: State
    var selection: Selection?
    var shouldPromptForPromotion = PassthroughSubject<Move, Never>()
    var checkHandler: CheckHandler
    var validMoveGrid = ChessGrid(repeating: ValidMoveCollection())
    var checkmateOccured = PassthroughSubject<Team, Never>()
//    var moveCache: [Game: Set<Move>] = [:]
    var isWhitePlayerHasPromotion = false 
    
    private let minimumThinkingTimeOfAI = 2 // in seconds
    private let selectionDelayTimeOfAI = 800 // in milliseconds, just for realistic effect
    
    init(roster: Roster, game: Game = Game.standard, session: SessionManager) {
        self.roster = roster
        self.game = game
        self.state = .working
        self.checkHandler = CheckHandler()
        self.session = session
        
        self.beginNextTurn()
    }
    
    init(game: Game, roster: Roster = Roster(whitePlayer: .AI(Michael() as ArtificialIntelligence), blackPlayer: .human(TheHuman())), selection: Selection? = nil, checkHandler: CheckHandler = CheckHandler(), session: SessionManager) {
        self.game = game
        self.roster = roster
        self.selection = selection
        self.checkHandler = checkHandler
        self.state = .working
        self.session = session
        
        self.beginNextTurn()
    }
    
    init(game: Game, whitePlayer: Player, blackPlayer: Player, selection: Selection, session: SessionManager) {
        self.game = game
        self.roster = Roster(whitePlayer: whitePlayer, blackPlayer: blackPlayer)
        self.selection = selection
        self.checkHandler = CheckHandler()
        self.state = .working
        self.session = session
        
        self.beginNextTurn()
    }
    
    enum State: Equatable, CustomStringConvertible {
        case awaitingInput
        case working
        case aiThinking(name: String)
        case stalemate
        case gameOver(Team)
        
        var description: String {
            switch self {
            case .awaitingInput:
                return "Make A Move"
            case .working:
                return "Processing"
            case .aiThinking(let name):
                return "\(name) is thinking"
            case .stalemate:
                return "Stalemate"
            case .gameOver(let winner):
                return "\(winner) has won"
            }
        }
        
        func descriptionInLanguage(language: AppLanguage) -> String {
            switch language {
            case .EN:
                switch self {
                case .awaitingInput:
                    return "Game: Please make a move"
                case .working:
                    return "Game: Processing board.."
                case .aiThinking(let name):
                    return "\(name): I'm thinking"
                case .stalemate:
                    return "Game: Stalemate! No winner"
                case .gameOver(let winner):
                    return "Game: \(winner) has won!"
                }
            case .VN:
                switch self {
                case .awaitingInput:
                    return "Game: Mời bạn đi nước tiếp theo"
                case .working:
                    return "Game: Đang xử lý bàn chơi"
                case .aiThinking(let name):
                    return "\(name): Tôi đang suy nghĩ"
                case .stalemate:
                    return "Game: Hoà cờ! Không có người thắng"
                case .gameOver(let winner):
                    return "Game: Kết Thúc, \(winner) đã thắng!"
                }
            }
        }
    }
    
    struct Selection: Codable {
        let moves: Set<Move>
        let origin: Position
        
        var grid: BoolChessGrid {
            return BoolChessGrid(positions: moves.map{
                $0.destination
            })
        }
        
        func move(position: Position) -> Move? {
            return moves.first(where: {
                $0.destination == position
            })
        }
    }
    
    func beginNextTurn() {
        self.selection = nil
        guard checkHandler.state(team: self.game.turn, game: game) != .checkmate else {
            // MARK: - Game is over
            self.state = .gameOver(self.game.turn.opponent)
            
            checkmateOccured.send(self.game.turn.opponent)
            
            return
        }
        
        switch roster[game.turn] {
        case .human:
            regenerateValidMoveGrid {
                self.state = .awaitingInput
            }
            
        case .AI(let artificialOpponent):
            regenerateValidMoveGrid {
                self.performAIMove(opponent: artificialOpponent) {
                    self.beginNextTurn()
                }
            }
        }
        
        print(game.toFEN())
    }
    
    func regenerateValidMoveGrid(completion: @escaping () -> ()) {
        self.state = .working
        DispatchQueue.global(qos: .userInitiated).async {
            let allMoves = self.game.allMoves(team: self.game.turn)
            let validMoves = self.checkHandler.validMoves(possibleMoves: allMoves, game: self.game)
            self.validMoveGrid = ChessGrid(repeating: ValidMoveCollection())
            
//            var validMoves: Set<Move> = []
//            if let cachedMoves = self.moveCache[self.game] {
//                validMoves = cachedMoves
//            } else {
//                let allMoves = self.game.allMoves(team: self.game.turn)
//                let validMoves = self.checkHandler.validMoves(possibleMoves: allMoves, game: self.game)
//                self.moveCache[self.game] = validMoves
//            }
//            self.validMoveGrid = ChessGrid(repeating: ValidMoveCollection())
            
            for validMove in validMoves {
                self.validMoveGrid[validMove.origin].insert(validMove)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func performAIMove(opponent: ArtificialIntelligence, callback: () -> ()) {
        self.state = .aiThinking(name: opponent.name)
        
        let minimumThinkingTime = DispatchTime.now() + DispatchTimeInterval.seconds(self.minimumThinkingTimeOfAI)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let nextMove = opponent.nextMove(game: self.game)
            
            DispatchQueue.main.asyncAfter(deadline: minimumThinkingTime) {
                self.select(nextMove.origin)
                
                let selectionDelay = DispatchTime.now() + DispatchTimeInterval.milliseconds(self.selectionDelayTimeOfAI)
                
                DispatchQueue.main.asyncAfter(deadline: selectionDelay) {
                    self.perform(move: nextMove)
                }
            }
        }
    }
    
    func moves(position: Position) -> Set<Move>? {
        let moves = validMoveGrid[position]
        return moves.isEmpty ? nil : moves
    }
    
    func select(_ position: Position) {
        switch selection {
        case .none:
            guard let moves = moves(position: position) else {
                return
            }
            self.selection = Selection(moves: moves, origin: position)
            
        case .some(let selection):
            if let moves = moves(position: position) {
                self.selection = Selection(moves: moves, origin: position)
            } else if let selectedMove = selection.move(position: position) {
                perform(move: selectedMove)
                return
            } else {
                self.selection = nil
            }
        }
    }
    
    func perform(move: Move) {
        game = game.performing(move)
        
//        moveCache.removeValue(forKey: game)
        
        if case .needsPromotion = move.kind {
            if case .human = roster[game.turn.opponent] {
                isWhitePlayerHasPromotion = true 
            }
            
            guard case .human = roster[game.turn.opponent] else {
                handlePromotion(promotionType: Queen.self, pieceType: .queen)
                return
            }
            
            shouldPromptForPromotion.send(move)
            
        } else {
            beginNextTurn()
        }
        
        // MARK: - Save game state for each move
        saveLastGameStateToWhitePlayer()
    }
    
    func reverseLastMove() {
        self.game = game.reversingLastMove()
        
        if case .AI(_) = roster[self.game.turn] {
            self.game = game.reversingLastMove()
        }
        
//        moveCache.removeValue(forKey: game)
        
        beginNextTurn()
        
        saveLastGameStateToWhitePlayer()
    }
    
    func handlePromotion(promotionType: Piece.Type, pieceType: PieceType) {
        let moveToPromote = game.history.last!
        assert(moveToPromote.kind == .needsPromotion)
        
        game = game.reversingLastMove()
        let promotionMove = Move(origin: moveToPromote.origin, destination: moveToPromote.destination, capturedPiece: moveToPromote.capturedPiece, kind: .promotion(promotionType.init(owner: game.turn, pieceType: pieceType)))
        
        game = game.performing(promotionMove)
        beginNextTurn()
        
        saveLastGameStateToWhitePlayer()
    }
    
    func saveLastGameStateToWhitePlayer() {
        print("save state now")
        session.user.lastGameState = GameState(
            game: self.game ,
            whitePlayer: self.roster.whitePlayer.name,
            blackPlayer: self.roster.blackPlayer.name,
            selection: self.selection,
            vsAI: self.roster.blackPlayer.isAI
        )
        session.save()
    }
}
