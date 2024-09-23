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

typealias BoolChessGrid = ChessGrid<Bool>

extension BoolChessGrid {
    static let `false` = BoolChessGrid(array: Array(repeating: false, count: 64))
    static let `true` = BoolChessGrid(array: Array(repeating: true, count: 64))
    
    init() {
        self = BoolChessGrid(array: Array(repeating: false, count: 64))
    }
    
    init(positions: [Position]) {
        self = BoolChessGrid()
        for position in positions {
            self[position] = true
        }
    }
    
    func toMoves(origin: Position, board: Board) -> Set<Move> {
        assert(self[origin] == false, "Invalid move: origin and destination can not be the same")
        
        return zip(self.indices, self)
            .compactMap { destination, canMove in
                guard canMove else {
                    return nil
                }
                return Move(origin: origin, destination: destination, capturedPiece: board[destination])
            }
            .toSet()
    }
}

extension BoolChessGrid: SetAlgebra {
    var isEmpty: Bool {
        return self == BoolChessGrid.false
    }
    
    func union(_ other: __owned BoolChessGrid) -> BoolChessGrid {
        let newArray = zip(self, other).map({
            $0 || $1
        })
        return BoolChessGrid(array: newArray)
    }
    
    func intersection(_ other: BoolChessGrid) -> BoolChessGrid {
        let newArray = zip(self, other).map({
            $0 && $1
        })
        return BoolChessGrid(array: newArray)
    }
    
    func symmetricDifference(_ other: __owned BoolChessGrid) -> BoolChessGrid {
        let newArray = zip(self, other).map{
            (Int(truncating: NSNumber(value: $0)) ^ Int(truncating: NSNumber(value: $1))) == 1
        }
        return BoolChessGrid(array: newArray)
    }
    
    mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
        return (false, false)
    }
    
    mutating func remove(_ member: Element) -> Element? {
        return nil
    }
    
    mutating func update(with newMember: __owned Element) -> Element? {
        return nil
    }
    
    mutating func formUnion(_ other: __owned BoolChessGrid) {
        let newArray = zip(self, other).map({
            $0 || $1
        })
        self = BoolChessGrid(array: newArray)
    }
    
    mutating func formIntersection(_ other: BoolChessGrid) {
        let newArray = zip(self, other).map({
            $0 && $1
        })
        self = BoolChessGrid(array: newArray)
    }
    
    mutating func formSymmetricDifference(_ other: __owned BoolChessGrid) {
        let newArray = zip(self, other).map{
            (Int(truncating: NSNumber(value: $0)) ^ Int(truncating: NSNumber(value: $1))) == 1
        }
        self = BoolChessGrid(array: newArray)
    }
}
