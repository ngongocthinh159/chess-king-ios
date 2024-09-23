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

typealias Board = ChessGrid<Piece?>

var isDebug = false

extension Board {
    static let standard: Board = {
        let pieces: [Piece?] = [
            Rook(owner: .black, pieceType: .rook),
            Knight(owner: .black, pieceType: .knight),
            Bishop(owner: .black, pieceType: .bishop),
            Queen(owner: .black, pieceType: .queen ),
            King(owner: .black, pieceType: .king ),
            Bishop(owner: .black, pieceType: .bishop),
            Knight(owner: .black, pieceType: .knight),
            Rook(owner: .black, pieceType: .rook),
            
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            
            Rook(owner: .white, pieceType: .rook),
            Knight(owner: .white, pieceType: .knight ),
            Bishop(owner: .white, pieceType: .bishop),
            Queen(owner: .white, pieceType: .queen ),
            King(owner: .white, pieceType: .king ),
            Bishop(owner: .white, pieceType: .bishop),
            Knight(owner: .white, pieceType: .knight),
            Rook(owner: .white, pieceType: .rook),
        ]
        
        if isDebug {
//            return Board.checkMateBoard()
//            return Board.humanVsAILoseGame()
            return casltingBoard()
//            return promotionBoard()
        }
        
        return ChessGrid(array: pieces)
    }()
    
    static func colors(modelData: ModelData) -> ChessGrid<String> {
//        let colors: [Color] = zip(standard.indices, standard)
//            .map { position, Piece in
//                return (position.row.rawValue + position.col.rawValue) % 2 == 0 ? modelData.appConfig.blackTileBGColor : modelData.appConfig.whileTileBGColor
//            }
//        return ChessGrid<Color>(array: colors)
        let colors: [String] = zip(standard.indices, standard)
            .map { position, Piece in
                let color = (position.row.rawValue + position.col.rawValue) % 2 == 0 ? modelData.appConfig.blackTileBGColor : modelData.appConfig.whileTileBGColor
                return color.toHex() ?? "#FFFFFF"  // Default to white if conversion fails
            }
        return ChessGrid<String>(array: colors)
    }
    
    static func casltingBoard() -> Board  {
        let pieces: [Piece?] = [
            Rook(owner: .black, pieceType: .rook),
//            Knight(owner: .black),
//            Bishop(owner: .black),
//            Queen(owner: .black),
            nil,
            nil,
            nil,
            King(owner: .black, pieceType: .king),
//            Bishop(owner: .black),
//            Knight(owner: .black),
            nil,
            nil,
            Rook(owner: .black, pieceType: .rook),

            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),

            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),

            Rook(owner: .white, pieceType: .rook),
//            Knight(owner: .white),
//            Bishop(owner: .white),
//            Queen(owner: .white),
            nil, 
            nil,
            nil,
            King(owner: .white, pieceType: .king),
//            Bishop(owner: .white),
//            Knight(owner: .white),
            nil,
            nil,
            Rook(owner: .white, pieceType: .rook),
        ]
        
        return ChessGrid(array: pieces)
    }
    
    static func checkMateBoard() -> Board {
        let pieces: [Piece?] = [
//            Rook(owner: .black, pieceType: .rook),
            nil,
//            Knight(owner: .black),
//            Bishop(owner: .black),
//            Queen(owner: .black),
            nil,
            nil,
            nil,
            King(owner: .black, pieceType: .king),
//            Bishop(owner: .black),
//            Knight(owner: .black),
            nil,
            nil,
            Rook(owner: .black, pieceType: .rook),

            Queen(owner: .white, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),

            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),

//            Rook(owner: .white, pieceType: .rook),
            nil,
//            Knight(owner: .white),
//            Bishop(owner: .white),
//            Queen(owner: .white),
            nil, nil, nil,
            King(owner: .white, pieceType: .king),
//            Bishop(owner: .white),
//            Knight(owner: .white),
            nil,
            nil,
            Rook(owner: .white, pieceType: .rook),
        ]
        
        return ChessGrid(array: pieces)
    }
    
    static func humanVsAILoseGame() -> Board {
        return [
            Rook(owner: .black, pieceType: .rook),
            Knight(owner: .black, pieceType: .knight),
            Bishop(owner: .black, pieceType: .bishop),
            Queen(owner: .black, pieceType: .queen ),
            King(owner: .black, pieceType: .king ),
            Bishop(owner: .black, pieceType: .bishop),
            Knight(owner: .black, pieceType: .knight),
            Rook(owner: .black, pieceType: .rook),
            
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            
            Queen(owner: .black, pieceType: .queen),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            
//            Rook(owner: .black, pieceType: .rook),
//            Knight(owner: .white, pieceType: .knight ),
//            Bishop(owner: .white, pieceType: .bishop),
//            Queen(owner: .white, pieceType: .queen ),
            nil, nil, nil, nil,
            King(owner: .white, pieceType: .king ),
            Bishop(owner: .white, pieceType: .bishop),
            Knight(owner: .white, pieceType: .knight),
            Rook(owner: .white, pieceType: .rook),
        ]
    }
    
    static func humanVsAIWinGame() -> Board {
        return [
//            Rook(owner: .black, pieceType: .rook),
//            Knight(owner: .black, pieceType: .knight),
//            Bishop(owner: .black, pieceType: .bishop),
//            Queen(owner: .black, pieceType: .queen ),
            nil, nil, nil, nil,
            King(owner: .black, pieceType: .king ),
            Bishop(owner: .black, pieceType: .bishop),
            Knight(owner: .black, pieceType: .knight),
            Rook(owner: .black, pieceType: .rook),
            
            Queen(owner: .white, pieceType: .queen),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            
            Rook(owner: .black, pieceType: .rook),
            Knight(owner: .white, pieceType: .knight ),
            Bishop(owner: .white, pieceType: .bishop),
            Queen(owner: .white, pieceType: .queen ),
            King(owner: .white, pieceType: .king ),
            Bishop(owner: .white, pieceType: .bishop),
            Knight(owner: .white, pieceType: .knight),
            Rook(owner: .white, pieceType: .rook),
        ]
    }
    
    static func promotionBoard() -> Board  {
        let pieces: [Piece?] = [
//            Rook(owner: .black, pieceType: .rook),
            nil,
//            Knight(owner: .black),
//            Bishop(owner: .black),
//            Queen(owner: .black),
            nil,
            nil,
            nil,
            King(owner: .black, pieceType: .king),
//            Bishop(owner: .black),
//            Knight(owner: .black),
            nil,
            nil,
            Rook(owner: .black, pieceType: .rook),

            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),
            Pawn(owner: .black, pieceType: .pawn),

            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),
            Pawn(owner: .white, pieceType: .pawn),

            Rook(owner: .white, pieceType: .rook),
//            Knight(owner: .white),
//            Bishop(owner: .white),
//            Queen(owner: .white),
            nil,
            nil,
            nil,
            King(owner: .white, pieceType: .king),
//            Bishop(owner: .white),
//            Knight(owner: .white),
            nil,
            nil,
            Rook(owner: .white, pieceType: .rook),
        ]
        
        return ChessGrid(array: pieces)
    }
}
