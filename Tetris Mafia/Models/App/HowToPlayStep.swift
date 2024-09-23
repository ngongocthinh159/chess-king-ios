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

struct HowToPlayStep: Identifiable {
    let id: Int
    let title: String
    let images: [String]
    let details: [StepDetail]

    struct StepDetail {
        let header: String
        let content: [String]
    }
    
    static func staticStepsEnglish() -> [HowToPlayStep] {
        return [
            HowToPlayStep(id: 1, 
                          title: "Step 1: Setup, Turns, and Taking Pieces", 
                          images: ["step1a"],
                          details: [
                HowToPlayStep.StepDetail(header: "Setup:",
                                         content: ["The board is setup as shown. There should always be a white square at the closest right-hand side for both players. Remember that the queen must be on a square that matches her color."]),
                HowToPlayStep.StepDetail(header: "Turns:",
                                         content: ["White always moves first, and players alternate turns. Players can only move one piece at a time, except when castling (explained later)."]),
                HowToPlayStep.StepDetail(header: "Taking Pieces:",
                                         content: ["Players take pieces when they encounter an opponent in their movement path. Only pawns take differently than they move (explained later). Players cannot take or move through their own pieces."])
            ]),
            
            HowToPlayStep(id: 2,
                          title: "Step 2: Pawn Movement",
                          images: ["step2a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Basic Moves:",
                                                       content: ["Pawns move forward one square, but on their first move, they have the option to move two squares. They cannot move backward. Pawns capture opposing pieces by moving one square diagonally forward."]),
                              HowToPlayStep.StepDetail(header: "Special Moves:",
                                                       content: ["En Passant: A special capture that a pawn can make on the pass. It occurs when an opposing pawn moves two squares forward from its starting position, and lands beside your pawn. Your pawn can capture it as if it had moved only one square forward."]),
                              HowToPlayStep.StepDetail(header: "Pawn Promotion:",
                                                       content: ["When a pawn reaches the furthest rank from its starting position, it must be promoted to any other piece according to the player's choice: queen, rook, bishop, or knight. This does not include another king or pawn."])
                          ]),
            
            HowToPlayStep(id: 3,
                          title: "Step 3: Rook",
                          images: ["step3a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Understanding the Rook:",
                                                       content: ["The Rook moves in straight lines across the board, both horizontally and vertically. This enables it to control large portions of the board if unobstructed. It is most powerful towards the game's middle and end when it can often dominate the board."]),
                              HowToPlayStep.StepDetail(header: "Key strategies:",
                                                       content: ["Utilize the rook to control and limit the movement of the opponent's pieces. Place rooks on open files (columns with no pawns) to maximize their strength. Coordinating two rooks on the same rank (row) or file can be devastating to the opponent."])
                          ]),

