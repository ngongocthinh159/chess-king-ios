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

import SwiftUI

struct TileView: View {
    @Environment(ModelData.self) var modelData
    
    let shouldShowPosition = false
    var viewModel: GameViewModel
    var position: Position
    
    var isCurrentlyHighlighted: Bool {
        return viewModel.selection?.grid[position] ?? false
    }
    
    // MARK: - HIGHTLIGHT colors when waiting for input
    var hightlightColor: Color {
        guard viewModel.selection?.origin != self.position else {
            return modelData.appConfig.titleSelectHightlightColor
        }
        
        guard !isCurrentlyHighlighted else {
            if let piece = viewModel.game.board[self.position], piece.owner != viewModel.game.turn {
                return modelData.appConfig.captureMoveHightlightColor
            } else {
                return modelData.appConfig.validMoveHightlightColor
            }
        }
        
        return Color.clear
    }
    
    var body: some View {
        Button(action: {
            guard self.viewModel.state == .awaitingInput else {
                return
            }
            self.viewModel.select(self.position)
            playBoardTouchMusic()
        }, label: {
            ZStack {
                Color(hex: Board.colors(modelData: modelData)[position])
                
                self.hightlightColor.opacity(0.5)
                
                // MARK: - render piece
                PieceView(piece: self.viewModel.game.board[position])
                    .padding(modelData.appConfig.piecePadding)
                
                VStack {
                    Spacer()
                    
                    Text(shouldShowPosition ? self.position.description : "")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            .border(modelData.appConfig.tileBorderColor, width: modelData.appConfig.tileBorderWidth)
        })
    }
    
    func playBoardTouchMusic() {
        AudioManager.shared.playSoundEffect(filename: modelData.appConfig.boardTouchMusic)
    }
}

#Preview {
    TileView_Previews.previews
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            tileViewWithNoHightlighting()
                .environment(ModelData())
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
    
    static func tileViewWithNoHightlighting() -> some View {
        let vm = GameViewModel(game: .standard, session: SessionManager.previewSession)
        return TileView(viewModel: vm, position: Position(col: .E, row: .four))
    }
}
