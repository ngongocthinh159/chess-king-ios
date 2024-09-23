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

struct BoardView: View {
    @Environment(ModelData.self) var modelData
    
    var viewModel: GameViewModel
    @State private var isShowingPromotion = false
    @State private var selectedPromotionType: PromotionType? = nil
    
    enum PromotionType: CaseIterable, Identifiable {
        case queen, rook, bishop, knight
        
        var id: Self {
            self
        }
    }
    
    func handlePromotion(promotionType: PromotionType, pieceType: PieceType) {
        let piece: Piece.Type
        
        switch promotionType {
        case .queen:
            piece = Queen.self
        case .rook:
            piece = Rook.self
        case .bishop:
            piece = Bishop.self
        case .knight:
            piece = Knight.self
        }
        
        viewModel.handlePromotion(promotionType: piece, pieceType: pieceType)
        isShowingPromotion = false
        selectedPromotionType = nil
    }
    
    func position(row: Int, column: Int) -> Position {
        return Position(gridIndex: IndexPath(row: row, column: column))!
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: modelData.appConfig.spacingBetweenEachTile) {
                ForEach(0..<8) { row in
                    HStack(spacing: modelData.appConfig.spacingBetweenEachTile) {
                        ForEach(0..<8) { column in
                            TileView(viewModel: viewModel, position: self.position(row: row, column: column))
                        }
                    }
                }
            }
            .frame(maxWidth: modelData.appConfig.boardMaxWidth, maxHeight: modelData.appConfig.boardMaxHeight)
            .padding(modelData.appConfig.boardBorderPadding)
            .border(modelData.appConfig.boardBorderColor, width: modelData.appConfig.boardBorderWidth)
            .background {
                modelData.appConfig.boardBGColor
            }
            .cornerRadius(modelData.appConfig.boardCornerRadius)
            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            .onReceive(viewModel.shouldPromptForPromotion, perform: { _ in
                self.isShowingPromotion = true
            })
            .confirmationDialog("Promote", isPresented: $isShowingPromotion) {
                ForEach(PromotionType.allCases) { promotionType in
                    Button(String(describing: promotionType)) {
                        self.selectedPromotionType = promotionType
                    }
                }
                
                // MARK: - default promotion type if canceling
                Button("Cancel", role: .cancel) {
                    self.selectedPromotionType = .queen
                }
            }
            .onChange(of: selectedPromotionType) { _, newPromotionType in
                if let promotionType = newPromotionType {
                    switch promotionType {
                    case .queen:
                        handlePromotion(promotionType: .queen, pieceType: .queen)
                    case .rook:
                        handlePromotion(promotionType: .rook, pieceType: .rook)
                    case .bishop:
                        handlePromotion(promotionType: .bishop, pieceType: .bishop)
                    case .knight:
                        handlePromotion(promotionType: .knight, pieceType: .knight)
                    }
                }
            }
        }
    }
}

#Preview {
    BoardView_Previews.previews
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            boardViewStandardGame()
                .environment(ModelData())
        }
    }
    
    static func boardViewStandardGame() -> some View {
        let vm = GameViewModel(game: .standard, session: SessionManager.previewSession)
        return BoardView(viewModel: vm)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
