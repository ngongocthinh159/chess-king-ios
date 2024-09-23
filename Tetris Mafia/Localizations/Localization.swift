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

extension AppConfig {

    // PlayerPickerView
    func getPlayerPickerView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Welcome Back 🦄"
        case .VN:
            return "Chào Mừng 🦄"
        }
    }
    
    func getPlayerPickerView_ChooseYouAccount_Text() -> String {
        switch self.language {
        case .EN:
            return "Choose your account:"
        case .VN:
            return "Mời chọn tài khoản:"
        }
    }
    
    func getPlayerPickerView_Error_NotChosing_Text() -> String {
        switch self.language {
        case .EN:
            return "*Select an account or register"
        case .VN:
            return "*Chọn một tài khoản hoặc đăng ký"
        }
    }
    
    func getPlayerRowView_LastLogin_Text() -> String {
        switch self.language {
        case .EN:
            return "Last login"
        case .VN:
            return "Đăng nhập cuối"
        }
    }
    
    
    // RegisterView
    func getRegisterView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Register"
        case .VN:
            return "Đăng Ký"
        }
    }
    
    func getRegisterView_InputLabel_Text() -> String {
        switch self.language {
        case .EN:
            return "Username"
        case .VN:
            return "Tên tài khoản"
        }
    }
    
    func getRegisterView_Error_EmptyUsernam_Text() -> String {
        switch self.language {
        case .EN:
            return "*Username can not be empty!"
        case .VN:
            return "*Tên tài khoản bị bỏ trống!"
        }
    }
    
    func getRegisterView_InputPlaceHolder_Text() -> String {
        switch self.language {
        case .EN:
            return "Enter new username"
        case .VN:
            return "Nhập tên tài khoản mới"
        }
    }
    
    
    // SettingsView
    func getSettingsView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Settings"
        case .VN:
            return "Cài đặt"
        }
    }
    
    func getSettingsView_General_Text() -> String {
        switch self.language {
        case .EN:
            return "General"
        case .VN:
            return "Cài đặt chung"
        }
    }
    
    func getSettingsView_SoundFriendlyLabel_Text() -> String {
        switch self.language {
        case .EN:
            return "Sound"
        case .VN:
            return "Âm thanh"
        }
    }
    
    func getSettingsView_LanguageFriendlyLabel_Text() -> String {
        switch self.language {
        case .EN:
            return "Language"
        case .VN:
            return "Ngôn ngữ"
        }
    }
    
    func getSettingsView_AppTheme_Text() -> String {
        switch self.language {
        case .EN:
            return "App Theme"
        case .VN:
            return "Chủ đề ứng dụng"
        }
    }
    
    func getSettingsView_BoardTheme_Text() -> String {
        switch self.language {
        case .EN:
            return "Board Theme"
        case .VN:
            return "Chủ đề trò chơi"
        }
    }
    
    func getSettingsView_AIDifficulty_Text() -> String {
        switch self.language {
        case .EN:
            return "AI Player Difficulty"
        case .VN:
            return "Độ Khó AI Player"
        }
    }
    
    func getSettingsView_AIDescription_Text(difficulty: AIDifficulty) -> String {
        switch difficulty {
        case .easy:
            switch self.language {
            case .EN:
                return "Beginner Friendly: Developed using a basic Minimax algorithm with alpha-beta pruning, this AI provides a manageable challenge, perfect for beginners looking to practice fundamental strategies. Its response time and tactical depth are limited, making it a great starting opponent"
            case .VN:
                return "Thân thiện với người mới bắt đầu: Được phát triển bằng thuật toán Minimax cơ bản với chức năng cắt tỉa alpha-beta, AI này cung cấp một thử thách dễ quản lý, hoàn hảo cho người mới bắt đầu muốn luyện tập các chiến lược cơ bản. Thời gian phản hồi và chiều sâu chiến thuật của nó bị hạn chế, khiến nó trở thành đối thủ khởi đầu tuyệt vời"
            }
            
        case .medium:
            switch self.language {
            case .EN:
                return "Intermediate Challenge: Powered by the renowned Stockfish API, this AI operates at a search depth of 10, equating to an approximate rating of 1800 ELO. It offers a balanced challenge that requires solid tactical and strategic play, suitable for intermediate players"
            case .VN:
                return "Thử thách trung cấp: Được hỗ trợ bởi API Stockfish nổi tiếng, AI này hoạt động ở độ sâu tìm kiếm là 10, tương đương với xếp hạng ELO xấp xỉ 1800. Nó cung cấp một thử thách cân bằng đòi hỏi lối chơi chiến thuật và chiến lược vững chắc, phù hợp với người chơi trung cấp"
            }
            
        case .hard:
            switch self.language {
            case .EN:
                return "Expert Level: Designed for advanced players, this AI uses a deep search of 15 levels, reaching an ELO of around 2563. Its superior strategic planning and tactical execution make it a formidable opponent, providing a stern test for even the most skilled chess enthusiasts"
            case .VN:
                return "Cấp độ chuyên gia: Được thiết kế cho những người chơi nâng cao, AI này sử dụng tìm kiếm sâu ở 15 cấp độ, đạt ELO khoảng 2563. Khả năng lập kế hoạch chiến lược và thực hiện chiến thuật vượt trội khiến nó trở thành đối thủ đáng gờm, mang đến thử thách thực sự cho ngay cả những người đam mê cờ vua có kỹ năng cao nhất"
            }
        }
    }

    
    
    
    // LanguagePickingView
    func getLanguagePickingView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Picking"
        case .VN:
            return "Chọn"
        }
    }
    
    func getLanguagePickingView_SectionTitle_Text() -> String {
        switch self.language {
        case .EN:
            return "Choose A Language:"
        case .VN:
            return "Chọn Ngôn Ngữ:"
        }
    }
    
    
    
    // ProfileView
    func getProfileView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Profile"
        case .VN:
            return "Hồ Sơ"
        }
    }
    
    func getProfileView_YourStats_Text() -> String {
        switch self.language {
        case .EN:
            return "📊 Your Stats"
        case .VN:
            return "📊 Thống Kê"
        }
    }
    
    func getProfileView_YourBadges_Text() -> String {
        switch self.language {
        case .EN:
            return "🔥 Your Badges"
        case .VN:
            return "🔥 Huy Hiệu"
        }
    }
    
    func getProfileView_Stats_TotalGames_Text() -> String {
        switch self.language {
        case .EN:
            return "Total Games"
        case .VN:
            return "Tổng Game Chơi"
        }
    }
    
    func getProfileView_Stats_TotalWins_Text() -> String {
        switch self.language {
        case .EN:
            return "Total Winning"
        case .VN:
            return "Tổng Game Thắng"
        }
    }
    
    func getProfileView_Stats_WinRate_Text() -> String {
        switch self.language {
        case .EN:
            return "Winning Rate"
        case .VN:
            return "Tỷ Lệ Thắng"
        }
    }
    
    func getProfileView_Stats_TotalEnPassantMoves_Text() -> String {
        switch self.language {
        case .EN:
            return "Total En Passant Moves"
        case .VN:
            return "Tổng Bắt Tốt Qua Đường"
        }
    }
    
    func getProfileView_Stats_TotalCastlingMoves_Text() -> String {
        switch self.language {
        case .EN:
            return "Total Castling Moves"
        case .VN:
            return "Tổng Nhập Thành"
        }
    }
    
    func getProfileView_Stats_TotalPromotionMoves_Text() -> String {
        switch self.language {
        case .EN:
            return "Total Promotions Moves"
        case .VN:
            return "Tổng Phong Cấp"
        }
    }
    
    func getProfileView_Scores_Text() -> String {
        switch self.language {
        case .EN:
            return "Scores"
        case .VN:
            return "Điểm"
        }
    }
    
    
    // AvatarPickerView
    func getAvatarPickerView_ChooseAvatar_Text() -> String {
        switch self.language {
        case .EN:
            return "Choose avatar"
        case .VN:
            return "Ảnh đại diện"
        }
    }
    
    
    
    // LeaderboardView
    func getLeaderboardView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Leaders"
        case .VN:
            return "Dẫn Đầu"
        }
    }
    
    func getLeaderboardView_Name_Text() -> String {
        switch self.language {
        case .EN:
            return "Name"
        case .VN:
            return "Tên"
        }
    }
    
    func getLeaderboardView_Badges_Text() -> String {
        switch self.language {
        case .EN:
            return "Badges"
        case .VN:
            return "Huy Hiệu"
        }
    }
    
    func getLeaderboardView_Scores_Text() -> String {
        switch self.language {
        case .EN:
            return "Scores"
        case .VN:
            return "Điểm"
        }
    }
    
    
    // OtherPlayerPickerView
    func getOtherPlayerPickerView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Opponent"
        case .VN:
            return "Đối Thủ"
        }
    }
    
    func getOtherPlayerPickerView_Username_Text() -> String {
        switch self.language {
        case .EN:
            return "Opponent username"
        case .VN:
            return "Tên tài khoản đối thủ"
        }
    }
    
    func getOtherPlayerPickerView_Placeholder_Text() -> String {
        switch self.language {
        case .EN:
            return "Other player username.."
        case .VN:
            return "Nhập tài khoản khác.."
        }
    }
    
    
    
    // MenuView
    func getMenuView_OtherPlayerNameEmptyErroMsg_Text() -> String {
        switch self.language {
        case .EN:
            return "*Other player name can not be empty!"
        case .VN:
            return "*Không được bỏ trống trên người chơi!"
        }
    }
    
    func getMenuView_SamePlayerNameEmptyErroMsg_Text() -> String {
        switch self.language {
        case .EN:
            return "*You can not play against your self!"
        case .VN:
            return "*Bạn không thể chơi với chính mình!"
        }
    }
    
    func getMenuView_PlayerNotFoundErroMsg_Text() -> String {
        switch self.language {
        case .EN:
            return "*Player not found!"
        case .VN:
            return "*Không tìm thấy người chơi!"
        }
    }
    
    
    
    
    // GameView
    func getGameView_PageHeader_Text() -> String {
        switch self.language {
        case .EN:
            return "Game 👑"
        case .VN:
            return "Trận Đấu"
        }
    }
    
    func getGameView_GoBackAlertMessage_Text() -> String {
        switch self.language {
        case .EN:
            return "You can continue later, are you sure to exit?"
        case .VN:
            return "Bạn có thế tiếp tục lúc sau, bạn có chắc muốn thoát?"
        }
    }
    
    
    
    // PlayerInfoInGameView
    func getPlayerInfoInGameView_WinningRate_Text() -> String {
        switch self.language {
        case .EN:
            return "Winning rate"
        case .VN:
            return "Tỷ lệ chiến thắng"
        }
    }
}
