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

struct ChessGrid<Element:Codable>: Codable {
    var grid: Grid<Element>
    
    init(array: [Element]) {
        self.grid = Grid<Element>(rowSize: 8, columnSize: 8, array: array)
    }
    
    init(repeating: Element) {
        self.grid = Grid<Element>(rowSize: 8, columnSize: 8, array: Array(repeating: repeating, count: 64))
    }
    
    subscript(position: Position) -> Element {
        get {
            return grid[position.gridIndex]
        }
        
        set {
            grid[position.gridIndex] = newValue
        }
    }
}

extension ChessGrid: Equatable where Element: Equatable {
    
}

extension ChessGrid: Hashable where Element: Hashable {
    
}

extension ChessGrid: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Element
    
    init(arrayLiteral elements: Element...) {
        self = ChessGrid(array: elements)
    }
}

extension ChessGrid where Element: ExpressibleByNilLiteral {
    init () {
        self.grid = Grid<Element>(rowSize: 8, columnSize: 8)
    }
}

extension ChessGrid: Collection {
    typealias Index = Position
    
    func index(after i: Position) -> Position {
        Position(gridIndex: grid.index(after: i.gridIndex))!
    }
    
    var startIndex: Position {
        return Position(gridIndex: grid.startIndex)!
    }
    
    var endIndex: Position {
        return Position(gridIndex: grid.endIndex)!
    }
}

extension ChessGrid: BidirectionalCollection {
    func index(before i: Position) -> Position {
        Position(gridIndex: grid.index(before: i.gridIndex))!
    }
}

extension ChessGrid: RandomAccessCollection {
    
}

extension ChessGrid: CustomStringConvertible {
    var description: String {
        return grid.description
    }
}
