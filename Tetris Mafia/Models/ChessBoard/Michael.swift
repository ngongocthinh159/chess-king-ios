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

class Michael: ArtificialIntelligence {
    var name: String
    var wins: Int 
    
    init() {
        self.name = "Michael the dumb AI"
        self.wins = 10
    }
    
    init(name: String, wins: Int) {
        self.name = name
        self.wins = wins 
    }
    
    init(wins: Int) {
        self.name = "Michael the dumb AI"
        self.wins = wins 
    }
    
    func nextMove(game: Game) -> Move {
        let moves = game.currentMoves()
        
        let analyses = moves.map { move in
            analysis(move: move, team: game.turn, game: game)
        }
            .sorted(by: {$0.isObjectivelyBetter(otherAnalysis: $1)})
        
        return analyses.first!.move
    }
    
    struct ScenarioAnalysis {
        let mostValuablePieceThreatenedByOpponent: Piece?
        let mostValuablePieceThreatenedByUs: Piece?
        
        var opponentThreatValue: Int {
            return mostValuablePieceThreatenedByOpponent?.value ?? 0
        }
        
        var ourThreatValue: Int {
            return mostValuablePieceThreatenedByUs?.value ?? 0
        }
        
        var threatScore: Int {
            return ourThreatValue - opponentThreatValue
        }
    }
    
    struct MoveAnalysis {
        let capturedPiece: Piece?
        let oldScenario: ScenarioAnalysis
        let newScenario: ScenarioAnalysis
        let move: Move
        
        var exchangeRatio: Int {
            (capturedPiece?.value ?? 0) - newScenario.opponentThreatValue
        }
        
        var threatScore: Int {
            return newScenario.threatScore - oldScenario.threatScore
        }
        
        func isObjectivelyBetter(otherAnalysis: MoveAnalysis) -> Bool {
            guard self.exchangeRatio == otherAnalysis.exchangeRatio else {
                return self.exchangeRatio > otherAnalysis.exchangeRatio
            }
            
            return self.threatScore > otherAnalysis.threatScore
        }
    }
    
    func analysis(move: Move, team: Team, game: Game) -> MoveAnalysis {
        let currentMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(team: team.opponent, game: game)
        let currentMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(team: team, game: game)
        
        let oldScenarioAnalysis = ScenarioAnalysis(
            mostValuablePieceThreatenedByOpponent: currentMostValuablePieceThreatenedByOpponent,
            mostValuablePieceThreatenedByUs: currentMostValuablePieceThreatenedByUs)
        
        let newScenario = game.performing(move)
        
        let newMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(team: team.opponent, game: newScenario)
        let newMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(team: team, game: newScenario)
        
        let newScenarioAnalysis = ScenarioAnalysis(mostValuablePieceThreatenedByOpponent: newMostValuablePieceThreatenedByOpponent, mostValuablePieceThreatenedByUs: newMostValuablePieceThreatenedByUs)
        
        return MoveAnalysis(capturedPiece: move.capturedPiece, oldScenario: oldScenarioAnalysis, newScenario: newScenarioAnalysis, move: move)
    }
    
    func mostValuablePieceThreatened(team: Team, game: Game) -> Piece? {
        let threatenedPositions = game.positionsThreatened(team: team)
        return zip(threatenedPositions.indices, threatenedPositions)
            .filter { position, isThreatened in
                isThreatened
            }
            .compactMap { position, isThreatened in
                guard let piece = game.board[position] else {
                    return nil
                }
                return piece
            }
            .sorted(by: {$0.value > $1.value})
            .first
    }
}
