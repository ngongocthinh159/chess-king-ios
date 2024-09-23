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

struct DirectedPosition {
    let position: Position
    let perspective: Team
    
    func allSpaces(calculateNextPosition: (DirectedPosition) -> DirectedPosition?) -> [DirectedPosition] {
        
        var res = [DirectedPosition]()
        var current = self
        
        while let nextPosition = calculateNextPosition(current) {
            res.append(nextPosition)
            current = nextPosition
        }
        
        return res
    }
    
    var front: DirectedPosition? {
        guard let newRow = Row(rawValue: perspective == .white ? position.row.rawValue + 1 : position.row.rawValue - 1) else {
            return nil
        }
        
        let newPosition = Position(col: position.col, row: newRow)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    var back: DirectedPosition? {
        guard let newRow = Row(rawValue: perspective == .white ? position.row.rawValue - 1 : position.row.rawValue + 1) else {
            return nil
        }
        
        let newPosition = Position(col: position.col, row: newRow)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    var right: DirectedPosition? {
        guard let newCol = Col(rawValue: perspective == .white ? position.col.rawValue + 1 : position.col.rawValue - 1) else {
            return nil
        }
        
        let newPosition = Position(col: newCol, row: position.row)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    var left: DirectedPosition? {
        guard let newCol = Col(rawValue: perspective == .white ? position.col.rawValue - 1 : position.col.rawValue + 1) else {
            return nil
        }
        
        let newPosition = Position(col: newCol, row: position.row)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    var diagonalLeftFront: DirectedPosition? {
        return self
            .left?
            .front
    }
    
    var diagonalRightFront: DirectedPosition? {
        return self
            .right?
            .front
    }
    
    var diagonalLeftBack: DirectedPosition? {
        return self
            .left?
            .back
    }
    
    var diagonalRightBack: DirectedPosition? {
        return self
            .right?
            .back
    }
    
    var frontSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.front
        }
    }
    
    var backSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.back
        }
    }
    
    var leftSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.left
        }
    }
    
    var rightSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.right
        }
    }
    
    var diagonalLeftFrontSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.diagonalLeftFront
        }
    }
    
    var diagonalRightFrontSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.diagonalRightFront
        }
    }
    
    var diagonalLeftBackSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.diagonalLeftBack
        }
    }
    
    var diagonalRightBackSpaces: [DirectedPosition] {
        return allSpaces { position in
            position.diagonalRightBack
        }
    }
}
