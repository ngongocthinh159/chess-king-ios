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

struct Grid<Element:Codable>: Codable {
    typealias Column = [Element]
    
    var columns: [Column]
    let rowSize: Int
    let columnSize: Int

    init(rowSize: Int, columnSize: Int, array: [Element]) {
        precondition(array.count == rowSize * columnSize, "mismatch between grid size, cols and rows")
        
        var columns = Array(repeating: Column(), count: rowSize)
        var current = 0
        for element in array {
            columns[current].append(element)
            
            if current == columns.count - 1 {
                current = 0
            } else {
                current += 1
            }
        }
        
        self.columns = columns
        self.rowSize = rowSize
        self.columnSize = columnSize
    }
    
    // access grid cell through row and col indexes
    subscript(row: Int, column: Int) -> Element {
        get {
            return columns[column][row]
        }
        
        set {
            columns[column][row] = newValue
        }
    }
    
    // access grid cell through IndexPath
    subscript(position: IndexPath) -> Element {
        get {
            return self[position.row, position.column]
        }
        
        set {
            self[position.row, position.column] = newValue
        }
    }
}

extension Grid: Collection {
    func index(after i: IndexPath) -> IndexPath {
        if (i.column == columnSize - 1) {
            return IndexPath(row: i.row + 1, column: 0)
        } else {
            return IndexPath(row: i.row, column: i.column + 1)
        }
    }
    typealias Index = IndexPath
    
    var startIndex: IndexPath {
        return IndexPath(indexes: [0, 0])
    }
    
    var endIndex: IndexPath {
        return IndexPath(indexes: [0, columnSize])
    }
}

extension Grid: BidirectionalCollection {
    func index(before i: IndexPath) -> IndexPath {
        if (i.column == 0) {
            return IndexPath(row: i.row - 1, column: columnSize - 1)
        } else {
            return IndexPath(row: i.row, column: i.column - 1)
        }
    }
}

extension Grid: RandomAccessCollection {
    
}

extension Grid: CustomStringConvertible {
    var description: String {
        return columns.reduce("") { (currentResult, column) -> String in
            return currentResult + String(describing: column) + "\n"
        }
    }
}

extension Grid: Equatable where Element: Equatable {
    
}

extension Grid: Hashable where Element: Hashable {
    
}

extension Grid where Element: ExpressibleByNilLiteral {
    init(rowSize: Int, columnSize: Int) {
        let emptyArray = Array<Element>(repeating: nil, count: rowSize * columnSize)
        self = Grid(rowSize: rowSize, columnSize: columnSize, array: emptyArray)
    }
}
