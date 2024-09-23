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

struct Position: Equatable, Codable {
    let col: Col
    let row: Row
    
    init(col: Col, row: Row) {
        self.col = col
        self.row = row
    }
    
    init?(gridIndex: IndexPath) {
        guard gridIndex != IndexPath(row: 8, column: 0) else {
            self = Position(col: .A, row: .end)
            return
        }
        
        guard let row = Row(rawValue: 8 - gridIndex.row),
              let col = Col(rawValue: gridIndex.column + 1) 
        else {
            return nil
        }
        
        self.col = col
        self.row = row
    }
    
    init?(fromStr field: String) { // example: d7
        // Ensure the field is exactly 2 characters long
        guard field.count == 2 else { return nil }

        // Extract column and row characters
        let colChar = field.prefix(1)
        let rowChar = field.suffix(1)

        // Convert column character to Col enum
        guard let colValue = colChar.unicodeScalars.first?.value,
              let col = Col(rawValue: Int(colValue) - Int(UnicodeScalar("a").value) + 1) else {
            return nil
        }

        // Convert row character to Row enum
        guard let row = Row(rawValue: Int(rowChar) ?? 0) else {
            return nil
        }

        // Initialize Position
        self.init(col: col, row: row)
    }
    
    // used for access the element inside the Grid, grid[position.gridIndex]
    var gridIndex: IndexPath {
        let convertedRow = abs(row.rawValue - 8)
        let convertedRank = col.rawValue - 1
        
        return IndexPath(row: convertedRow, column: convertedRank)
    }
    
    func isAdjacent(other: Position) -> Bool {
        let directedPosition  = DirectedPosition(position: self, perspective: .white)
        let adjacentPosition = [
            directedPosition.front,
            directedPosition.back,
            directedPosition.left,
            directedPosition.right,
            directedPosition.diagonalLeftFront,
            directedPosition.diagonalRightFront,
            directedPosition.diagonalLeftBack,
            directedPosition.diagonalRightBack,
        ].compactMap {
            $0?.position
        }
        return adjacentPosition.contains(other)
    }
    
    static func isValidPath(array: [Position]) -> Bool {
        // empty path is a valid path
        guard !array.isEmpty else {
            return true
        }
        
        // while next move isAdjacent to current move => still a valid path
        var iterator = array.makeIterator()
        var current = iterator.next()!
        
        while let nextElement = iterator.next() {
            guard current.isAdjacent(other: nextElement) else {
                return false
            }
            current = nextElement
        }
        
        return true
    }
    
    func fromPerspective(team: Team) -> DirectedPosition {
        return DirectedPosition(position: self, perspective: team)
    }
    
    static func pathConsideringCollisions(team: Team, path: [Position], board: Board) -> [Position] {
        assert(isValidPath(array: path))
        
        var res = [Position]()
        
        for position in path {
            switch board[position] {
            case .none:
                res.append(position)
            case .some(let collidingPiece):
                if collidingPiece.owner == team.opponent {
                    res.append(position)
                }
                return res
            }
        }
        
        return res
    }
}

extension Position: Comparable {
    static func < (lhs: Position, rhs: Position) -> Bool {
        return lhs.gridIndex < rhs.gridIndex
    }
}

extension Position: Hashable {
    
}

extension Position: CustomStringConvertible {
    var description: String {
        "\(col) - \(row.rawValue)"
    }
}
