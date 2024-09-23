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

protocol CheckHandlerProtocol {
    func state(team: Team, game: Game) -> CheckHandler.State
    
    func validMoves(possibleMoves: Set<Move>, game: Game) -> Set<Move>
}

struct CheckHandler: CheckHandlerProtocol {
    enum State {
        case none
        case check
        case checkmate
    }
    
    func state(team: Team, game: Game) -> State {
        let whiteKingPosition = game.kingPosition(team: .white)
        let blackKingPosition = game.kingPosition(team: .black)
        
        let whitePlayerThreatenedPositions = game.positionsThreatened(team: .white)
        
        let blackPlayerThreatenedPositions = game.positionsThreatened(team: .black)
        
        switch team {
        case .white:
            let whitePlayerStatus: State = {
                let whiteKingIsThreatened = blackPlayerThreatenedPositions[whiteKingPosition]
                
                let allPossibleWhiteMoves = game.allMoves(team: .white)
                
                let allPossibleNewGameStates = allPossibleWhiteMoves.map {
                    game.performing($0)
                }
                
                if whiteKingIsThreatened {
                    guard game.turn == .white else {
                        return .checkmate
                    }
                    
                    let somePossibleWhiteMoveEliminatesKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, team: .white)
                    
                    return somePossibleWhiteMoveEliminatesKingThreat ? .check : .checkmate
                } else {
                    guard game.turn == .white else {
                        return .none
                    }
                    
                    let somePossibleWhiteMoveDoesNotIntroduceKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, team: .white)
                    
                    return somePossibleWhiteMoveDoesNotIntroduceKingThreat ? .none : .checkmate
                }
            }()
            
            return whitePlayerStatus
            
        case .black:
            let blackPlayerStatus: State = {
                let blackKingIsThreatened = whitePlayerThreatenedPositions[blackKingPosition]
                let allPossibleBlackMoves = game.allMoves(team: .black)
                let allPossibleNewGameStates = allPossibleBlackMoves.map {
                    game.performing($0)
                }
                
                if blackKingIsThreatened {
                    guard game.turn == .black else {
                        return .checkmate
                    }
                    
                    let somePossibleBlackMoveEliminatesKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, team: .black)
                    
                    return somePossibleBlackMoveEliminatesKingThreat ? .check : .checkmate
                } else {
                    guard game.turn == .black else {
                        return .none
                    }
                    
                    let somePossibleBlackMoveDoesNotIntroduceKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, team: .black)
                    
                    return somePossibleBlackMoveDoesNotIntroduceKingThreat ? .none : .checkmate
                }
            }()
            
            return blackPlayerStatus
        }
    }
    
    // when king is checked, validate if one of these scenario can help the team escape from check status
    func oneOfThese(scenarios: [Game], team: Team) -> Bool {
        scenarios
            .filter { scenario in
                let playerNewKingPosition = scenario.kingPosition(team: team)
                
                let opposingPlayersNewThreatenedPositions = scenario.positionsThreatened(team: team.opponent)
                
                let playerKingIsThreatenedInThisScenario = opposingPlayersNewThreatenedPositions[playerNewKingPosition]
                
                return !playerKingIsThreatenedInThisScenario
            }
            .count > 0
    }
    
    func validMoves(possibleMoves: Set<Move>, game: Game) -> Set<Move> {
        let potentialNewScenarios: [Game] = possibleMoves.map { possibleMove in
            game.performing(possibleMove)
        }
        
        let validMoves: [Move] = zip(possibleMoves, potentialNewScenarios).compactMap {
            possibleMoves, scenario in
            guard state(team: game.turn, game: scenario) == .none else {
                return nil
            }
            
            return possibleMoves
        }
        return Set(validMoves)
    }
}
