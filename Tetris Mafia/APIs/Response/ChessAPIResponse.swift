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

struct ChessAPIResponse: Decodable {
    let from: String
    let to: String
    
//    let move: String
//    let captured: Bool
//    let promotion: Bool
//    let isCapture: Bool
//    let isPromotion: Bool
//    let isCastling: Bool
//    let fen: String
//    let type: String
//    let depth: Int
//    let eval: Double
//    let centipawns: Int
//    let mate: Int?
//    let continuationArr: [String]
//    let debug: String
//    let winChance: Double
//    let taskId: String
//    let turn: String
//    let color: String
//    let piece: String
//    
//    let san: String
//    let flags: String
//    let lan: String
//    let fromNumeric: String
//    let toNumeric: String
//    let continuation: [[String: String]]
}
