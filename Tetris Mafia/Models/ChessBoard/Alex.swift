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

class Alex: TomHuynh {
    
    override init() {
        super.init()
        self.name = "Alex the clever AI"
        self.wins = 10
    }
    
    override init(name: String, wins: Int) {
        super.init()
        self.name = name
        self.wins = wins
    }
    
    override init(wins: Int) {
        super.init()
        self.name = "Alex the clever AI"
        self.wins = wins
    }
    
    override init(name: String) {
        super.init()
        self.name = name
        self.wins = 10
    }
    
    override func getAPIQueryDepth() -> Int  {
        return 10
    }
}
