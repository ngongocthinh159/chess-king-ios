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

class TomHuynh: ArtificialIntelligence {
//    private let apiUrl = "https://chess-api.com/v1"
//    private let defaultDepth = 12
//    private let defaultMaxThinkingTime = 100 // ms
    
    private let apiUrl = "https://stockfish.online/api/s/v2.php"
    
    var name: String
    var wins: Int
    
    init() {
        self.name = "TomHuynh super AI"
        self.wins = 10
    }
    
    init(name: String, wins: Int) {
        self.name = name
        self.wins = wins
    }
    
    init(wins: Int) {
        self.name = "Michael super AI"
        self.wins = wins
    }
    
    init(name: String) {
        self.name = name
        self.wins = 10
    }
    
    func nextMove(game: Game) -> Move {
        let semaphore = DispatchSemaphore(value: 0)
        var resultMove: Move?

//        let data = ChessAPIRequest(fen: game.toFEN(), depth: self.defaultDepth, maxThinkingTime: self.defaultMaxThinkingTime)
//        APICaller.shared.postData(to: apiUrl, data: data) { (result: Result<ChessAPIResponse, NetworkError>) in
//            switch result {
//            case .success(let response):
//                resultMove = self.createMoveFromResponse(from: response, game: game)
//                print(resultMove ?? "success fetch move from ChessApi: from \(String(describing: resultMove?.origin)) to \(String(describing: resultMove?.destination))")
//            case .failure(let error):
//                resultMove = nil
//                print("Error fetching user data: \(error)")
//            }
//            semaphore.signal()
//        }
        
        APICaller.shared.fetchData(to: apiUrl, queryParams: ["fen": game.toFEN(), "depth": String(self.getAPIQueryDepth())]) { (result: Result<StockFishOnlineResponse, NetworkError>) in
            switch result {
            case .success(let response):
                resultMove = self.createMoveFromResponse(from: response, game: game)
                print(resultMove ?? "success fetch move from ChessApi: from \(String(describing: resultMove?.origin)) to \(String(describing: resultMove?.destination))")
            case .failure(let error):
                resultMove = nil
                print("Error fetching user data: \(error)")
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if resultMove == nil {
            return getRandomMove(game: game)
        }
        
        return resultMove!
    }
    
//    func createMoveFromResponse(from response: ChessAPIResponse, game: Game) -> Move {
//        let origin = Position(fromStr: response.from)!
//        let destination = Position(fromStr: response.to)!
//        
//        for move in game.allMoves(team: game.turn) {
//            if (move.origin.col == origin.col && move.origin.row == origin.row && move.destination.col == destination.col && move.destination.row == destination.row) {
//                return move
//            }
//        }
//        
//        return getRandomMove(game: game)
//    }
    
    func createMoveFromResponse(from response: StockFishOnlineResponse, game: Game) -> Move {
        do {
            let bestmove = response.bestmove.split(separator: " ")[1]
            let origin = Position(fromStr: String(bestmove.prefix(2)))!
            let destination = Position(fromStr:  String(bestmove.prefix(4).suffix(2)))!
            
            for move in game.allMoves(team: game.turn) {
                if (move.origin.col == origin.col && move.origin.row == origin.row && move.destination.col == destination.col && move.destination.row == destination.row) {
                    return move
                }
            }
        } catch let error {
            print("Error parsing bestmove: \(error)")
        }
        
        return getRandomMove(game: game)
    }
    
    func getRandomMove(game: Game) -> Move {
        print("TomHuynh can not decide his move, take random")
        return game.allMoves(team: game.turn).first!
    }
    
    func getAPIQueryDepth() -> Int  {
        return 15
    }
}