            HowToPlayStep(id: 4,
                          title: "Step 4: Knight",
                          images: ["step4a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Understanding the Knight:",
                                                       content: ["The Knight moves in an L-shape: two squares in one direction and then one square perpendicular, or one square in one direction and then two squares perpendicular. This unique movement allows the Knight to 'jump over' other pieces."]),
                              HowToPlayStep.StepDetail(header: "Key strategies:",
                                                       content: ["The Knight is especially powerful in 'closed' positions, where other pieces are blocked by pawns and its ability to jump becomes crucial. Positioning a Knight in the center can threaten numerous spots simultaneously and fork (attack two pieces at once) key opponent pieces."])
                          ]),
            
            HowToPlayStep(id: 5,
                          title: "Step 5: Understanding the Bishop",
                          images: ["step5a"],
                          details: [
                            HowToPlayStep.StepDetail(header: "Movement Basics:",
                                                     content: ["The bishop glides across the board with elegance, moving any number of squares diagonally. It's restricted to the color of the square it starts on, making its movement predictable yet powerful. This unique trait means each bishop operates on either white or black squares throughout the game."]),
                            HowToPlayStep.StepDetail(header: "Strategic Value:",
                                                     content: ["Bishops excel in long-range combat, slicing through the board from corner to corner. They work best on open boards where they can control long diagonals. It's often wise to 'fianchetto' your bishop by placing it on the longest diagonal starting from one of your corners next to the king for defensive and offensive fortitude."])
                          ]),
            
            HowToPlayStep(id: 6,
                          title: "Step 6: Mastering the Queen",
                          images: ["step6a"],
                          details: [
                            HowToPlayStep.StepDetail(header: "Movement Mastery:",
                                                     content: ["The queen, known as the game's most powerful piece, boasts the combined powers of the rook and bishop. She can move any number of squares along a rank, file, or diagonal. This versatility makes her formidable in both attack and defense, capable of controlling vast areas of the board single-handedly."]),
                            HowToPlayStep.StepDetail(header: "Utilizing the Queen",
                                                     content: ["The queen's strength is her ability to participate in multiple aspects of the game from a single position. Use her to exert pressure on critical points, but be wary of exposing her early in the game, as losing the queen can often lead to a disadvantage difficult to overcome."]),
                            HowToPlayStep.StepDetail(header: "Pawn Promotion:",
                                                     content: ["One of the most significant powers of the pawn is its ability to transform into a queen, or any other piece, upon reaching the opposite end of the board. This 'promotion' often leads to strategic shifts in the game, turning a humble pawn into a powerful queen to potentially clinch victory."])
                          ]),
            
            HowToPlayStep(id: 7,
                          title: "Step 7: King",
                          images: ["step7a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Basic Moves:",
                                                       content: ["The king is the most important piece in chess, moving one square in any direction: horizontally, vertically, or diagonally. However, it cannot move into or through a square threatened by an opposing piece."]),
                              ]),
            
            HowToPlayStep(id: 8,
                          title: "Step 8: Special Move: Castling",
                          images: ["step8a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Introduction to Castling:",
                                                       content: ["Castling is a unique chess maneuver and the only move that allows two pieces, the king and a rook, to move at the same time. This move is crucial for player strategy as it serves two main purposes: it moves the king to a safer position away from the center of the board, and it brings the rook into the game."]),
                              
                              HowToPlayStep.StepDetail(header: "Conditions for Castling:",
                                                       content: ["The king moves two squares towards the rook, and then the rook moves to the square next to the king that it passed over. Castling can occur under the following strict conditions:",
                                                                 "1. Neither the king nor the rook has moved earlier in the game.",
                                                                 "2. The king is not currently in check.",
                                                                 "3. The king does not pass through any square that is under attack by enemy pieces.",
                                                                 "4. The king does not end up in check after castling.",
                                                                 "5. All squares between the king and the rook are unoccupied."]),

                              HowToPlayStep.StepDetail(header: "Common Misconceptions:",
                                                       content: ["A. It doesn't matter if the king was in check earlier in the game, as long as it is not in check at the time of castling.",
                                                                 "B. The rook being attacked does not affect the legality of castling, as long as the king's movement conditions are met.",
                                                                 "C. Castling is a strategic asset and can be a defensive or offensive move depending on the game situation."])
                          ]),
            
            HowToPlayStep(id: 9,
                          title: "Step 9: Special Move: En Passant",
                          images: ["step9a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Understanding En Passant:",
                                                       content: ["'En Passant' is a special pawn capture that occurs in a very specific situation designed to prevent a pawn from bypassing an enemy pawn's attack range by moving two squares forward from its initial position. The term 'En Passant' translates to 'in passing' in French, which aptly describes the nature of this capture."]),

                              HowToPlayStep.StepDetail(header: "Conditions for En Passant:",
                                                       content: ["An En Passant capture can only occur under the following conditions:",
                                                                 "1. An enemy pawn moves forward two squares from its original position, ending up next to one of your pawns.",
                                                                 "2. Your pawn must be positioned to attack the square over which the enemy pawn has just moved.",
                                                                 "3. The En Passant capture must be made immediately on the next turn, or the right to do so is lost."]),

                              HowToPlayStep.StepDetail(header: "Strategic Implications:",
                                                       content: ["En Passant is a unique rule that prevents pawns from evading capture by moving two squares forward from their starting position. This move not only helps in maintaining tension in the pawn structure but also can open up vital lines and opportunities for attack. Strategic use of En Passant can significantly alter the dynamics of the game, making it a critical move to understand and master."])
                          ]),
            
            HowToPlayStep(id: 10,
                          title: "Step 10: Check",
                          images: ["step10a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Understanding Check:",
                                                       content: ["A 'check' occurs when a king is under immediate threat of capture by one or more of the opponent's pieces. This is a fundamental aspect of the game of chess and understanding it is crucial for every player."]),

                              HowToPlayStep.StepDetail(header: "Responding to a Check:",
                                                       content: ["When a king is in check, the player must take action to remove the threat on the very next move. There are three possible ways to get out of check:",
                                                                 "1. Move the king to a safer square where it is not threatened.",
                                                                 "2. Block the check by placing a piece between the king and the attacking piece.",
                                                                 "3. Capture the threatening piece, if possible."]),

                              HowToPlayStep.StepDetail(header: "Illegal Moves:",
                                                       content: ["It is illegal to make a move that places or leaves one's king in check. If a move results in the player's own king being in check, it must be retracted and a different move must be made.",
                                                                 "Players must always be alert to the state of their king and ensure it is not left in check after their move."])
                          ]),
            
            HowToPlayStep(id: 11,
                          title: "Step 11: Checkmate",
                          images: ["step11a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Defining Checkmate:",
                                                       content: ["Checkmate occurs when a player's king is placed in check and there is no legal move the player can make to escape the check. Achieving checkmate against the opponent's king is the ultimate goal in chess as it ends the game."]),

                              HowToPlayStep.StepDetail(header: "Conditions for Checkmate:",
                                                       content: ["A king is considered to be in checkmate if:",
                                                                 "1. It is in check—under threat of capture.",
                                                                 "2. No legal moves can remove the threat of capture. This means:",
                                                                 "- The king cannot move to a square that is not under attack.",
                                                                 "- No piece can capture the threatening piece without exposing the king to check from another piece.",
                                                                 "- It is not possible to block the check by moving a piece between the king and the opponent's attacking piece."]),

                              HowToPlayStep.StepDetail(header: "Example of Checkmate:",
                                                       content: ["Consider a scenario where the white queen has the black king in checkmate. The queen places the black king in check, and:",
                                                                 "- All the squares where the king might move are attacked by the queen.",
                                                                 "- The king cannot capture the queen because another piece, such as a knight, protects the queen.",
                                                                 "- No other black piece can block the attack from the queen on the king.",
                                                                 "This configuration leads to checkmate, signaling the end of the game."]),
                          ]),
            
            HowToPlayStep(id: 12,
                          title: "Step 12: Stalemate",
                          images: ["step12a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Understanding Stalemate:",
                                                       content: ["Stalemate is a situation in chess where the player whose turn it is to move is not in check but has no legal moves. This results in a draw, meaning the game ends without a winner."]),

                              HowToPlayStep.StepDetail(header: "Conditions for Stalemate:",
                                                       content: ["A stalemate occurs when:",
                                                                 "1. The player to move has no legal moves.",
                                                                 "2. The player’s king is not in check. If the king were in check, it would be a checkmate situation if no moves could relieve the check.",
                                                                 "3. All possible moves would place the king in check or all non-king pieces are blocked."]),

                              HowToPlayStep.StepDetail(header: "Example of Stalemate:",
                                                       content: ["In this hypothetical endgame scenario:",
                                                                 "It's white's turn to move.",
                                                                 "The white king, positioned such that any move would place it into check, is not currently in check.",
                                                                 "The only other white piece, a pawn, is blocked by the king and cannot advance.",
                                                                 "No legal moves are available, leading to a stalemate. The game thus ends in a draw."])
                          ]),
            
            HowToPlayStep(id: 13,
                          title: "Step 13: Basic Strategy",
                          images: [],
                          details: [
                              HowToPlayStep.StepDetail(header: "Piece Value:",
                                                       content: [
                                                           "Understanding the relative value of chess pieces is crucial for making strategic decisions. Here’s a quick overview:",
                                                           "Queen: Strongest piece, most valuable.",
                                                           "Rook: Next most powerful, especially towards the game's end.",
                                                           "Bishop and Knight: Generally equal, but bishops can sometimes be slightly more valuable depending on the game's position.",
                                                           "Pawn: Least valuable, but their importance increases as they approach promotion."
                                                       ]),
                              
                              HowToPlayStep.StepDetail(header: "Pawn Promotion:",
                                                       content: [
                                                           "Pawns may be promoted upon reaching the farthest row from their starting position. While you can promote a pawn to a queen, rook, bishop, or knight, promoting to a queen is typically the best choice due to her power and range."
                                                       ]),
                              
                              HowToPlayStep.StepDetail(header: "Board Control:",
                                                       content: [
                                                           "Control of the board is essential. Aim to maintain a balanced distribution of power across the board.",
                                                           "Defensively, ensure that your setup can support itself against potential threats. Offensively, avoid isolating your pieces and consider each piece's support before launching an attack."
                                                       ]),

                              HowToPlayStep.StepDetail(header: "General Tips:",
                                                       content: [
                                                           "Use pieces in tandem for more effective attacks. Solo pieces are easier for your opponent to counter.",
                                                           "Try to maintain flexibility in your piece placement, enabling them to defend one another and control key areas of the board."
                                                       ])
                          ]),
            
            
            HowToPlayStep(id: 14,
                          title: "Step 14: Go Play",
                          images: ["step14a"],  // Assuming "goPlay" is an inspiring image that encourages players to start playing.
                          details: [
                              HowToPlayStep.StepDetail(header: "",
                                                       content: [
                                                           "You're equipped with the basics, from piece movement to strategic play. It's time to put your knowledge into action.",
                                                           "Go back to home screen and start a game!. Remember, practice is key to improvement, and every game teaches you something new.",
                                                           "Enjoy your journey into the world of chess. Play, learn, and most importantly, have fun!"
                                                       ])
                          ])
        ]
    }
    
    
    
    
    static func staticStepsVietNamese() -> [HowToPlayStep] {
        return [
            HowToPlayStep(id: 1,
                          title: "Bước 1: Thiết lập, Lượt đi, và Ăn quân",
                          images: ["step1a"],
                          details: [
                HowToPlayStep.StepDetail(header: "Thiết lập:",
                                         content: ["Bàn cờ được thiết lập như hình dưới. Ô trắng luôn nằm ở góc phải bên dưới của mỗi người chơi. Hãy nhớ rằng hậu cần đặt trên ô màu giống màu của nó."]),
                HowToPlayStep.StepDetail(header: "Lượt đi:",
                                         content: ["Người đi màu trắng luôn đi trước, và người chơi thay phiên nhau đi. Mỗi lượt chỉ được di chuyển một quân cờ, ngoại trừ khi nhập thành (sẽ giải thích sau)."]),
                HowToPlayStep.StepDetail(header: "Ăn quân:",
                                         content: ["Người chơi ăn quân khi gặp quân địch trên đường đi của mình. Chỉ có tốt ăn khác với cách di chuyển của chúng (sẽ được giải thích sau). Người chơi không thể ăn hoặc đi qua quân cờ của chính mình."])
            ]),

            HowToPlayStep(id: 2,
                          title: "Bước 2: Di chuyển quân Tốt",
                          images: ["step2a"],
                          details: [
                HowToPlayStep.StepDetail(header: "Nước đi cơ bản:",
                                         content: ["Tốt di chuyển một ô về phía trước, nhưng trong nước đi đầu tiên, chúng có thể chọn di chuyển hai ô. Chúng không thể di chuyển lùi. Tốt ăn quân đối phương bằng cách di chuyển một ô chéo về phía trước."]),
                HowToPlayStep.StepDetail(header: "Nước đi đặc biệt:",
                                         content: ["En Passant: Một nước ăn đặc biệt mà tốt có thể thực hiện trên đường đi. Nó xảy ra khi một quân tốt đối phương di chuyển hai ô từ vị trí xuất phát của nó và dừng lại bên cạnh tốt của bạn. Quân tốt của bạn có thể ăn nó như thể nó chỉ di chuyển một ô về phía trước."]),
                HowToPlayStep.StepDetail(header: "Phong cấp Tốt:",
                                         content: ["Khi một quân tốt đến được hàng cuối cùng từ vị trí xuất phát của nó, nó phải được phong cấp thành bất kỳ quân cờ khác theo lựa chọn của người chơi: hậu, xe, tượng, hoặc mã. Điều này không bao gồm một vua khác hoặc tốt."])
            ]),
            
            HowToPlayStep(id: 3,
                          title: "Bước 3: Xe",
                          images: ["step3a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Hiểu về quân Xe:",
                                                       content: ["Quân Xe di chuyển theo đường thẳng trên bàn cờ, cả ngang lẫn dọc. Điều này cho phép nó kiểm soát phần lớn bàn cờ nếu không bị cản trở. Quân Xe mạnh nhất ở giữa và cuối trận đấu khi nó thường xuyên thống trị bàn cờ."]),
                              HowToPlayStep.StepDetail(header: "Chiến lược chủ chốt:",
                                                       content: ["Sử dụng quân Xe để kiểm soát và hạn chế chuyển động của quân đối phương. Đặt các quân Xe trên các cột mở (các cột không có quân Tốt) để tối đa hóa sức mạnh của chúng. Phối hợp hai quân Xe trên cùng một hàng hoặc cột có thể gây ra thiệt hại nặng nề cho đối thủ."])
                          ]),

            HowToPlayStep(id: 4,
                          title: "Bước 4: Mã",
                          images: ["step4a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Hiểu về quân Mã:",
                                                       content: ["Quân Mã di chuyển hình chữ L: hai ô theo một hướng sau đó một ô vuông góc, hoặc một ô theo một hướng sau đó hai ô vuông góc. Chuyển động độc đáo này cho phép quân Mã 'nhảy qua' các quân cờ khác."]),
                              HowToPlayStep.StepDetail(header: "Chiến lược chủ chốt:",
                                                       content: ["Quân Mã đặc biệt mạnh trong các tình huống 'đóng', nơi các quân cờ khác bị chặn bởi quân Tốt và khả năng nhảy của nó trở nên cần thiết. Đặt quân Mã ở trung tâm có thể đe dọa nhiều điểm cùng một lúc và chọc thủng (tấn công hai quân cùng một lúc) các quân chủ chốt của đối thủ."])
                          ]),
            
            HowToPlayStep(id: 5,
                          title: "Bước 5: Hiểu về Tượng",
                          images: ["step5a"],
                          details: [
                            HowToPlayStep.StepDetail(header: "Cơ bản về Di chuyển:",
                                                     content: ["Quân Tượng lướt trên bàn cờ một cách thanh lịch, di chuyển bất kỳ số ô nào theo đường chéo. Nó bị giới hạn trên màu của ô mà nó bắt đầu, khiến chuyển động của nó có thể đoán trước nhưng vẫn mạnh mẽ. Đặc điểm độc đáo này có nghĩa là mỗi quân Tượng hoạt động trên ô trắng hoặc đen suốt trận đấu."]),
                            HowToPlayStep.StepDetail(header: "Giá trị Chiến lược:",
                                                     content: ["Quân Tượng xuất sắc trong chiến đấu tầm xa, xẻ ngang bàn cờ từ góc này sang góc khác. Chúng hoạt động tốt nhất trên bàn cờ mở, nơi chúng có thể kiểm soát các đường chéo dài. Thường khôn ngoan khi 'fianchetto' quân Tượng của bạn bằng cách đặt nó trên đường chéo dài nhất bắt đầu từ một trong những góc của bạn bên cạnh vua để tăng cường khả năng phòng thủ và tấn công."])
                          ]),

            HowToPlayStep(id: 6,
                          title: "Bước 6: Thành thạo Nữ Hoàng",
                          images: ["step6a"],
                          details: [
                            HowToPlayStep.StepDetail(header: "Thành thạo Di chuyển:",
                                                     content: ["Nữ Hoàng, được biết đến là quân cờ mạnh nhất trong trò chơi, sở hữu sức mạnh kết hợp của quân Xe và Tượng. Cô ấy có thể di chuyển bất kỳ số ô nào dọc theo hàng, cột hoặc đường chéo. Sự linh hoạt này khiến cô ấy trở nên đáng gờm trong cả tấn công và phòng thủ, có khả năng kiểm soát diện rộng bàn cờ một mình."]),
                            HowToPlayStep.StepDetail(header: "Sử dụng Nữ Hoàng",
                                                     content: ["Sức mạnh của Nữ Hoàng là khả năng tham gia vào nhiều khía cạnh của trò chơi từ một vị trí duy nhất. Sử dụng cô ấy để gây áp lực lên các điểm then chốt, nhưng hãy cẩn thận không để lộ cô ấy sớm trong trò chơi, vì mất Nữ Hoàng có thể dẫn đến bất lợi khó khắc phục."]),
                            HowToPlayStep.StepDetail(header: "Phong cấp:",
                                                     content: ["Một trong những quyền lực đáng kể nhất của quân Tốt là khả năng biến đổi thành Nữ Hoàng, hoặc bất kỳ quân cờ khác, khi đạt đến cuối bàn cờ đối phương. Sự 'phong cấp' này thường dẫn đến sự thay đổi chiến lược trong trò chơi, biến một quân Tốt khiêm tốn thành một Nữ Hoàng mạnh mẽ để có thể giành chiến thắng."])
                          ]),
            
            HowToPlayStep(id: 7,
                          title: "Bước 7: Vua",
                          images: ["step7a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Nước đi cơ bản:",
                                                       content: ["Vua là quân cờ quan trọng nhất trong cờ vua, có thể di chuyển một ô theo mọi hướng: ngang, dọc, hoặc chéo. Tuy nhiên, nó không thể di chuyển vào hoặc qua ô nào đang bị quân đối phương đe dọa."]),
                          ]),

            HowToPlayStep(id: 8,
                          title: "Bước 8: Nước đi đặc biệt: Nhập thành",
                          images: ["step8a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Giới thiệu về Nhập thành:",
                                                       content: ["Nhập thành là một thao tác độc đáo trong cờ vua và là nước đi duy nhất cho phép hai quân, vua và xe, di chuyển cùng một lúc. Nước đi này rất quan trọng cho chiến lược của người chơi vì nó phục vụ hai mục đích chính: di chuyển vua vào một vị trí an toàn xa trung tâm bàn cờ và đưa xe vào cuộc chơi."]),

                              HowToPlayStep.StepDetail(header: "Điều kiện để Nhập thành:",
                                                       content: ["Vua di chuyển hai ô về phía xe, và sau đó xe di chuyển vào ô kế bên vua mà nó vừa đi qua. Nhập thành có thể xảy ra dưới các điều kiện chặt chẽ sau:",
                                                                 "1. Cả vua và xe chưa từng di chuyển trước đó trong trận đấu.",
                                                                 "2. Vua không đang bị chiếu.",
                                                                 "3. Vua không đi qua bất kỳ ô nào đang bị quân địch đe dọa.",
                                                                 "4. Vua không kết thúc nước đi trong tình trạng bị chiếu sau khi nhập thành.",
                                                                 "5. Tất cả các ô giữa vua và xe phải trống."]),

                              HowToPlayStep.StepDetail(header: "Những hiểu lầm phổ biến:",
                                                       content: ["A. Không quan trọng nếu vua từng bị chiếu trước trong trận đấu, miễn là không bị chiếu tại thời điểm nhập thành.",
                                                                 "B. Việc xe bị tấn công không ảnh hưởng đến tính hợp lệ của nhập thành, miễn là các điều kiện di chuyển của vua được đáp ứng.",
                                                                 "C. Nhập thành là một tài sản chiến lược và có thể là một động thái phòng thủ hoặc tấn công tùy thuộc vào tình hình trò chơi."])
                          ]),
            
            HowToPlayStep(id: 9,
                          title: "Bước 9: Nước đi đặc biệt: Ăn qua đường",
                          images: ["step9a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Hiểu về Ăn qua đường:",
                                                       content: ["'Ăn qua đường' là một nước ăn tốt cờ đặc biệt xảy ra trong một tình huống cụ thể nhằm ngăn cản tốt đối phương tránh bị tấn công bằng cách đi hai ô từ vị trí ban đầu. Thuật ngữ 'Ăn qua đường' được dịch từ 'en passant' trong tiếng Pháp, mô tả chính xác bản chất của nước ăn này."]),

                              HowToPlayStep.StepDetail(header: "Điều kiện để Ăn qua đường:",
                                                       content: ["Nước ăn qua đường chỉ xảy ra khi các điều kiện sau đây được đáp ứng:",
                                                                 "1. Một tốt địch di chuyển thẳng hai ô từ vị trí gốc, kết thúc cạnh tốt của bạn.",
                                                                 "2. Tốt của bạn phải đứng ở vị trí có thể tấn công ô mà tốt địch vừa đi qua.",
                                                                 "3. Nước ăn qua đường phải được thực hiện ngay trong nước đi tiếp theo, nếu không quyền ăn qua đường sẽ mất."]),

                              HowToPlayStep.StepDetail(header: "Hàm ý chiến lược:",
                                                       content: ["Ăn qua đường là một quy tắc độc đáo ngăn cản tốt tránh bị ăn bằng cách di chuyển hai ô từ vị trí bắt đầu. Nước đi này không chỉ giúp duy trì cấu trúc tốt mà còn có thể mở ra các đường quan trọng và cơ hội tấn công. Sử dụng chiến lược ăn qua đường một cách hiệu quả có thể thay đổi đáng kể động thái của trận đấu, làm cho nó trở thành một nước đi cần hiểu và thành thạo."])
                          ]),
            
            HowToPlayStep(id: 10,
                          title: "Bước 10: Chiếu",
                          images: ["step10a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Hiểu về Chiếu:",
                                                       content: ["'Chiếu' xảy ra khi vua của bạn đang dưới nguy cơ bị bắt bởi một hoặc nhiều quân cờ của đối phương. Đây là một khía cạnh cơ bản của trò chơi cờ vua và việc hiểu biết về nó là cần thiết cho mọi người chơi."]),

                              HowToPlayStep.StepDetail(header: "Phản ứng với Chiếu:",
                                                       content: ["Khi vua bị chiếu, người chơi phải hành động để loại bỏ mối đe dọa trong nước đi tiếp theo. Có ba cách có thể để thoát khỏi chiếu:",
                                                                 "1. Di chuyển vua đến một ô an toàn hơn nơi nó không bị đe dọa.",
                                                                 "2. Chặn chiếu bằng cách đặt một quân cờ giữa vua và quân cờ đang tấn công.",
                                                                 "3. Bắt quân cờ đang đe dọa, nếu có thể."]),

                              HowToPlayStep.StepDetail(header: "Nước đi bất hợp pháp:",
                                                       content: ["Việc thực hiện một nước đi khiến hoặc để cho vua của mình bị chiếu là bất hợp pháp. Nếu một nước đi dẫn đến việc vua của người chơi bị chiếu, nước đi đó phải được rút lại và thực hiện một nước đi khác.",
                                                                 "Người chơi luôn phải cảnh giác với tình trạng của vua mình và đảm bảo rằng nó không bị chiếu sau nước đi của mình."])
                          ]),
            
            HowToPlayStep(id: 11,
                          title: "Bước 11: Chiếu bí",
                          images: ["step11a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Định nghĩa Chiếu bí:",
                                                       content: ["Chiếu bí xảy ra khi vua của người chơi bị đặt vào tình trạng chiếu và không có nước đi hợp lệ nào để thoát khỏi tình trạng chiếu đó. Đạt được chiếu bí đối với vua của đối thủ là mục tiêu cuối cùng trong cờ vua vì nó kết thúc trò chơi."]),

                              HowToPlayStep.StepDetail(header: "Điều kiện cho Chiếu bí:",
                                                       content: ["Vua được coi là đang bị chiếu bí nếu:",
                                                                 "1. Nó đang bị chiếu—dưới mối đe dọa bị bắt.",
                                                                 "2. Không có nước đi hợp lệ nào có thể loại bỏ mối đe dọa bắt. Điều này có nghĩa là:",
                                                                 "- Vua không thể di chuyển đến ô không bị tấn công.",
                                                                 "- Không có quân cờ nào có thể bắt quân cờ đe dọa mà không khiến vua bị chiếu từ quân cờ khác.",
                                                                 "- Không thể chặn chiếu bằng cách di chuyển một quân cờ vào giữa vua và quân cờ tấn công của đối thủ."]),

                              HowToPlayStep.StepDetail(header: "Ví dụ về Chiếu bí:",
                                                       content: ["Xét một tình huống trong đó hậu trắng đặt vua đen vào tình trạng chiếu bí. Hậu đặt vua đen vào chiếu, và:",
                                                                 "- Tất cả các ô mà vua có thể di chuyển đều bị hậu tấn công.",
                                                                 "- Vua không thể bắt hậu vì có quân khác như mã bảo vệ hậu.",
                                                                 "- Không có quân đen nào khác có thể chặn đường tấn công của hậu vào vua.",
                                                                 "Cấu hình này dẫn đến chiếu bí, báo hiệu kết thúc trò chơi."]),
                          ]),
            
            HowToPlayStep(id: 12,
                          title: "Bước 12: Hoà cục",
                          images: ["step12a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "Hiểu về Hoà cục:",
                                                       content: ["Hoà cục là tình huống trong cờ vua khi người chơi đến lượt đi không bị chiếu nhưng không có nước đi hợp lệ. Điều này dẫn đến kết quả hoà, có nghĩa là trận đấu kết thúc mà không có người chiến thắng."]),

                              HowToPlayStep.StepDetail(header: "Điều kiện của Hoà cục:",
                                                       content: ["Hoà cục xảy ra khi:",
                                                                 "1. Người chơi đến lượt không có nước đi hợp lệ.",
                                                                 "2. Vua của người chơi không bị chiếu. Nếu vua bị chiếu, đó sẽ là tình huống chiếu bí nếu không có nước nào có thể giải chiếu.",
                                                                 "3. Tất cả các nước đi có thể sẽ đặt vua vào tình trạng bị chiếu hoặc tất cả các quân cờ khác ngoài vua đều bị chặn."]),

                              HowToPlayStep.StepDetail(header: "Ví dụ về Hoà cục:",
                                                       content: ["Trong tình huống cuối cùng giả định này:",
                                                                 "Đến lượt trắng đi.",
                                                                 "Vua trắng, đặt tại vị trí mà bất kỳ nước đi nào cũng sẽ đưa nó vào tình trạng bị chiếu, không hiện đang bị chiếu.",
                                                                 "Quân cờ trắng duy nhất khác, một quân tốt, bị chặn bởi vua và không thể tiến lên.",
                                                                 "Không có nước đi hợp lệ nào có thể thực hiện, dẫn đến hoà cục. Trận đấu kết thúc với kết quả hoà."])
                          ]),
            
            HowToPlayStep(id: 13,
                          title: "Bước 13: Chiến lược cơ bản",
                          images: [],
                          details: [
                              HowToPlayStep.StepDetail(header: "Giá trị quân cờ:",
                                                       content: [
                                                           "Việc hiểu giá trị tương đối của các quân cờ là rất quan trọng để đưa ra các quyết định chiến lược. Dưới đây là một cái nhìn nhanh:",
                                                           "Hậu: Quân mạnh nhất, giá trị nhất.",
                                                           "Xe: Mạnh thứ hai, đặc biệt vào cuối trận.",
                                                           "Tượng và Mã: Thường ngang bằng nhau, nhưng tượng đôi khi có thể có giá trị cao hơn tùy thuộc vào tình hình trận đấu.",
                                                           "Tốt: Ít giá trị nhất, nhưng tầm quan trọng của chúng tăng lên khi chúng tiến gần đến khả năng thăng cấp."
                                                       ]),
                              
                              HowToPlayStep.StepDetail(header: "Thăng cấp Tốt:",
                                                       content: [
                                                           "Tốt có thể được thăng cấp khi đến hàng cuối cùng từ vị trí xuất phát của chúng. Mặc dù bạn có thể thăng cấp tốt thành hậu, xe, tượng, hoặc mã, nhưng thường thì thăng cấp thành hậu là lựa chọn tốt nhất do sức mạnh và tầm ảnh hưởng của hậu."
                                                       ]),
                              
                              HowToPlayStep.StepDetail(header: "Kiểm soát bàn cờ:",
                                                       content: [
                                                           "Việc kiểm soát bàn cờ là điều cần thiết. Hãy cố gắng duy trì sự cân bằng trong phân bổ sức mạnh trên bàn cờ.",
                                                           "Về phòng thủ, hãy đảm bảo rằng cấu trúc của bạn có thể tự hỗ trợ trước các mối đe dọa tiềm tàng. Về tấn công, hãy tránh cô lập các quân cờ của bạn và xem xét sự hỗ trợ của mỗi quân cờ trước khi tiến hành tấn công."
                                                       ]),

                              HowToPlayStep.StepDetail(header: "Mẹo chung:",
                                                       content: [
                                                           "Sử dụng các quân cờ phối hợp với nhau để tấn công hiệu quả hơn. Các quân cờ đơn lẻ dễ bị đối thủ chống đỡ hơn.",
                                                           "Cố gắng duy trì sự linh hoạt trong việc đặt quân cờ, cho phép chúng bảo vệ lẫn nhau và kiểm soát các khu vực then chốt trên bàn cờ."
                                                       ])
                          ]),
            
            
            HowToPlayStep(id: 14,
                          title: "Bước 14: Hãy Chơi",
                          images: ["step14a"],
                          details: [
                              HowToPlayStep.StepDetail(header: "",
                                                       content: [
                                                           "Bạn đã được trang bị các kiến thức cơ bản, từ cách di chuyển các quân cờ đến chiến thuật chơi. Đã đến lúc áp dụng kiến thức của bạn vào thực tế.",
                                                           "Quay lại màn hình chính và bắt đầu một trận đấu! Nhớ rằng, luyện tập là chìa khóa để tiến bộ, và mỗi trận đấu đều mang lại cho bạn những bài học mới.",
                                                           "Hãy tận hưởng hành trình khám phá thế giới cờ vua của bạn. Chơi, học hỏi và quan trọng nhất, hãy vui vẻ!"
                                                       ])
                          ])
        ]
    }
    
    
    
    
    
    static func previews() -> [HowToPlayStep] {
        return [
            HowToPlayStep(id: 1, title: "Step 1: Setup, Turns, and Taking Pieces", images: ["step1a"], details: [
                HowToPlayStep.StepDetail(header: "Setup:",
                                         content: ["The board is setup as shown. There should always be a white square at the closest right-hand side for both players. Remember that the queen must be on a square that matches her color."]),
                HowToPlayStep.StepDetail(header: "Turns:",
                                         content: ["White always moves first, and players alternate turns. Players can only move one piece at a time, except when castling (explained later)."]),
                HowToPlayStep.StepDetail(header: "Taking Pieces:",
                                         content: ["Players take pieces when they encounter an opponent in their movement path. Only pawns take differently than they move (explained later). Players cannot take or move through their own pieces."])
            ]),
            
            HowToPlayStep(id: 2,
                          title: "Step 2: Pawn Movement",
                          images: ["step1a"],
                          details: [
                HowToPlayStep.StepDetail(header: "",
                                         content: ["Pawns only move forward. On the first move a pawn can move one or two spaces, every subsequent move can only be one space. Pawns move diagonally to take opponents."]),
                HowToPlayStep.StepDetail(header: "Pawn Promotion:",
                                         content: ["If a pawn reaches the opposite side of the board, it is promoted to a higher piece (except king). There is no limit to how many pawns can be promoted."]),
            ]),
        ]
    }
}


